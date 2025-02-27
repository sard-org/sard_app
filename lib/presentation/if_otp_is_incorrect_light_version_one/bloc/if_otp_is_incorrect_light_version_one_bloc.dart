import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/if_otp_is_incorrect_light_version_one_model.dart';
part 'if_otp_is_incorrect_light_version_one_event.dart';
part 'if_otp_is_incorrect_light_version_one_state.dart';

/// A bloc that manages the state of a IfOtpIsIncorrectLightVersionOne according to the event that is dispatched to it.
class IfOtpIsIncorrectLightVersionOneBloc extends Bloc<
    IfOtpIsIncorrectLightVersionOneEvent,
    IfOtpIsIncorrectLightVersionOneState> {
  IfOtpIsIncorrectLightVersionOneBloc(
      IfOtpIsIncorrectLightVersionOneState initialState)
      : super(initialState) {
    on<IfOtpIsIncorrectLightVersionOneInitialEvent>(_onInitialize);
  }

  _onInitialize(
    IfOtpIsIncorrectLightVersionOneInitialEvent event,
    Emitter<IfOtpIsIncorrectLightVersionOneState> emit,
  ) async {}
}

