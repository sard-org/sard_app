import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;
import '../Data/home_model.dart';
import '../Data/home_dio.dart';
import 'home_state.dart';
import '../../../utils/error_translator.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  void getUserData() async {
    emit(HomeLoading());
    try {
      final response = await HomeDio.dio.get('users/me/home');

      final data = response.data;
      developer.log('API Response: $data', name: 'HomeCubit');

      if (data is Map<String, dynamic>) {
        try {
          final userModel = UserModelhome.fromJson(data);
          emit(HomeLoaded(userModel));
        } catch (e) {
          developer.log('Error parsing UserModel: $e', name: 'HomeCubit');
          emit(HomeError('خطأ في تحليل البيانات: $e'));
        }
      } else {
        developer.log('Unexpected data format: ${data.runtimeType}', name: 'HomeCubit');
        emit(HomeError('نوع البيانات غير متوقع'));
      }
    } catch (e) {
      developer.log('Network error: $e', name: 'HomeCubit');
      final userFriendlyError = ErrorTranslator.handleDioError(e);
      emit(HomeError(userFriendlyError));
    }
  }
}
