import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yjg/auth/data/data_resources/user_data_source.dart';
import 'package:yjg/auth/presentation/viewmodels/user_viewmodel.dart';
import 'package:yjg/shared/theme/palette.dart';

class UpdateUserInfoUseCase {
  WidgetRef ref;
  UpdateUserInfoUseCase({required this.ref});

  Future<void> execute({
    // 객체를 받음
    required change,
    required BuildContext context,
  }) async {
    // User 상태 업데이트
    ref.read(userProvider.notifier).additionalInfoFormUpdate(change: change);

    // SecureStorage에서 토큰 가져오기
    final storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');
    final userType = await storage.read(key: 'userType');

    if (token == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 정보가 유효하지 않습니다. 다시 로그인해 주세요.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // 업데이트 API 호출
    final dataSource = UserDataSource(); // DataSource 인스턴스 생성

    try {
      // userType에 따라 API 호출
      userType == 'student'
          ? await dataSource.patchAdditionalInfoAPI(ref, change)
          : await dataSource.patchAdminInfoAPI(ref, change);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('정보 업데이트에 성공하였습니다.'),
              backgroundColor: Palette.mainColor),
        );
      
    } catch (e) {
      // 추가정보 입력 시 에러 메시지 표시
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('추가 정보 입력 실패. 다시 시도해 주세요. 에러: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
