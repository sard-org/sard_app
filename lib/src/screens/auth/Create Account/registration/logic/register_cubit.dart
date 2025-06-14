import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sard/src/screens/auth/Create%20Account/registration/logic/register_state.dart';
import '../../otp/data/dio_otp_helper.dart';
import '../../../../../utils/error_translator.dart';

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
  // تعيين البريد الإلكتروني المسجل (للاستخدام عند الانتقال من شاشة أخرى)
  void setRegisteredEmail(String email) {
    _registeredEmail = email;
  }

  // إعادة تعيين محاولات OTP (للاستخدام عند بدء عملية جديدة)
  void resetOtpAttempts() {
    _otpAttempts = 0;
  }

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
        // The API returns user object directly without a message field when successful
        if (response.data != null && response.data['id'] != null) {
          emit(RegisterSuccessState(
            message: 'تم التسجيل بنجاح',
            email: email,
          ));
          // Note: Backend automatically sends OTP email upon registration
          // Start timer for OTP screen
          startOtpTimer();
        } else {
          emit(RegisterErrorState(
              error: 'حدث خطأ أثناء التسجيل: بيانات الاستجابة غير صالحة'));
        }
      } else {
        emit(RegisterErrorState(
            error: response.data['message'] ?? 'حدث خطأ أثناء التسجيل'));
      }
    } on DioException catch (e) {
      String errorMsg = 'حدث خطأ أثناء التسجيل';

      if (e.response != null) {
        // Get the raw error message from server
        String serverMessage = e.response?.data['message'] ?? errorMsg;
        // Translate the error message to Arabic
        errorMsg = ErrorTranslator.translateErrorWithContext(
            serverMessage, e.response?.statusCode);
      }

      emit(RegisterErrorState(error: errorMsg));
    } catch (e) {
      emit(RegisterErrorState(
          error: 'حدث خطأ غير متوقع، الرجاء المحاولة مرة أخرى'));
    }
  }

  // دالة إرسال رمز التحقق OTP (للاستخدام في إعادة الإرسال فقط)
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
        emit(OtpSendErrorState(
            error: response.data['message'] ?? 'فشل في إرسال رمز التحقق'));
      }
    } on DioException catch (e) {
      String errorMsg = 'فشل في إرسال رمز التحقق';
      if (e.response != null) {
        // Get the raw error message from server
        String serverMessage = e.response?.data['message'] ?? errorMsg;
        // Translate the error message to Arabic
        errorMsg = ErrorTranslator.translateErrorWithContext(
            serverMessage, e.response?.statusCode);
      }
      emit(OtpSendErrorState(error: errorMsg));
    } catch (e) {
      emit(OtpSendErrorState(
          error: 'حدث خطأ غير متوقع، الرجاء المحاولة مرة أخرى'));
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
          attemptsLeft: remainingAttempts));
      return;
    }

    // زيادة عدد المحاولات
    _otpAttempts++;

    try {
      final response = await _dioClient.validateEmailOtp(
        email: _registeredEmail,
        code: otp,
      );

      // Check for successful response (200 status with success status)
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['status'] == 'success') {
        // Reset attempts on success
        _otpAttempts = 0;
        emit(OtpVerificationSuccessState(
          message: response.data['message'] ?? 'تم التحقق بنجاح',
        ));
        cancelOtpTimer();
        return; // Exit early on success
      } else {
        // Handle error cases - both 400 status and 200 with non-success status
        String errorMessage = 'رمز التحقق غير صحيح';
        if (response.data != null && response.data['message'] != null) {
          errorMessage = response.data['message'];
        }

        emit(OtpVerificationErrorState(
            error: errorMessage, attemptsLeft: remainingAttempts));
      }
    } on DioException catch (e) {
      String errorMsg = 'فشل في التحقق من الرمز';
      if (e.response != null && e.response?.data != null) {
        // Handle 400 Bad Request with "Invalid code" message
        if (e.response?.statusCode == 400) {
          String serverMessage =
              e.response?.data['message'] ?? 'رمز التحقق غير صحيح';
          errorMsg = ErrorTranslator.translateErrorWithContext(
              serverMessage, e.response?.statusCode);
        } else {
          String serverMessage = e.response?.data['message'] ?? errorMsg;
          errorMsg = ErrorTranslator.translateErrorWithContext(
              serverMessage, e.response?.statusCode);
        }
      }

      emit(OtpVerificationErrorState(
          error: errorMsg, attemptsLeft: remainingAttempts));
    } catch (e) {
      emit(OtpVerificationErrorState(
          error: 'حدث خطأ غير متوقع، الرجاء المحاولة مرة أخرى',
          attemptsLeft: remainingAttempts));
    }

    // التحقق من تجاوز الحد الأقصى للمحاولات
    if (_otpAttempts >= 3) {
      emit(MaxAttemptsReachedState());
      // إعادة إرسال رمز OTP جديد بعد تجاوز الحد
      Future.delayed(const Duration(seconds: 2), () {
        resetOtpAttempts(); // إعادة تعيين المحاولات قبل الإرسال
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
  Future<void> resendOtp() async {
    if (_secondsRemaining == 0 && _registeredEmail.isNotEmpty) {
      // إعادة تعيين المحاولات عند إعادة الإرسال
      resetOtpAttempts();
      await sendOtp(email: _registeredEmail);
    }
  }

  @override
  Future<void> close() {
    cancelOtpTimer();
    return super.close();
  }
}
