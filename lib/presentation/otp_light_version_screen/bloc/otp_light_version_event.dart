part of 'otp_light_version_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///OtpLightVersion widget.
///
/// Events must be immutable and implement the [Equatable] interface.
class OtpLightVersionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the OtpLightVersion widget is first created.
class OtpLightVersionInitialEvent extends OtpLightVersionEvent {
  @override
  List<Object?> get props => [];
}

///event for OTP auto fill

// ignore_for_file: must_be_immutable
class ChangeOTPEvent extends OtpLightVersionEvent {
  ChangeOTPEvent({required this.code});

  String code;

  @override
  List<Object?> get props => [code];
}

