class ScheduleItem {
  String station;
  String busTime;
  int busRoundId;

  ScheduleItem({
    required this.station,
    required this.busTime,
    required this.busRoundId,
  });

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      station: json['station'],
      busTime: json['bus_time'],
      busRoundId: json['bus_round_id'],
    );
  }
}

class BusRound {
  String roundName;
  List<ScheduleItem> scheduleItems;

  BusRound({
    required this.roundName,
    required this.scheduleItems,
  });

  factory BusRound.fromJson(String roundName, List<dynamic> jsonList) {
    List<ScheduleItem> scheduleItems = jsonList
        .map((scheduleItemJson) => ScheduleItem.fromJson(scheduleItemJson))
        .toList();
    return BusRound(roundName: roundName, scheduleItems: scheduleItems);
  }
}

class Schedules {
  List<BusRound> busRounds;

  Schedules({required this.busRounds});

  factory Schedules.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> schedulesJson = json['schedules']; // 'schedules' 키 아래의 맵을 추출합니다.
    List<BusRound> busRounds = schedulesJson.entries.map((entry) {
      String roundName = entry.key;
      List<dynamic> scheduleItemsJson = entry.value;
      return BusRound.fromJson(roundName, scheduleItemsJson); // BusRound.fromJson 메서드가 올바르게 List<dynamic> 타입을 받도록 합니다.
    }).toList();
    return Schedules(busRounds: busRounds);
  }
}

