import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sard/src/screens/auth/Create%20Account/registration/logic/register_state.dart';
import '../../otp/data/dio_otp_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  final DioClient _dioClient = DioClient();

  // متغيرات لتخزين البيانات
  String _registeredEmail = '';
  Timer? _otpTimer;
  // تعديل مدة المؤقت إلى 10 دقائق (600 ثانية)
  int _secondsRemaining = 600;
  int _otpAttempts = 0; // عدد محاولات إدخال الرمز
  bool _isSendingOtp = false;

  // الحصول على قيمة البريد الإلكتروني المسجل
  String get registeredEmail => _registeredEmail;

  // الحصول على الوقت المتبقي للرمز
  int get secondsRemaining => _secondsRemaining;

  // الحصول على عدد المحاولات المتبقية
  int get remainingAttempts => 3 - _otpAttempts;

  // دالة تسجيل مستخدم جديد
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // التحقق من تطابق كلمة المرور
    if (password != confirmPassword) {
      emit(PasswordsNotMatchingState());
      return;
    }

    emit(RegisterLoadingState());

    try {
      final response = await _dioClient.register(
        name: name,
        email: email,
        password: password,
      );

      _registeredEmail = email; // حفظ البريد الإلكتروني للاستخدام في OTP

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(RegisterSuccessState(
          message: response.data['message'] ?? 'تم التسجيل بنجاح',
          email: email,
        ));
      } else {
        emit(RegisterErrorState(error: response.data['message'] ?? 'حدث خطأ أثناء التسجيل'));
      }
    } on DioException catch (e) {
      String errorMsg = 'حدث خطأ أثناء التسجيل';

      if (e.response != null) {
        errorMsg = e.response?.data['message'] ?? errorMsg;
      }

      emit(RegisterErrorState(error: errorMsg));
    } catch (e) {
      emit(RegisterErrorState(error: 'حدث خطأ غير متوقع، الرجاء المحاولة مرة أخرى'));
    }
  }

  // دالة إرسال رمز التحقق OTP
  Future<void> sendOtp({required String email}) async {
    if (_isSendingOtp) return; // حماية من التكرار
    _isSendingOtp = true;

    emit(OtpSendingState());

    try {
      _registeredEmail = email;
      final response = await _dioClient.validateEmail(email: email);

      if (response.statusCode == 200) {
        _otpAttempts = 0;
        emit(OtpSentSuccessState(
          message: response.data['message'] ?? 'تم إرسال رمز التحقق بنجاح',
        ));
        startOtpTimer();
      } else {
        emit(OtpSendErrorState(error: response.data['message'] ?? 'فشل في إرسال رمز التحقق'));
      }
    } on DioException catch (e) {
      String errorMsg = 'فشل في إرسال رمز التحقق';
      if (e.response != null) {
        errorMsg = e.response?.data['message'] ?? errorMsg;
      }
      emit(OtpSendErrorState(error: errorMsg));
    } catch (e) {
      emit(OtpSendErrorState(error: 'حدث خطأ غير متوقع، الرجاء المحاولة مرة أخرى'));
    }
    _isSendingOtp = false;
  }

  // دالة التحقق من رمز OTP
  Future<void> verifyOtp({required String otp}) async {
    emit(OtpVerificationLoadingState());

    // التأكد من وجود بريد إلكتروني مسجل
    if (_registeredEmail.isEmpty) {
      emit(OtpVerificationErrorState(
          error: 'خطأ: البريد الإلكتروني غير متوفر، الرجاء المحاولة مرة أخرى',
          attemptsLeft: remainingAttempts
      ));
      return;
    }

    // زيادة عدد المحاولات
    _otpAttempts++;

    try {
      final response = await _dioClient.validateEmailOtp(
        email: _registeredEmail,
        code: otp,
      );

      if (response.statusCode == 200) {
        emit(OtpVerificationSuccessState(
          message: response.data['message'] ?? 'تم التحقق بنجاح',
        ));
        cancelOtpTimer(); // إلغاء المؤقت بعد نجاح التحقق
      } else {
        // إرسال عدد المحاولات المتبقية مع رسالة الخطأ
        emit(OtpVerificationErrorState(
            error: response.data['message'] ?? 'رمز التحقق غير صحيح',
            attemptsLeft: remainingAttempts
        ));
      }
    } on DioException catch (e) {
      String errorMsg = 'فشل في التحقق من الرمز';

      if (e.response != null) {
        errorMsg = e.response?.data['message'] ?? errorMsg;
      }

      emit(OtpVerificationErrorState(
          error: errorMsg,
          attemptsLeft: remainingAttempts
      ));
    } catch (e) {
      emit(OtpVerificationErrorState(
          error: 'حدث خطأ غير متوقع، الرجاء المحاولة مرة أخرى',
          attemptsLeft: remainingAttempts
      ));
    }

    // التحقق من تجاوز الحد الأقصى للمحاولات
    if (_otpAttempts >= 3) {
      emit(MaxAttemptsReachedState());
      // إعادة إرسال رمز OTP جديد بعد تجاوز الحد
      Future.delayed(const Duration(seconds: 2), () {
        sendOtp(email: _registeredEmail);
      });
    }
  }

  // بدء مؤقت لرمز التحقق (10 دقائق = 600 ثانية)
  void startOtpTimer() {
    _secondsRemaining = 600; // تعديل المدة إلى 10 دقائق
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        emit(TimerTickState(secondsRemaining: _secondsRemaining));
      } else {
        _otpTimer?.cancel();
      }
    });
  }

  // إلغاء مؤقت رمز التحقق
  void cancelOtpTimer() {
    _otpTimer?.cancel();
    _otpTimer = null;
  }

  // إعادة إرسال رمز التحقق
  void resendOtp() {
    if (_secondsRemaining == 0 && _registeredEmail.isNotEmpty) {
      sendOtp(email: _registeredEmail);
    }
  }

  @override
  Future<void> close() {
    cancelOtpTimer();
    return super.close();
  }
}