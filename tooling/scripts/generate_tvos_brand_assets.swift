#!/usr/bin/env swift
//
// Builds the Apple TV brand assets from the app icon source.
//
//   swift tooling/scripts/generate_tvos_brand_assets.swift [--preview <dir>]
//
// Run from the repository root. Rewrites
// ios/PathOfNurTV/Assets.xcassets/AppIcon.brandassets in full.
//
// tvOS does not accept a flat icon. It wants two layered image stacks
// (400x240 for the home screen, 1280x768 for the App Store) and two Top Shelf
// images, each full-bleed: the system rounds the corners and moves the layers
// against each other as the icon takes focus. The phone icon has its rounded
// corners painted in, so it cannot be resized into place. This script lifts
// the lantern and book off the phone icon and paints the night sky and the
// halo behind them as separate layers.
//
// Output is deterministic: the same source gives the same files.

import AppKit
import CoreImage
import CoreText
import Foundation
import ImageIO
import UniformTypeIdentifiers
import Vision

// MARK: - Paths

let fileManager = FileManager.default
let root = URL(fileURLWithPath: fileManager.currentDirectoryPath)
let sourceURL = root.appendingPathComponent("tooling/app_icon_sources/app_icondarkv2.png")
let fontURL = root.appendingPathComponent("assets/fonts/Lora-SemiBold.ttf")
let catalogURL = root.appendingPathComponent(
  "ios/PathOfNurTV/Assets.xcassets/AppIcon.brandassets"
)

var previewURL: URL?
let arguments = CommandLine.arguments
if let flag = arguments.firstIndex(of: "--preview"), arguments.count > flag + 1 {
  previewURL = URL(fileURLWithPath: arguments[flag + 1])
}

func fail(_ message: String) -> Never {
  FileHandle.standardError.write(Data("generate_tvos_brand_assets: \(message)\n".utf8))
  exit(1)
}

guard fileManager.fileExists(atPath: sourceURL.path) else {
  fail("missing \(sourceURL.path); run from the repository root")
}

// MARK: - Drawing helpers

let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
let ciContext = CIContext(options: [.workingColorSpace: colorSpace])

func makeContext(width: Int, height: Int, opaque: Bool) -> CGContext {
  let alpha: CGImageAlphaInfo = opaque ? .noneSkipLast : .premultipliedLast
  guard let context = CGContext(
    data: nil,
    width: width,
    height: height,
    bitsPerComponent: 8,
    bytesPerRow: 0,
    space: colorSpace,
    bitmapInfo: alpha.rawValue
  ) else { fail("could not create a \(width)x\(height) canvas") }
  context.interpolationQuality = .high
  return context
}

func cgImage(_ image: CIImage) -> CGImage {
  guard let result = ciContext.createCGImage(image, from: image.extent) else {
    fail("could not render an image")
  }
  return result
}

func writePNG(_ image: CGImage, to url: URL) {
  try? fileManager.createDirectory(
    at: url.deletingLastPathComponent(),
    withIntermediateDirectories: true
  )
  guard let destination = CGImageDestinationCreateWithURL(
    url as CFURL, UTType.png.identifier as CFString, 1, nil
  ) else { fail("could not open \(url.path)") }
  CGImageDestinationAddImage(destination, image, nil)
  guard CGImageDestinationFinalize(destination) else { fail("could not write \(url.path)") }
}

func writeJSON(_ object: Any, to url: URL) {
  try? fileManager.createDirectory(
    at: url.deletingLastPathComponent(),
    withIntermediateDirectories: true
  )
  guard let data = try? JSONSerialization.data(
    withJSONObject: object,
    options: [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
  ) else { fail("could not encode \(url.lastPathComponent)") }
  try? (data + Data("\n".utf8)).write(to: url)
}

/// Small repeatable generator, so the star field is the same on every run.
struct SeededGenerator {
  var state: UInt64
  mutating func next() -> CGFloat {
    state = state &* 6364136223846793005 &+ 1442695040888963407
    return CGFloat((state >> 33) % 100_000) / 100_000
  }
}

// MARK: - Source

guard let loaded = CIImage(contentsOf: sourceURL) else { fail("could not read the icon source") }

/// The source has rounded corners on black painted into it. Work from the
/// square inside them.
let inset = loaded.extent.width * 0.075
let interior = loaded
  .cropped(to: loaded.extent.insetBy(dx: inset, dy: inset))
  .transformed(by: CGAffineTransform(translationX: -inset, y: -inset))

func liftSubject(from image: CIImage) -> CIImage {
  let handler = VNImageRequestHandler(ciImage: image)
  let request = VNGenerateForegroundInstanceMaskRequest()
  do {
    try handler.perform([request])
    guard let observation = request.results?.first else {
      fail("no subject found in the icon source")
    }
    let buffer = try observation.generateMaskedImage(
      ofInstances: observation.allInstances,
      from: handler,
      croppedToInstancesExtent: true
    )
    return CIImage(cvPixelBuffer: buffer)
  } catch {
    fail("subject lift failed: \(error.localizedDescription)")
  }
}

let subject = cgImage(liftSubject(from: interior))

// MARK: - Layers

func color(_ hex: UInt32, alpha: CGFloat = 1) -> CGColor {
  CGColor(
    srgbRed: CGFloat((hex >> 16) & 0xFF) / 255,
    green: CGFloat((hex >> 8) & 0xFF) / 255,
    blue: CGFloat(hex & 0xFF) / 255,
    alpha: alpha
  )
}

/// The night sky, painted from the app's midnight palette (`TVPalette.midnight`)
/// so the icon and the app behind it are the same night. Opaque and full-bleed.
func skyLayer(width: Int, height: Int) -> CGImage {
  let target = CGRect(x: 0, y: 0, width: width, height: height)
  let context = makeContext(width: width, height: height, opaque: true)

  let sky = CGGradient(
    colorsSpace: colorSpace,
    colors: [color(0x121423), color(0x262C46), color(0x1A1F33)] as CFArray,
    locations: [0, 0.46, 1]
  )!
  context.drawLinearGradient(
    sky,
    start: CGPoint(x: 0, y: 0),
    end: CGPoint(x: 0, y: target.height),
    options: []
  )

  var generator = SeededGenerator(state: 0x5EED_0F_A11A)
  let starCount = Int(110 * target.width / target.height / (1280.0 / 768.0))
  for _ in 0..<starCount {
    let x = generator.next() * target.width
    let y = generator.next() * target.height
    let radius = (0.7 + generator.next() * 1.5) * target.height / 768
    let alpha = 0.22 + generator.next() * 0.58
    context.setFillColor(color(0xEFE8D7, alpha: alpha))
    context.fillEllipse(in: CGRect(
      x: x - radius, y: y - radius, width: radius * 2, height: radius * 2
    ))
  }
  return context.makeImage()!
}

/// The halo: a warm glow and the ring of light around the lantern.
func drawHalo(in context: CGContext, centre: CGPoint, height: CGFloat) {
  let glow = CGGradient(
    colorsSpace: colorSpace,
    colors: [
      color(0xF2C46B, alpha: 0.62),
      color(0xE2A95A, alpha: 0.22),
      color(0xE2A95A, alpha: 0),
    ] as CFArray,
    locations: [0, 0.48, 1]
  )!
  context.drawRadialGradient(
    glow,
    startCenter: centre, startRadius: 0,
    endCenter: centre, endRadius: height * 0.56,
    options: []
  )

  let ringRadius = height * 0.41
  let ring = CGRect(
    x: centre.x - ringRadius, y: centre.y - ringRadius,
    width: ringRadius * 2, height: ringRadius * 2
  )
  context.saveGState()
  context.setShadow(offset: .zero, blur: height * 0.03, color: color(0xE2C177, alpha: 0.9))
  context.setStrokeColor(color(0xF0DCA8, alpha: 0.78))
  context.setLineWidth(max(1, height * 0.005))
  context.strokeEllipse(in: ring)
  context.restoreGState()
}

func haloLayer(width: Int, height: Int) -> CGImage {
  let context = makeContext(width: width, height: height, opaque: false)
  drawHalo(
    in: context,
    centre: CGPoint(x: CGFloat(width) / 2, y: CGFloat(height) * 0.52),
    height: CGFloat(height)
  )
  return context.makeImage()!
}

/// Where the lantern and book sit for a given canvas height and centre.
func subjectFrame(centre: CGPoint, height: CGFloat, fill: CGFloat) -> CGRect {
  let drawnHeight = height * fill
  let drawnWidth = drawnHeight * CGFloat(subject.width) / CGFloat(subject.height)
  return CGRect(
    x: centre.x - drawnWidth / 2,
    y: centre.y - drawnHeight / 2,
    width: drawnWidth,
    height: drawnHeight
  )
}

func subjectLayer(width: Int, height: Int) -> CGImage {
  let context = makeContext(width: width, height: height, opaque: false)
  context.draw(subject, in: subjectFrame(
    centre: CGPoint(x: CGFloat(width) / 2, y: CGFloat(height) * 0.49),
    height: CGFloat(height),
    fill: 0.78
  ))
  return context.makeImage()!
}

// MARK: - Top Shelf

CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)

func topShelf(width: Int, height: Int) -> CGImage {
  let canvas = CGSize(width: width, height: height)
  let context = makeContext(width: width, height: height, opaque: true)
  context.draw(
    skyLayer(width: width, height: height),
    in: CGRect(origin: .zero, size: canvas)
  )

  let subjectCentre = CGPoint(x: canvas.width * 0.30, y: canvas.height * 0.50)
  drawHalo(in: context, centre: subjectCentre, height: canvas.height)
  context.draw(subject, in: subjectFrame(
    centre: subjectCentre, height: canvas.height, fill: 0.80
  ))

  let font = CTFontCreateWithName("Lora-SemiBold" as CFString, canvas.height * 0.17, nil)
  let attributes: [NSAttributedString.Key: Any] = [
    .font: font,
    .foregroundColor: color(0xEFE8D7),
  ]
  let line = CTLineCreateWithAttributedString(
    NSAttributedString(string: "Path of Nūr", attributes: attributes)
  )
  let bounds = CTLineGetBoundsWithOptions(line, .useOpticalBounds)
  context.saveGState()
  context.setShadow(
    offset: CGSize(width: 0, height: -canvas.height * 0.006),
    blur: canvas.height * 0.03,
    color: color(0x121423, alpha: 0.7)
  )
  context.textPosition = CGPoint(
    x: canvas.width * 0.49,
    y: canvas.height * 0.50 - bounds.midY
  )
  CTLineDraw(line, context)
  context.restoreGState()
  return context.makeImage()!
}

// MARK: - Catalog

let info: [String: Any] = ["author": "xcode", "version": 1]

try? fileManager.removeItem(at: catalogURL)

func writeStack(named name: String, width: Int, height: Int, scales: [Int]) {
  let stackURL = catalogURL.appendingPathComponent("\(name).imagestack")
  let layers: [(String, (Int, Int) -> CGImage)] = [
    ("Front", subjectLayer),
    ("Middle", haloLayer),
    ("Back", skyLayer),
  ]
  writeJSON(
    ["info": info, "layers": layers.map { ["filename": "\($0.0).imagestacklayer"] }],
    to: stackURL.appendingPathComponent("Contents.json")
  )
  for (layerName, draw) in layers {
    let layerURL = stackURL.appendingPathComponent("\(layerName).imagestacklayer")
    writeJSON(["info": info], to: layerURL.appendingPathComponent("Contents.json"))
    let imagesetURL = layerURL.appendingPathComponent("Content.imageset")
    var images: [[String: Any]] = []
    for scale in scales {
      let fileName = "\(layerName.lowercased())-\(width)x\(height)@\(scale)x.png"
      writePNG(
        draw(width * scale, height * scale),
        to: imagesetURL.appendingPathComponent(fileName)
      )
      images.append(["filename": fileName, "idiom": "tv", "scale": "\(scale)x"])
    }
    writeJSON(
      ["images": images, "info": info],
      to: imagesetURL.appendingPathComponent("Contents.json")
    )
  }
}

func writeTopShelf(named name: String, width: Int, height: Int) {
  let imagesetURL = catalogURL.appendingPathComponent("\(name).imageset")
  var images: [[String: Any]] = []
  for scale in [1, 2] {
    let fileName = "top-shelf-\(width)x\(height)@\(scale)x.png"
    writePNG(
      topShelf(width: width * scale, height: height * scale),
      to: imagesetURL.appendingPathComponent(fileName)
    )
    images.append(["filename": fileName, "idiom": "tv", "scale": "\(scale)x"])
  }
  writeJSON(
    ["images": images, "info": info],
    to: imagesetURL.appendingPathComponent("Contents.json")
  )
}

writeStack(named: "App Icon", width: 400, height: 240, scales: [1, 2])
writeStack(named: "App Icon - App Store", width: 1280, height: 768, scales: [1])
writeTopShelf(named: "Top Shelf Image", width: 1920, height: 720)
writeTopShelf(named: "Top Shelf Image Wide", width: 2320, height: 720)

writeJSON(
  [
    "assets": [
      [
        "filename": "App Icon - App Store.imagestack",
        "idiom": "tv",
        "role": "primary-app-icon",
        "size": "1280x768",
      ],
      [
        "filename": "App Icon.imagestack",
        "idiom": "tv",
        "role": "primary-app-icon",
        "size": "400x240",
      ],
      [
        "filename": "Top Shelf Image Wide.imageset",
        "idiom": "tv",
        "role": "top-shelf-image-wide",
        "size": "2320x720",
      ],
      [
        "filename": "Top Shelf Image.imageset",
        "idiom": "tv",
        "role": "top-shelf-image",
        "size": "1920x720",
      ],
    ],
    "info": info,
  ],
  to: catalogURL.appendingPathComponent("Contents.json")
)

// MARK: - Preview

if let previewURL {
  let width = 1280
  let height = 768
  let frame = CGRect(x: 0, y: 0, width: width, height: height)
  let context = makeContext(width: width, height: height, opaque: true)
  context.draw(skyLayer(width: width, height: height), in: frame)
  context.draw(haloLayer(width: width, height: height), in: frame)
  context.draw(subjectLayer(width: width, height: height), in: frame)
  writePNG(context.makeImage()!, to: previewURL.appendingPathComponent("tv-icon-flat.png"))
  writePNG(
    subjectLayer(width: width, height: height),
    to: previewURL.appendingPathComponent("tv-icon-front.png")
  )
  writePNG(
    topShelf(width: 2320, height: 720),
    to: previewURL.appendingPathComponent("tv-top-shelf-wide.png")
  )
}

print("Apple TV brand assets written to \(catalogURL.path)")
