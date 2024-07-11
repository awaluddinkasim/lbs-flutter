import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locomotive21/cubit/register_state.dart';
import 'package:locomotive21/models/data_user.dart';
import 'package:locomotive21/shared/services/register.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final _registerService = RegisterService();

  RegisterCubit() : super(RegisterInitial());

  Future<void> register(DataUser data) async {
    emit(RegisterLoading());

    try {
      final result = await _registerService.register(data);

      emit(RegisterSuccess(result));
    } catch (e) {
      emit(RegisterFailed(e.toString()));
    }
  }
}
