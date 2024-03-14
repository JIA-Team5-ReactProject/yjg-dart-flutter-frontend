class Schedule {
  final Map<String, List<Round>> schedules;

  Schedule({required this.schedules});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    Map<String, List<Round>> tempSchedules = {};
    json['schedules'].forEach((key, value) {
      List<Round> rounds = (value as List).map((e) => Round.fromJson(e)).toList();
      tempSchedules[key] = rounds;
    });
    return Schedule(schedules: tempSchedules);
  }
}

class Round {
  final String station;
  final String busTime;
  final int busRoundId;

  Round({required this.station, required this.busTime, required this.busRoundId});

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      station: json['station'],
      busTime: json['bus_time'],
      busRoundId: json['bus_round_id'],
    );
  }
}
