import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sard/src/screens/auth/Forgot%20Password/password_reset_api_service.dart';
import 'package:sard/src/screens/auth/Forgot%20Password/password_reset_states.dart';

class ForgetPasswordCubit extends Cubit<PasswordResetState> {
  final PasswordResetApiService _apiService;
  String? _email;

  ForgetPasswordCubit(this._apiService) : super(ForgetPasswordInitial());

  String? get email => _email;

  Future<void> sendResetEmail(String email) async {
    if (email.isEmpty) {
      emit(const ForgetPasswordError('الرجاء إدخال البريد الإلكتروني'));
      return;
    }

    emit(ForgetPasswordLoading());

    try {
      final success = await _apiService.sendResetEmail(email);

      if (success) {
        _email = email;
        emit(ForgetPasswordSuccess(email));
      } else {
        emit(const ForgetPasswordError('فشل في إرسال رمز التحقق. يرجى المحاولة مرة أخرى.'));
      }
    } catch (e) {
      String errorMessage = 'حدث خطأ: ${e.toString()}';
      if (e is String) {
        errorMessage = e;
      }
      emit(ForgetPasswordError(errorMessage));
    }
  }
}

class OtpVerificationCubit extends Cubit<PasswordResetState> {
  final PasswordResetApiService _apiService;
  String? _email;

  OtpVerificationCubit(this._apiService) : super(OtpVerificationInitial());

  void setEmail(String email) {
    _email = email;
  }

  String? get email => _email;

  Future<void> verifyOtp(String otp) async {
    if (_email == null) {
      emit(const OtpVerificationError('البريد الإلكتروني غير متوفر. يرجى العودة وإعادة المحاولة.'));
      return;
    }

    emit(OtpVerificationLoading());

    try {
      final success = await _apiService.validateOtp(_email!, otp);

      if (success) {
        emit(OtpVerificationSuccess(_email!));
      } else {
        emit(const OtpVerificationError('رمز التحقق غير صحيح. يرجى المحاولة مرة أخرى.'));
      }
    } catch (e) {
      emit(OtpVerificationError('حدث خطأ: ${e.toString()}'));
    }
  }

  void resendOtp() async {
    if (_email == null) {
      emit(const OtpVerificationError('البريد الإلكتروني غير متوفر. يرجى العودة وإعادة المحاولة.'));
      return;
    }

    try {
      await _apiService.sendResetEmail(_email!);
      // We don't need to change state here as we just want to restart the timer
    } catch (e) {
      emit(OtpVerificationError('حدث خطأ في إعادة إرسال الرمز: ${e.toString()}'));
    }
  }
}

class CreatePasswordCubit extends Cubit<PasswordResetState> {
  final PasswordResetApiService _apiService;
  String? _email;

  CreatePasswordCubit(this._apiService) : super(CreatePasswordInitial());

  void setEmail(String email) {
    _email = email;
  }

  Future<void> createNewPassword(String password, String confirmPassword) async {
    if (_email == null) {
      emit(const CreatePasswordError('البريد الإلكتروني غير متوفر. يرجى العودة وإعادة المحاولة.'));
      return;
    }

    if (password != confirmPassword) {
      emit(const CreatePasswordError('كلمات المرور غير متطابقة'));
      return;
    }

    // Validate password strength
    RegExp uppercaseRegExp = RegExp(r'[A-Z]');
    RegExp lowercaseRegExp = RegExp(r'[a-z]');
    RegExp digitRegExp = RegExp(r'\d');
    RegExp symbolRegExp = RegExp(r'[@#$%^&+=]');

    if (!uppercaseRegExp.hasMatch(password)) {
      emit(const CreatePasswordError('يجب أن تحتوي كلمة المرور على حرف كبير'));
      return;
    } else if (!lowercaseRegExp.hasMatch(password)) {
      emit(const CreatePasswordError('يجب أن تحتوي كلمة المرور على حرف صغير'));
      return;
    } else if (!digitRegExp.hasMatch(password)) {
      emit(const CreatePasswordError('يجب أن تحتوي كلمة المرور على رقم'));
      return;
    } else if (!symbolRegExp.hasMatch(password)) {
      emit(const CreatePasswordError('يجب أن تحتوي كلمة المرور على رمز خاص'));
      return;
    }

    emit(CreatePasswordLoading());

    try {
      final success = await _apiService.resetPassword(_email!, password);

      if (success) {
        emit(CreatePasswordSuccess());
      } else {
        emit(const CreatePasswordError('فشل في تعيين كلمة المرور الجديدة. يرجى المحاولة مرة أخرى.'));
      }
    } catch (e) {
      emit(CreatePasswordError('حدث خطأ: ${e.toString()}'));
    }
  }
}