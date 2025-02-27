part of 'otp_time_end_light_version_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///OtpTimeEndLightVersion widget.
///
/// Events must be immutable and implement the [Equatable] interface.
class OtpTimeEndLightVersionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the OtpTimeEndLightVersion widget is first created.
class OtpTimeEndLightVersionInitialEvent extends OtpTimeEndLightVersionEvent {
  @override
  List<Object?> get props => [];
}

///event for OTP auto fill

// ignore_for_file: must_be_immutable
class ChangeOTPEvent extends OtpTimeEndLightVersionEvent {
  ChangeOTPEvent({required this.code});

  String code;

  @override
  List<Object?> get props => [code];
}

