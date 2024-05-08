package com.example.yjg

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log  // Log 클래스를 사용하기 위해 추가

class MainActivity: FlutterActivity() {

    // 플랫폼 채널 이름 설정
    private val CHANNEL = "com.example.yjg/navigation"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            // 인텐트에서 페이지 정보 가져오기
            val page = intent.getStringExtra("openPage")
            
            // 로그 출력: 인텐트로부터 받은 페이지 정보
            Log.d("MainActivity", "Page received from intent: $page")

            if (page != null) {
                // 결과 성공으로 페이지 정보 반환
                result.success(page)
                // 로그 추가: 성공적으로 페이지 정보를 반환
                Log.d("MainActivity", "Successfully returned page from intent")
            } else {
                // 페이지 정보가 없는 경우 에러 반환
                result.error("ERROR", "No page specified in intent", null)
                // 로그 추가: 에러 정보 출력
                Log.d("MainActivity", "Failed to find 'openPage' in intent")
            }
        }
    }
}