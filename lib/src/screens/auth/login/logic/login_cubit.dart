import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/dio_login_helper.dart';
import 'login_state.dart';
import 'package:dio/dio.dart';
import 'dart:developer';
import '../../../../utils/error_translator.dart';
import '../../Create Account/otp/data/dio_otp_helper.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password,
      {bool rememberMe = false}) async {
    emit(AuthLoading());
    try {
      log('Attempting login with email: $email');

      Response response = await DioHelper.postData(
        url: 'auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      log('Response status: ${response.statusCode}');
      log('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        if (data is Map<String, dynamic>) {
          String? token;

          // استخراج التوكين من الاستجابة
          if (data.containsKey('token')) {
            // ده هستعمله في الابلكين كلو
            token = data['token'];
            log('---------------------------------');
            print(token);
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token!);
            print(prefs.getString('auth_token'));
          } else if (data.containsKey('access_token')) {
            // token = data['access_token'];
            // } else if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
            //   if (data['data'].containsKey('token')) {
            //     token = data['data']['token'];
            //   } else if (data['data'].containsKey('access_token')) {
            //     // token = data['data']['access_token'];
            //   }
          }

          if (token != null) {
            // تخزين التوكين
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token);
            log('---------------------------------');

            // تخزين البريد الإلكتروني في الكاش لاستخدامه لاحقاً
            await prefs.setString('email', email);

            // تخزين خيار "تذكرني"
            if (rememberMe) {
              await prefs.setBool('remember_me', true);
              await prefs.setString('saved_email', email);
            } else {
              await prefs.setBool('remember_me', false);
              await prefs.remove('saved_email');
            }

            // إضافة التوكين إلى DioHelper للاستخدام في الطلبات اللاحقة
            DioHelper.setToken(token);

            emit(AuthSuccess(data));
            return;
          }
        }
        emit(AuthSuccess(data));
        return;
      }
      emit(AuthSuccess('Success'));
    } on DioException catch (e) {
      log('DioException: ${e.type}, ${e.message}');
      if (e.response != null) {
        log('Error response: ${e.response?.statusCode} - ${e.response?.data}');
        // التعامل مع رموز الحالة المختلفة
        switch (e.response?.statusCode) {
          case 401:
            // Check if it's an email verification issue
            final responseMessage = e.response?.data is Map
                ? e.response?.data['message']?.toString()
                : null;

            if (responseMessage != null &&
                responseMessage ==
                    "Please verify your email before logging in") {
              // Send validation email and redirect to verification
              await _sendValidationEmail(email);
              emit(EmailVerificationRequired(email));
            } else {
              emit(AuthError("البريد الإلكتروني أو كلمة المرور غير صحيحة"));
            }
            break;
          case 403:
            // Check if it's an email verification issue
            final responseMessage = e.response?.data is Map
                ? e.response?.data['message']?.toString()
                : null;
            if (responseMessage != null &&
                responseMessage.toLowerCase().contains('verify')) {
              emit(EmailVerificationRequired(email));
            } else {
              emit(AuthError("ليس لديك صلاحية للوصول"));
            }
            break;
          case 422:
            // أخطاء التحقق
            try {
              if (e.response?.data is Map &&
                  e.response?.data['errors'] != null) {
                String errorMessage = "يرجى التحقق من البيانات المدخلة:";
                Map<String, dynamic> errors = e.response?.data['errors'];
                errors.forEach((key, value) {
                  if (value is List && value.isNotEmpty) {
                    errorMessage += "\n• ${value[0]}";
                  } else if (value is String) {
                    errorMessage += "\n• $value";
                  }
                });
                emit(AuthError(errorMessage));
              } else {
                emit(AuthError("البيانات المدخلة غير صحيحة"));
              }
            } catch (formatError) {
              log('Error parsing validation errors: $formatError');
              emit(AuthError("البيانات المدخلة غير صحيحة"));
            }
            break;
          default:
            // Use error translator for general server error messages
            String defaultMessage =
                "حدث خطأ: ${e.response?.statusCode ?? 'غير معروف'}";
            String serverMessage = defaultMessage;

            if (e.response?.data is Map &&
                e.response?.data['message'] != null) {
              serverMessage =
                  e.response?.data['message']?.toString() ?? defaultMessage;
            }

            String translatedError = ErrorTranslator.translateErrorWithContext(
                serverMessage, e.response?.statusCode);
            emit(AuthError(translatedError));
        }
      } else {
        emit(
            AuthError("تعذر الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت"));
      }
    } catch (e) {
      log('Unexpected error: $e');
      emit(AuthError("حدث خطأ غير متوقع: ${e.toString()}"));
    }
  }

  Future<void> checkLoginStatus() async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null && token.isNotEmpty) {
        // إضافة التوكين إلى DioHelper
        DioHelper.setToken(token);

        try {
          Response response = await DioHelper.getData(
            url: 'auth/user',
          );

          if (response.statusCode == 200) {
            emit(AuthSuccess(response.data));
          } else {
            await prefs.remove('auth_token');
            DioHelper.removeToken(); // إزالة التوكين من DioHelper
            emit(AuthInitial());
          }
        } catch (e) {
          DioHelper.removeToken(); // إزالة التوكين من DioHelper
          emit(AuthInitial());
        }
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError("حدث خطأ أثناء التحقق من حالة الدخول"));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        try {
          await DioHelper.postData(
            url: 'auth/logout',
            data: {},
          );
        } catch (e) {
          // تجاهل أخطاء تسجيل الخروج من الخادم
        }
      }

      // مسح بيانات الجلسة
      await prefs.remove('auth_token');
      DioHelper.removeToken(); // إزالة التوكين من DioHelper

      emit(AuthInitial());
    } catch (e) {
      emit(AuthError("حدث خطأ أثناء تسجيل الخروج"));
    }
  }

// دالة إرسال بريد التحقق عند الحاجة للتحقق من البريد الإلكتروني
  Future<void> _sendValidationEmail(String email) async {
    try {
      final dioClient = DioClient();
      await dioClient.validateEmail(email: email);
      log('Validation email sent successfully for: $email');
    } catch (e) {
      log('Failed to send validation email: $e');
      // لا نريد إيقاف العملية إذا فشل إرسال البريد
      // المستخدم سيذهب لشاشة التحقق ويمكنه إعادة المحاولة
    }
  }
}
