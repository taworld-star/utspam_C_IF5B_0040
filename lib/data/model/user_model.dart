class UserModel {
  final int? id;
  final String username;
  final String name;
  final String email;
  final String phone;
  final String password;

  UserModel({
    this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
    );
  }
}