import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yjg/bus/data/data_sources/bus_data_source.dart';
import 'package:yjg/bus/data/models/bus.dart';
import 'package:yjg/bus/domain/usecases/bus_usecase.dart';

// 기본 선택값 바탕으로 초기화
final semesterProvider = StateProvider<int>((ref) => 1); // 학기: 1, 방학: 0
final weekendProvider = StateProvider<int>((ref) => 0); // 평일: 0, 주말: 1
final routeProvider = StateProvider<String>((ref) => 's_bokhyun'); // 복현: 's_bokhyun', 영어: 's_english'

class BusViewModel extends ChangeNotifier {
  final BusScheduleUseCase _busScheduleUseCase;

  // 데이터 상태를 AsyncValue로 선언
  AsyncValue<Schedules> busSchedules = AsyncValue.data(Schedules(busRounds: []));

  BusViewModel(this._busScheduleUseCase);

  Future<void> fetchBusSchedules(int weekend, int semester, String route) async {
    busSchedules = AsyncValue.loading();
    notifyListeners();

    try {
      final schedules = await _busScheduleUseCase.getBusSchedules(weekend, semester, route);
      busSchedules = AsyncValue.data(schedules);
    } catch (e, s) {
      busSchedules = AsyncValue.error(e, s);
      debugPrint('error: $e, stack: $s');
    }
    notifyListeners();
  }
}

final busViewModelProvider = ChangeNotifierProvider((ref) {
  final busDataSource = BusDataSource();
  final busScheduleUseCase = BusScheduleUseCase(busDataSource);
  final viewModel = BusViewModel(busScheduleUseCase);
  
  // 초기 데이터 로딩
  viewModel.fetchBusSchedules(0, 1, 's_bokhyun');
  
  return viewModel;
});

