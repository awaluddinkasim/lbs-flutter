class User {
  final String nama;
  final String email;

  User({required this.email, required this.nama});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      nama: json['nama'],
    );
  }
}
