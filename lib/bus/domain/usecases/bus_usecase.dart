import 'dart:convert';

import 'package:yjg/bus/data/data_sources/bus_data_source.dart';
import 'package:yjg/bus/data/models/bus.dart';

class BusScheduleUseCase {
  final BusDataSource _busDataSource;

  BusScheduleUseCase(this._busDataSource);

  Future<Schedules> getBusSchedules(int weekend, int semester, String route) async {
    final response = await _busDataSource.getBusDataAPI(weekend, semester, route);
    final schedulesData = response.data;
    return Schedules.fromJson(schedulesData);
  }
}
