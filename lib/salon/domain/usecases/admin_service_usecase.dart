import 'package:yjg/salon/data/data_sources/admin/admin_service_data_source.dart';
import 'package:yjg/salon/domain/entities/service.dart';

class ServiceResult {
  final bool isSuccess;
  final String message;

  ServiceResult({required this.isSuccess, required this.message});
}

class ServiceUseCases {
  final AdminServiceDataSource dataSource;

  ServiceUseCases(this.dataSource);

  Future<ServiceResult> createService(Service service) async {
    try {
      final response = await dataSource.postServiceAPI(
        service.categoryId!,
        service.serviceName,
        service.gender,
        service.price,
      );

      if (response.statusCode == 200) {
        return ServiceResult(isSuccess: true, message: '서비스가 성공적으로 생성되었습니다.');
      } else {
        return ServiceResult(isSuccess: false, message: '서비스 생성 실패: ${response.data}');
      }
    } catch (e) {
      return ServiceResult(isSuccess: false, message: '서비스 생성 중 에러 발생: $e');
    }
  }

  Future<ServiceResult> updateService(Service service) async {
    try {
      final response = await dataSource.patchServiceAPI(
        service.serviceId!,
        service.serviceName,
        service.gender,
        service.price,
      );

      if (response.statusCode == 200) {
        return ServiceResult(isSuccess: true, message: '서비스가 성공적으로 업데이트되었습니다.');
      } else {
        return ServiceResult(isSuccess: false, message: '서비스 수정 실패: ${response.data}');
      }
    } catch (e) {
      return ServiceResult(isSuccess: false, message: '서비스 수정 중 에러 발생: $e');
    }
  }

  Future<ServiceResult> deleteService(int serviceId) async {
    try {
      final response = await dataSource.deleteServiceListAPI(serviceId);

      if (response.statusCode == 200) {
        return ServiceResult(isSuccess: true, message: '서비스가 성공적으로 삭제되었습니다.');
      } else {
        return ServiceResult(isSuccess: false, message: '서비스 삭제 실패: ${response.data}');
      }
    } catch (e) {
      return ServiceResult(isSuccess: false, message: '서비스 삭제 중 에러 발생: $e');
    }
  }
}
