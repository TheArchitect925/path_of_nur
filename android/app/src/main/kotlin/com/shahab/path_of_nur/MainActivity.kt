package com.shahab.path_of_nur

import android.graphics.ImageFormat
import com.google.mlkit.vision.common.InputImage
import com.google.mlkit.vision.label.ImageLabeling
import com.google.mlkit.vision.label.defaults.ImageLabelerOptions
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val IMAGE_LABELING_CHANNEL = "path_of_nur/creation_image_labeling"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            IMAGE_LABELING_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "detectLabels" -> handleDetectLabels(call, result)
                else -> result.notImplemented()
            }
        }
    }

    private fun handleDetectLabels(call: MethodCall, result: MethodChannel.Result) {
        val args = call.arguments as? Map<*, *>
        if (args == null) {
            result.error("bad_args", "Expected map arguments", null)
            return
        }

        val width = (args["width"] as? Number)?.toInt()
        val height = (args["height"] as? Number)?.toInt()
        val rotation = (args["rotation"] as? Number)?.toInt() ?: 0
        val format = (args["format"] as? Number)?.toInt() ?: ImageFormat.NV21
        val confidenceThreshold = (args["confidenceThreshold"] as? Number)?.toFloat() ?: 0.7f
        val planes = args["planes"] as? List<*>
        val firstPlane = planes?.firstOrNull() as? Map<*, *>
        val bytes = firstPlane?.get("bytes") as? ByteArray

        if (width == null || height == null || bytes == null) {
            result.error("bad_args", "Missing image payload", null)
            return
        }
        if (format != ImageFormat.NV21 && format != ImageFormat.YV12) {
            result.error("unsupported_format", "Expected NV21 or YV12 camera frames", format)
            return
        }

        val image = InputImage.fromByteArray(
            bytes,
            width,
            height,
            rotation,
            format,
        )
        val options = ImageLabelerOptions.Builder()
            .setConfidenceThreshold(confidenceThreshold)
            .build()
        val labeler = ImageLabeling.getClient(options)

        labeler.process(image)
            .addOnSuccessListener { labels ->
                val payload = labels.map { label ->
                    mapOf(
                        "label" to label.text,
                        "confidence" to label.confidence.toDouble(),
                    )
                }
                result.success(payload)
                labeler.close()
            }
            .addOnFailureListener { error ->
                result.error("android_image_labeling", error.localizedMessage, null)
                labeler.close()
            }
    }
}
