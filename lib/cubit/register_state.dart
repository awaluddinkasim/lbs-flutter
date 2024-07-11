import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final String success;

  const RegisterSuccess(this.success);

  @override
  List<Object> get props => [success];
}

class RegisterFailed extends RegisterState {
  final String message;

  const RegisterFailed(this.message);

  @override
  List<Object> get props => [message];
}
