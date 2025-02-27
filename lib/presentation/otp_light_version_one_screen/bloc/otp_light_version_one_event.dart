part of 'otp_light_version_one_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///OtpLightVersionOne widget.
///
/// Events must be immutable and implement the [Equatable] interface.
class OtpLightVersionOneEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the OtpLightVersionOne widget is first created.
class OtpLightVersionOneInitialEvent extends OtpLightVersionOneEvent {
  @override
  List<Object?> get props => [];
}

///event for OTP auto fill

// ignore_for_file: must_be_immutable
class ChangeOTPEvent extends OtpLightVersionOneEvent {
  ChangeOTPEvent({required this.code});

  String code;

  @override
  List<Object?> get props => [code];
}

