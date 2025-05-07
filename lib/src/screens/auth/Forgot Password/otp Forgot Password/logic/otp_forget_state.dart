abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState {}

class OtpSuccess extends OtpState {
  final dynamic data;
  final String? token;
  final String? resetToken;

  OtpSuccess({
    required this.data,
    this.token,
    this.resetToken,
  });
}

class OtpResendSuccess extends OtpState {
  final String message;

  OtpResendSuccess(this.message);
}

class OtpError extends OtpState {
  final String message;

  OtpError(this.message);
}