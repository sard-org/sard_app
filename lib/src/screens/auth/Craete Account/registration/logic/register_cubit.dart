import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sard/src/screens/auth/Craete%20Account/registration/logic/register_state.dart';
import '../Model/register_response.dart';
import '../data/dio_register_helper.dart';


class RegisterScreenCubit extends Cubit<RegisterScreenState> {
  RegisterScreenCubit() : super(RegisterInitial());

  static RegisterScreenCubit get(context) => BlocProvider.of(context);

  void register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
      final response = await RegistrationDioHelper.postData(
        url: 'auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      final result = RegisterScreenResponse.fromJson(response.data);
      emit(RegisterSuccess(result.message));
    } catch (e) {
      emit(RegisterError(e.toString()));
    }
  }
}
