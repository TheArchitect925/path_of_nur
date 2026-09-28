import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = scene as? UIWindowScene else { return }
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      super.scene(scene, willConnectTo: session, options: connectionOptions)
      return
    }

    let engine = appDelegate.ensureFlutterEngineStarted()
    registerSceneLifeCycle(with: engine)

    let window = UIWindow(windowScene: windowScene)
    let flutterViewController = FlutterViewController(
      engine: engine,
      nibName: nil,
      bundle: nil
    )
    // Until Flutter draws its first frame the view shows its own background.
    // The launch storyboard's ground, not black, so the dawn sequence starts
    // from the colour the launch screen already painted.
    flutterViewController.view.backgroundColor =
      UIColor(named: "LaunchBackground") ?? flutterViewController.view.backgroundColor
    window.rootViewController = flutterViewController
    self.window = window
    window.makeKeyAndVisible()

    super.scene(scene, willConnectTo: session, options: connectionOptions)

    if let url = connectionOptions.urlContexts.first?.url {
      appDelegate.handleIncomingRouteURL(url)
    }
  }

  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    super.scene(scene, openURLContexts: URLContexts)
    guard let url = URLContexts.first?.url else { return }
    AppDelegate.shared?.handleIncomingRouteURL(url)
  }
}
