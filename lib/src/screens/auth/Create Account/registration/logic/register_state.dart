abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}

// حالات تسجيل المستخدم
class RegisterLoadingState extends RegisterStates {}
class RegisterSuccessState extends RegisterStates {
  final String message;
  final String email;

  RegisterSuccessState({required this.message, required this.email});
}
class RegisterErrorState extends RegisterStates {
  final String error;

  RegisterErrorState({required this.error});
}

// حالات التحقق من الرمز (OTP)
class OtpSendingState extends RegisterStates {}
class OtpSentSuccessState extends RegisterStates {
  final String message;

  OtpSentSuccessState({required this.message});
}
class OtpSendErrorState extends RegisterStates {
  final String error;

  OtpSendErrorState({required this.error});
}

// حالات التحقق من صحة OTP
class OtpVerificationLoadingState extends RegisterStates {}
class OtpVerificationSuccessState extends RegisterStates {
  final String message;

  OtpVerificationSuccessState({required this.message});
}
class OtpVerificationErrorState extends RegisterStates {
  final String error;
  final int attemptsLeft; // عدد المحاولات المتبقية

  OtpVerificationErrorState({required this.error, this.attemptsLeft = 0});
}

// حالة تجاوز الحد الأقصى للمحاولات
class MaxAttemptsReachedState extends RegisterStates {}

// حالات عامة
class TimerTickState extends RegisterStates {
  final int secondsRemaining;

  TimerTickState({required this.secondsRemaining});
}

class PasswordsNotMatchingState extends RegisterStates {}