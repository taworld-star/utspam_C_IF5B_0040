class RentalModel {
  final int? id;
  final int userId;
  final int carId;
  final String carName;
  final String renterName;
  final int rentalDays;
  final DateTime startDate;
  final DateTime endDate;
  final int totalPrice;
  final String status; // 'active', 'completed', 'cancelled'
  final DateTime createdAt;

  RentalModel({
    this.id,
    required this.userId,
    required this.carId,
    required this.carName,
    required this.renterName,
    required this.rentalDays,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    this.status = 'active',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'car_id': carId,
      'car_name': carName,
      'renter_name': renterName,
      'rental_days': rentalDays,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory RentalModel.fromMap(Map<String, dynamic> map) {
    return RentalModel(
      id: map['id'],
      userId: map['user_id'],
      carId: map['car_id'],
      carName: map['car_name'],
      renterName: map['renter_name'],
      rentalDays: map['rental_days'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      totalPrice: map['total_price'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}