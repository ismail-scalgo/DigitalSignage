package com.zignflix.player

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.zignflix.player"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "isTV") {
                val pm = applicationContext.packageManager
                val isTV = pm.hasSystemFeature("android.software.leanback")
                result.success(isTV)
            } else {
                result.notImplemented()
            }
        }
    }
}