class DataLogin {
  final String email;
  final String password;

  DataLogin({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}
