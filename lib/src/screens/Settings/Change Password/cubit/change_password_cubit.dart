import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final Dio _dio = Dio();

  ChangePasswordCubit() : super(ChangePasswordInitial()) {
    _dio.options.baseUrl = 'https://api.mohamed-ramadan.me/api/';
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Basic validation
    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      emit(ChangePasswordError('يجب إدخال جميع الحقول المطلوبة'));
      return;
    }

    // Password matching validation
    if (newPassword != confirmPassword) {
      emit(ChangePasswordError('كلمة المرور الجديدة غير متطابقة مع تأكيد كلمة المرور'));
      return;
    }

    // Password strength validation
    if (newPassword.length < 8) {
      emit(ChangePasswordError('كلمة المرور الجديدة يجب أن تكون 8 أحرف على الأقل'));
      return;
    }

    try {
      emit(ChangePasswordLoading());

      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // تغيير من 'token' إلى 'auth_token'

      // تحاول الحصول على البريد الإلكتروني من SharedPreferences
      final email = prefs.getString('email');

      if (token == null) {
        emit(ChangePasswordError('لم يتم العثور على بيانات الجلسة، يرجى إعادة تسجيل الدخول'));
        return;
      }

      // تحضير البيانات للإرسال - لن نرسل البريد الإلكتروني
      final Map<String, String> requestData = {
        'old_password': oldPassword,
        'new_password': newPassword,
      };

      final response = await _dio.patch(
        'auth/change-password',
        data: requestData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ChangePasswordSuccess('تم تغيير كلمة المرور بنجاح'));
      } else {
        emit(ChangePasswordError('حدث خطأ أثناء تغيير كلمة المرور'));
      }
    } on DioException catch (e) {
      // Handle different DioError cases
      if (e.response != null) {
        // The server responded with a status code different from 2xx
        switch (e.response?.statusCode) {
          case 400:
            if (e.response?.data != null && e.response?.data['message'] != null) {
              emit(ChangePasswordError(e.response?.data['message']));
            } else {
              emit(ChangePasswordError('كلمة المرور القديمة غير صحيحة'));
            }
            break;
          case 401:
            emit(ChangePasswordError('انتهت صلاحية الجلسة، يرجى إعادة تسجيل الدخول'));
            break;
          case 403:
            emit(ChangePasswordError('ليس لديك صلاحية لتنفيذ هذه العملية'));
            break;
          default:
            emit(ChangePasswordError('حدث خطأ أثناء الاتصال بالخادم'));
            break;
        }
      } else {
        // No response was received (network error)
        emit(ChangePasswordError('تعذر الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت'));
      }
    } catch (e) {
      emit(ChangePasswordError('حدث خطأ غير متوقع: $e'));
    }
  }
}