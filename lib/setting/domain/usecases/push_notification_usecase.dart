import 'package:yjg/setting/data/data_sources/fcm_token_datasource.dart';

class PushNotificationUseCase {
  final FcmTokenDataSource dataSource;

  PushNotificationUseCase(this.dataSource);

  // * Push 알림 허용 여부 업데이트
  Future<void> call(bool push) async {
    await dataSource.patchPushNotificationAPI(push);
  }
}
