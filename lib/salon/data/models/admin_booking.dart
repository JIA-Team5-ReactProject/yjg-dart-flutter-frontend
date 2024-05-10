class Reservation {
  final int id;
  final int salonServiceId;
  final int userId;
  final String reservationDate;
  final String reservationTime;
  final String status;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;
  final String userName;
  final String serviceName;
  final String price;
  final String gender;
  final String phoneNumber;

  Reservation({
    required this.id,
    required this.salonServiceId,
    required this.userId,
    required this.reservationDate,
    required this.reservationTime,
    required this.status,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.userName,
    required this.serviceName,
    required this.price,
    required this.gender,
    required this.phoneNumber,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      salonServiceId: json['salon_service_id'],
      userId: json['user_id'],
      reservationDate: json['reservation_date'],
      reservationTime: json['reservation_time'],
      status: json['status'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      userName: json['user_name'],
      serviceName: json['service_name'],
      price: json['price'],
      gender: json['gender'],
      phoneNumber: json['phone_number'],
    );
  }
}

class ReservationResponse {
  final List<Reservation> reservations;

  ReservationResponse({
    required this.reservations,
  });

  factory ReservationResponse.fromJson(Map<String, dynamic> json) {
    List<Reservation> reservationsList = [];
    if (json['reservations'] != null) {
      json['reservations'].forEach((reservationJson) {
        reservationsList.add(Reservation.fromJson(reservationJson));
      });
    }
    return ReservationResponse(reservations: reservationsList);
  }
}
