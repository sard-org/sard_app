import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../core/app_export.dart';
import '../models/otp_light_version_model.dart';
part 'otp_light_version_event.dart';
part 'otp_light_version_state.dart';

/// A bloc that manages the state of a OtpLightVersion according to the event that is dispatched to it.
class OtpLightVersionBloc
    extends Bloc<OtpLightVersionEvent, OtpLightVersionState> with CodeAutoFill {
  OtpLightVersionBloc(OtpLightVersionState initialState) : super(initialState) {
    on<OtpLightVersionInitialEvent>(_onInitialize);
    on<ChangeOTPEvent>(_changeOTP);
  }

  _onInitialize(
    OtpLightVersionInitialEvent event,
    Emitter<OtpLightVersionState> emit,
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
    Emitter<OtpLightVersionState> emit,
  ) {
    emit(state.copyWith(
      otpController: TextEditingController(text: event.code),
    ));
  }
}

