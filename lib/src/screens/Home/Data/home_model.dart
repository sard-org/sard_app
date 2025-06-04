class UserModelhome {
  final String name;
  final String photo;
  final int streak;
  final int points;

  UserModelhome({
    required this.name,
    required this.photo,
    required this.streak,
    required this.points,
  });

  factory UserModelhome.fromJson(Map<String, dynamic> json) {
    return UserModelhome(
      name: json['name'] ?? '',
      photo: json['photo'] ?? '',
      streak: json['streak'] ?? 0,
      points: json['points'] ?? 0,
    );
  }
}
