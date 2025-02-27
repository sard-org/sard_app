import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../core/app_export.dart';
import '../models/otp_light_version_one_model.dart';
part 'otp_light_version_one_event.dart';
part 'otp_light_version_one_state.dart';

/// A bloc that manages the state of a OtpLightVersionOne according to the event that is dispatched to it.
class OtpLightVersionOneBloc
    extends Bloc<OtpLightVersionOneEvent, OtpLightVersionOneState>
    with CodeAutoFill {
  OtpLightVersionOneBloc(OtpLightVersionOneState initialState)
      : super(initialState) {
    on<OtpLightVersionOneInitialEvent>(_onInitialize);
    on<ChangeOTPEvent>(_changeOTP);
  }

  _onInitialize(
    OtpLightVersionOneInitialEvent event,
    Emitter<OtpLightVersionOneState> emit,
  ) async {
    emit(
      state.copyWith(
        otpController: TextEditingController(),
      ),
    );
    listenForCode();
  }

  @override
  codeUpdated() {
    add(ChangeOTPEvent(code: code!));
  }

  _changeOTP(
    ChangeOTPEvent event,
    Emitter<OtpLightVersionOneState> emit,
  ) {
    emit(state.copyWith(
      otpController: TextEditingController(text: event.code),
    ));
  }
}

