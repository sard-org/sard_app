import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/create_a_new_password_light_version_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'create_a_new_password_light_version_event.dart';
part 'create_a_new_password_light_version_state.dart';

/// A bloc that manages the state of a CreateANewPasswordLightVersion according to the event that is dispatched to it.
class CreateANewPasswordLightVersionBloc
    extends Bloc<CreateANewPasswordLightVersionEvent,
        CreateANewPasswordLightVersionState> {
  CreateANewPasswordLightVersionBloc()
      : super(CreateANewPasswordLightVersionState(
          iconTwelveController: TextEditingController(),
          iconOneController: TextEditingController(),
          isShowPassword: true,
          isShowPassword1: true,
        )) {
    on<CreateANewPasswordLightVersionInitialEvent>(_onInitialize);
    on<ChangePasswordVisibilityEvent>(_changePasswordVisibility);
    on<ChangePasswordVisibilityEvent1>(_changePasswordVisibility1);
  }

  void _onInitialize(CreateANewPasswordLightVersionInitialEvent event,
      Emitter<CreateANewPasswordLightVersionState> emit) async {
    emit(state.copyWith(
      iconTwelveController: TextEditingController(),
      iconOneController: TextEditingController(),
      isShowPassword: true,
      isShowPassword1: true,
    ));
  }

  void _changePasswordVisibility(ChangePasswordVisibilityEvent event,
      Emitter<CreateANewPasswordLightVersionState> emit) {
    emit(state.copyWith(
      isShowPassword: event.value,
    ));
  }

  void _changePasswordVisibility1(ChangePasswordVisibilityEvent1 event,
      Emitter<CreateANewPasswordLightVersionState> emit) {
    emit(state.copyWith(
      isShowPassword1: event.value,
    ));
  }
}
