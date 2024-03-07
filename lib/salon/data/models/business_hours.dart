import 'package:intl/intl.dart';

class BusinessHours {
  String? sTime;
  String? eTime;
  String? date;

  BusinessHours({this.sTime, this.eTime, this.date});

  BusinessHours.fromJson(Map<String, dynamic> json) {
    sTime = json['s_time'];
    eTime = json['e_time'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['s_time'] = sTime;
    data['e_time'] = eTime;
    data['date'] = date;
    return data;
  }

  // 30분 단위로 시간 리스트 생성
  List<String> getTimeSlots() {
    List<String> slots = [];
    DateTime start = DateFormat("HH:mm").parse(sTime!);
    DateTime end = DateFormat("HH:mm").parse(eTime!).add(Duration(minutes: 30));

    while(start.isBefore(end)) {
      slots.add(DateFormat("HH:mm").format(start));
      start = start.add(Duration(minutes: 30));
    }

    return slots;
  }
}
