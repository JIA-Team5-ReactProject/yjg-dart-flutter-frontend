import 'package:yjg/as(admin)/data/data_sources/as_status_data_source.dart';
import 'package:yjg/as(admin)/domain/entities/status.dart';


class StatusResult {
  final bool isSuccess;
  final String message;

  StatusResult({required this.isSuccess, required this.message});
}

class StatusUseCases {
  final StatusDataSource dataSource;

  StatusUseCases(this.dataSource);

  Future<StatusResult> patchStatus(Status status) async {
    try {
      final response = await dataSource.patchStatusAPI(
        status.serviceId!,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return StatusResult(isSuccess: true, message: '상태가 성공적으로 변경되었습니다.');
      } else {
        return StatusResult(
            isSuccess: false, message: '상태 변경 실패: ${response.body}');
      }
    } catch (e) {
      return StatusResult(isSuccess: false, message: '상태 변경 중 에러 발생: $e');
    }
  }
}
