abstract class RegisterScreenState {}

class RegisterInitial extends RegisterScreenState {}

class RegisterLoading extends RegisterScreenState {}

class RegisterSuccess extends RegisterScreenState {
  final String message;

  RegisterSuccess(this.message);
}

class RegisterError extends RegisterScreenState {
  final String error;

  RegisterError(this.error);
}
