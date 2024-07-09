import 'package:locomotive21/models/user.dart';

class Auth {
  final String token;
  final User user;

  const Auth({required this.token, required this.user});
}
