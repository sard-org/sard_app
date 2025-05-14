class UserModel {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;
  final String? phone;
  final String? gender;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
    this.phone,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      imageUrl: json['photo'],
      phone: json['phone'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo': imageUrl,
      'phone': phone,
      'gender': gender,
    };
  }
} 