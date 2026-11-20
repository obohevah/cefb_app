package com.example.church_app

import android.app.PictureInPictureParams
import android.content.res.Configuration
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.church.app/pip"
    private var methodChannel: MethodChannel? = null
    private var isInPipMode = false
    private var pipAspectRatio = Rational(16, 9)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "enterPipMode" -> {
                    val width = call.argument<Int>("width") ?: 16
                    val height = call.argument<Int>("height") ?: 9
                    val success = enterPip(width, height)
                    result.success(success)
                }
                "isInPipMode" -> {
                    result.success(isInPipMode)
                }
                "isPipSupported" -> {
                    val supported = Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
                            packageManager.hasSystemFeature(android.content.pm.PackageManager.FEATURE_PICTURE_IN_PICTURE)
                    result.success(supported)
                }
                "enableAutoPip" -> {
                    val enable = call.argument<Boolean>("enable") ?: false
                    updateAutoPipParams(enable)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun enterPip(width: Int, height: Int): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return false
        }
        return try {
            pipAspectRatio = Rational(width, height)
            val params = PictureInPictureParams.Builder()
                .setAspectRatio(pipAspectRatio)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                params.setAutoEnterEnabled(true)
            }
            enterPictureInPictureMode(params.build())
        } catch (e: Exception) {
            false
        }
    }

    private var autoPipEnabled = false

    private fun updateAutoPipParams(enable: Boolean) {
        autoPipEnabled = enable
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            try {
                val params = PictureInPictureParams.Builder()
                    .setAspectRatio(pipAspectRatio)
                    .setAutoEnterEnabled(enable)
                    .build()
                setPictureInPictureParams(params)
            } catch (e: Exception) {
                // Ignore if not supported
            }
        }
    }

    override fun onPictureInPictureModeChanged(
        isInPictureInPictureMode: Boolean,
        newConfig: Configuration?
    ) {
        super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
        isInPipMode = isInPictureInPictureMode
        methodChannel?.invokeMethod("onPipModeChanged", isInPictureInPictureMode)
    }

    override fun onUserLeaveHint() {
        super.onUserLeaveHint()
        // On Android 8.0 - 11, entering PiP on home press happens in onUserLeaveHint
        if (Build.VERSION.SDK_INT in Build.VERSION_CODES.O..Build.VERSION_CODES.R && autoPipEnabled && !isInPipMode) {
            enterPip(pipAspectRatio.numerator, pipAspectRatio.denominator)
        }
    }
}
