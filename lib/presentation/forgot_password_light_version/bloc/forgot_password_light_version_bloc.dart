import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/forgot_password_light_version_model.dart';
part 'forgot_password_light_version_event.dart';
part 'forgot_password_light_version_state.dart';

/// A bloc that manages the state of a ForgotPasswordLightVersion according to the event that is dispatched to it.
class ForgotPasswordLightVersionBloc extends Bloc<
    ForgotPasswordLightVersionEvent, ForgotPasswordLightVersionState> {
  ForgotPasswordLightVersionBloc(ForgotPasswordLightVersionState initialState)
      : super(initialState) {
    on<ForgotPasswordLightVersionInitialEvent>(_onInitialize);
  }

  _onInitialize(
    ForgotPasswordLightVersionInitialEvent event,
    Emitter<ForgotPasswordLightVersionState> emit,
  ) async {
    emit(
      state.copyWith(
        framethirtyeighController: TextEditingController(),
      ),
    );
  }
}

