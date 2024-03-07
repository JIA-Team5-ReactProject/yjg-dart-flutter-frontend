class Reservation {
  final int serviceId;
  final String reservationDate;
  final String reservationTime;

  Reservation({
    required this.serviceId,
    required this.reservationDate,
    required this.reservationTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'reservation_date': reservationDate,
      'reservation_time': reservationTime,
    };
  }
}
