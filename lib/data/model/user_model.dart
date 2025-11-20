class UserModel {
  final int? id;
  final String name;
  final String nik;
  final String email;
  final String phone;
  final String address;
  final String username;
  final String password;

  UserModel({
    this.id,
    required this.name,
    required this.nik,
    required this.email,
    required this.phone,
    required this address,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'nik': nik,
      'email': email,
      'phone': phone,
      'password': password,
      'address' : address,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      name: map['name'],
      nik: map['nik'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
      address: map['address']
    );
  }
}