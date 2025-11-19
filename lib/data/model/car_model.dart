class CarModel {
  final int? id;
  final String name;
  final String type;
  final String image;
  final int pricePerDay;
  final int year;
  final String transmission;
  final int seats;
  final bool isAvailable;

  CarModel({
    this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.pricePerDay,
    required this.year,
    required this.transmission,
    required this.seats,
    this.isAvailable = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'image': image,
      'price_per_day': pricePerDay,
      'year': year,
      'transmission': transmission,
      'seats': seats,
      'is_available': isAvailable ? 1 : 0,
    };
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      image: map['image'],
      pricePerDay: map['price_per_day'],
      year: map['year'],
      transmission: map['transmission'],
      seats: map['seats'],
      isAvailable: map['is_available'] == 1,
    );
  }
}