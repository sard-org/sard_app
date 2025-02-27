import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/login_light_version_two_model.dart';
part 'login_light_version_two_event.dart';
part 'login_light_version_two_state.dart';

/// A bloc that manages the state of a LoginLightVersionTwo according to the event that is dispatched to it.
class LoginLightVersionTwoBloc
    extends Bloc<LoginLightVersionTwoEvent, LoginLightVersionTwoState> {
  LoginLightVersionTwoBloc(LoginLightVersionTwoState initialState)
      : super(initialState) {
    on<LoginLightVersionTwoInitialEvent>(_onInitialize);
    on<ChangeCheckBoxEvent>(_changeCheckBox);
  }

  _onInitialize(
    LoginLightVersionTwoInitialEvent event,
    Emitter<LoginLightVersionTwoState> emit,
  ) async {
    emit(
      state.copyWith(
        framethirtyeighController: TextEditingController(),
        icononeController: TextEditingController(),
        one: false,
      ),
    );
  }

  _changeCheckBox(
    ChangeCheckBoxEvent event,
    Emitter<LoginLightVersionTwoState> emit,
  ) {
    emit(state.copyWith(
      one: event.value,
    ));
  }
}

