package com.Mhmd.mstra

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import android.view.WindowManager.LayoutParams

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Add the FLAG_SECURE to prevent screenshots and screen recording
        window.setFlags(
            LayoutParams.FLAG_SECURE,
            LayoutParams.FLAG_SECURE
        )
    }
}