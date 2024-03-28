import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/auth/data/data_resources/register_data_source.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

class DetailUseCase {
  WidgetRef ref;
  DetailUseCase({required this.ref});

  Future<void> execute({
    required String studentId,
    required String phoneNumber,
    required BuildContext context,
  }) async {
    // User 상태 업데이트
    ref.read(userProvider.notifier).additionalInfoFormUpdate(
      studentId: studentId,
      phoneNumber: phoneNumber,
    );

    // SecureStorage에서 토큰 가져오기
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'auth_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 정보가 유효하지 않습니다. 다시 로그인해 주세요.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // 추가 정보 입력 API 호출
    try {
      final dataSource = RegisterDataSource(); // DataSource 인스턴스 생성
      final response = await dataSource.patchAdditionalInfoAPI(ref, token);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('회원가입에 성공하였습니다.'),
              backgroundColor: Palette.mainColor),
        );
        // 성공 시 메인 페이지로 이동(이전 페이지로 못 가게 막아버림)
        Navigator.pushNamedAndRemoveUntil(context, '/dashboard_main', (Route<dynamic> route) => false);
      } else {
        throw Exception('서버 에러: ${response.statusCode}');
      }
    } catch (e) {
      // 추가정보 입력 시 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('추가 정보 입력 실패. 다시 시도해 주세요. 에러: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
