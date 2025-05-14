abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {
  final String message;

  ChangePasswordSuccess(this.message);
}

class ChangePasswordError extends ChangePasswordState {
  final String message;

  ChangePasswordError(this.message);
}