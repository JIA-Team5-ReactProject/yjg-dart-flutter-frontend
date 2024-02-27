
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/auth/data/data_resources/register_data_source.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

class DetailUseCase {
  final WidgetRef ref;

  DetailUseCase({required this.ref});

  Future<void> execute({
    required String studentId,
    required String name,
    required String phoneNumber,
    required BuildContext context,

  }) async {
    // User 상태 업데이트를 위해 userProvider를 통해 User 인스턴스에 접근
    ref.read(userProvider.notifier).additionalInfoFormUpdate(
          studentId: studentId,
          name: name,
          phoneNumber: phoneNumber,
        );

    /// 추가 정보 입력 로직
    try {
      await RegisterDataSource().patchAdditionalInfoAPI(ref);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('회원가입에 성공하였습니다.'),
            backgroundColor: Palette.mainColor),
      );
      // 성공 시 메인 페이지로 이동
      Navigator.pushNamed(context, '/dashboard_main');
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

