import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../utils/auth_utils.dart';
import 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  final Dio _dio = Dio();

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      emit(ChangePasswordLoading());

      if (newPassword != confirmPassword) {
        emit(const ChangePasswordError('كلمة المرور الجديدة غير متطابقة'));
        return;
      }

      final headers = await AuthUtils.getAuthHeader();
      
      final response = await _dio?.patch(
        '/api/auth/change-password',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
          'confirm_password': confirmPassword,
        },
        options: Options(headers: headers),
      );

      if (response!.statusCode == 200) {
        emit(ChangePasswordSuccess(response.data['message'] ?? 'تم تغيير كلمة المرور بنجاح'));
      } else {
        emit(ChangePasswordError(response.data['message'] ?? 'حدث خطأ أثناء تغيير كلمة المرور'));
      }
    } on DioException catch (e) {
      emit(ChangePasswordError(e.response?.data['message'] ?? 'حدث خطأ في الاتصال'));
    } catch (e) {
      emit(const ChangePasswordError('حدث خطأ غير متوقع'));
    }
  }
} 