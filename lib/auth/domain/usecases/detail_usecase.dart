import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/data/data_resources/user_data_source.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

class DetailUseCase {
  WidgetRef ref;
  DetailUseCase({required this.ref});

  Future<void> execute({
    required change,
    required BuildContext context,
  }) async {
    // User 상태 업데이트
    ref.read(userProvider.notifier).additionalInfoFormUpdate(
          change: change,
        );

    // 추가 정보 입력 API 호출
    try {
      final dataSource = UserDataSource(); // DataSource 인스턴스 생성
      final response = await dataSource.patchAdditionalInfoAPI(ref, change);

      if (context.mounted) {
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('회원가입에 성공하였습니다. 다시 로그인해 주세요.'),
                backgroundColor: Palette.mainColor),
          );
          // 성공 시 메인 페이지로 이동(이전 페이지로 못 가게 막아버림)
          Navigator.pushNamedAndRemoveUntil(
              context, '/login_student', (Route<dynamic> route) => false);
        } else {
          throw Exception('서버 에러: ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('추가 정보 입력에 실패했습니다. : $e');
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
