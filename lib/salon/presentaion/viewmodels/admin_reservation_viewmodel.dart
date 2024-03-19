import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:yjg/salon/data/data_sources/admin/admin_reservation_data_source.dart';
import 'package:yjg/salon/domain/usecases/admin_reservation_usecase.dart';
import 'package:yjg/salon/data/models/admin_booking.dart';

final reservationViewModelProvider = StateNotifierProvider<ReservationViewModel, AsyncValue<List<Reservation>>>((ref) {
  return ReservationViewModel(ref.read(fetchReservationsUseCaseProvider));
});

final fetchReservationsUseCaseProvider = Provider((ref) => FetchReservationsUseCase(AdminReservationDataSource()));

class ReservationViewModel extends StateNotifier<AsyncValue<List<Reservation>>> {
  final FetchReservationsUseCase _fetchReservationsUseCase;

  ReservationViewModel(this._fetchReservationsUseCase) : super(AsyncValue.loading()) {
    // 현재 날짜로 초기 데이터 로딩
    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    fetchReservations(reservationDate: currentDate);
  }

  Future<void> fetchReservations({required String reservationDate}) async {
    state = AsyncValue.loading();
    try {
      final reservations = await _fetchReservationsUseCase(reservationDate);
      state = AsyncValue.data(reservations);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

