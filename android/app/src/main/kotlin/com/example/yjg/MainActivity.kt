package com.example.yjg

import android.os.Bundle
import android.content.SharedPreferences
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import com.auth0.android.jwt.JWT
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.yjg/navigation"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // MethodChannel 설정
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "getInitialPage") {
                    val page = getInitialPage()
                    Log.d("MainActivity", "Page determined based on token: $page")
                    if (page != null) {
                        result.success(page)
                        Log.d("MainActivity", "Successfully returned page: $page")
                    } else {
                        result.error("ERROR", "No page specified", null)
                        Log.d("MainActivity", "Failed to determine page")
                    }
                }
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
    }

    private fun getInitialPage(): String? {
        val masterKey = MasterKey.Builder(this)
            .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
            .build()

        val sharedPreferences: SharedPreferences = EncryptedSharedPreferences.create(
            this,
            "secret_shared_prefs",
            masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )

        val token = sharedPreferences.getString("auth_token", null)
        val openPage = intent.getStringExtra("openPage")
        return if (token != null && !isTokenExpired(token)) {
            openPage // 토큰이 유효하면 인텐트에 지정된 페이지로 이동
        } else {
            "/login" // 토큰이 없거나 만료되었으면 로그인 페이지 설정
        }
    }

    private fun isTokenExpired(token: String): Boolean {
        return try {
            val jwt = JWT(token)
            jwt.isExpired(10) // 토큰이 만료되었는지 확인 (10초 유예)
        } catch (e: Exception) {
            true // 토큰 디코딩 실패 시 만료된 것으로 간주
        }
    }
}
