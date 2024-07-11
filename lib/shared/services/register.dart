import 'package:locomotive21/models/data_user.dart';
import 'package:locomotive21/shared/utils/dio.dart';

class RegisterService {
  Future<String> register(DataUser user) async {
    final result = await Request.post('/register', data: user.toJson());

    return result['success'];
  }
}
