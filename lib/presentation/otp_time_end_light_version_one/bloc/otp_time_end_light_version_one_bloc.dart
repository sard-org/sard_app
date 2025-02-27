part of 'otp_time_end_light_version_one_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///OtpTimeEndLightVersionOne widget.
///
/// Events must be immutable and implement the [Equatable] interface.
class OtpTimeEndLightVersionOneEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the OtpTimeEndLightVersionOne widget is first created.
class OtpTimeEndLightVersionOneInitialEvent
    extends OtpTimeEndLightVersionOneEvent {
  @override
  List<Object?> get props => [];
}

///event for OTP auto fill

// ignore_for_file: must_be_immutable
class ChangeOTPEvent extends OtpTimeEndLightVersionOneEvent {
  ChangeOTPEvent({required this.code});

  String code;

  @override
  List<Object?> get props => [code];
}

