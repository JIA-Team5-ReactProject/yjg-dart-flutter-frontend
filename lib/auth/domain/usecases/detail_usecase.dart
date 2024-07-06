import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
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
                content: Text('googleLogin.isSuccess'.tr()),
                backgroundColor: Palette.mainColor),
          );
          // 성공 시 메인 페이지로 이동(이전 페이지로 못 가게 막아버림)
          Navigator.pushNamedAndRemoveUntil(
              context, '/login_student', (Route<dynamic> route) => false);
        }
      }
    } on DioException catch (e) {
      final message = e.response!.data['error'];

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // 추가정보 입력 시 에러 메시지 표시
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('googleLogin.isFailed'.tr()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
