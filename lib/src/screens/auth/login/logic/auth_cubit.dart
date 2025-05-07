import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/dio_auth_helper.dart';
import 'auth_state.dart';
import 'package:dio/dio.dart';
import 'dart:developer';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password, {bool rememberMe = false}) async {
    emit(AuthLoading());
    try {
      // طباعة بيانات الطلب للتشخيص
      log('Attempting login with email: $email');

      Response response = await DioHelper.postData(
        url: 'auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      // طباعة الاستجابة للتشخيص
      log('Response status: ${response.statusCode}');
      log('Response data: ${response.data}');

      if (response.statusCode == 200) {
        // تحقق من بنية البيانات المستلمة
        var data = response.data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('token') || data.containsKey('access_token') ||
              (data.containsKey('data') && data['data'] is Map<String, dynamic> &&
                  (data['data'].containsKey('token') || data['data'].containsKey('access_token')))) {

            // استخراج الرمز بناءً على هيكل البيانات
            String? token;
            if (data.containsKey('token')) {
              token = data['token'];
            } else if (data.containsKey('access_token')) {
              token = data['access_token'];
            } else if (data['data'].containsKey('token')) {
              token = data['data']['token'];
            } else if (data['data'].containsKey('access_token')) {
              token = data['data']['access_token'];
            }

            if (token != null) {
              // تخزين الرمز
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('auth_token', token);

              // تخزين خيار "تذكرني" إذا تم اختياره
              if (rememberMe) {
                await prefs.setBool('remember_me', true);
                await prefs.setString('saved_email', email);
              } else {
                await prefs.setBool('remember_me', false);
                await prefs.remove('saved_email');
              }

              emit(AuthSuccess(data));
              return;
            }
          }

          // حتى لو لم نجد الرمز، ولكن الاستجابة كانت ناجحة، نعتبر ذلك نجاحًا
          emit(AuthSuccess(data));
          return;
        }
      }
      emit(AuthSuccess(
        'Success'
      ));


    } on DioException catch (e) {
      log('DioException: ${e.type}, ${e.message}');
      if (e.response != null) {
        log('Error response: ${e.response?.statusCode} - ${e.response?.data}');

        // التعامل مع رموز الحالة المختلفة
        switch (e.response?.statusCode) {
          case 401:
            emit(AuthError("البريد الإلكتروني أو كلمة المرور غير صحيحة"));
            break;
          case 403:
            emit(AuthError("ليس لديك صلاحية للوصول"));
            break;
          case 422:
          // أخطاء التحقق
            try {
              if (e.response?.data is Map && e.response?.data['errors'] != null) {
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
            emit(AuthError("حدث خطأ: ${e.response?.statusCode}"));
        }
      } else {
        emit(AuthError("تعذر الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت"));
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
        // التحقق من صلاحية الرمز مع الخادم
        try {
          Response response = await DioHelper.getData(
            url: 'auth/user',
            token: token,
          );

          if (response.statusCode == 200) {
            emit(AuthSuccess(response.data));
          } else {
            // الرمز غير صالح - مسح وطلب تسجيل الدخول
            await prefs.remove('auth_token');
            emit(AuthInitial());
          }
        } catch (e) {
          // خطأ في الشبكة أو فشل في التحقق من الرمز
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
        // إخطار الخادم بتسجيل الخروج (اختياري)
        try {
          await DioHelper.postData(
            url: 'auth/logout',
            token: token,
            data: {},
          );
        } catch (e) {
          // حتى لو فشل تسجيل الخروج من الخادم، نريد مسح بيانات الجلسة المحلية
        }
      }

      // مسح بيانات الجلسة المحلية
      await prefs.remove('auth_token');

      emit(AuthInitial());
    } catch (e) {
      emit(AuthError("حدث خطأ أثناء تسجيل الخروج"));
    }
  }
}