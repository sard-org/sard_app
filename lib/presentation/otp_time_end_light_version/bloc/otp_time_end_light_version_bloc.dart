import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../core/app_export.dart';
import '../models/otp_time_end_light_version_model.dart';
part 'otp_time_end_light_version_event.dart';
part 'otp_time_end_light_version_state.dart';

/// A bloc that manages the state of a OtpTimeEndLightVersion according to the event that is dispatched to it.
class OtpTimeEndLightVersionBloc
    extends Bloc<OtpTimeEndLightVersionEvent, OtpTimeEndLightVersionState>
    with CodeAutoFill {
  OtpTimeEndLightVersionBloc(OtpTimeEndLightVersionState initialState)
      : super(initialState) {
    on<OtpTimeEndLightVersionInitialEvent>(_onInitialize);
    on<ChangeOTPEvent>(_changeOTP);
  }

  _onInitialize(
    OtpTimeEndLightVersionInitialEvent event,
    Emitter<OtpTimeEndLightVersionState> emit,
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
    Emitter<OtpTimeEndLightVersionState> emit,
  ) {
    emit(state.copyWith(
      otpController: TextEditingController(text: event.code),
    ));
  }
}

