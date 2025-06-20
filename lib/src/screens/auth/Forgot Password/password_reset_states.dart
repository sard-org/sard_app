import 'package:equatable/equatable.dart';

// Base state class for all password reset states
abstract class PasswordResetState extends Equatable {
  const PasswordResetState();

  @override
  List<Object?> get props => [];
}

// States for the email submission screen
class ForgetPasswordInitial extends PasswordResetState {}

class ForgetPasswordLoading extends PasswordResetState {}

class ForgetPasswordSuccess extends PasswordResetState {
  final String email;

  const ForgetPasswordSuccess(this.email);

  @override
  List<Object?> get props => [email];
}

class ForgetPasswordError extends PasswordResetState {
  final String message;

  const ForgetPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

// States for OTP verification screen
class OtpVerificationInitial extends PasswordResetState {}

class OtpVerificationLoading extends PasswordResetState {}

class OtpVerificationSuccess extends PasswordResetState {
  final String email;

  const OtpVerificationSuccess(this.email);

  @override
  List<Object?> get props => [email];
}

class OtpVerificationError extends PasswordResetState {
  final String message;
  final int attemptsLeft;

  const OtpVerificationError(this.message, {this.attemptsLeft = 0});

  @override
  List<Object?> get props => [message, attemptsLeft];
}

// States for creating new password
class CreatePasswordInitial extends PasswordResetState {}

class CreatePasswordLoading extends PasswordResetState {}

class CreatePasswordSuccess extends PasswordResetState {}

class CreatePasswordError extends PasswordResetState {
  final String message;

  const CreatePasswordError(this.message);

  @override
  List<Object?> get props => [message];
}