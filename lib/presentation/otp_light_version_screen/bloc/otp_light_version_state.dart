part of 'otp_light_version_bloc.dart';

/// Represents the state of OtpLightVersion in the application.

// ignore_for_file: must_be_immutable
class OtpLightVersionState extends Equatable {
  OtpLightVersionState({this.otpController, this.otpLightVersionModelObj});

  TextEditingController? otpController;

  OtpLightVersionModel? otpLightVersionModelObj;

  @override
  List<Object?> get props => [otpController, otpLightVersionModelObj];
  OtpLightVersionState copyWith({
    TextEditingController? otpController,
    OtpLightVersionModel? otpLightVersionModelObj,
  }) {
    return OtpLightVersionState(
      otpController: otpController ?? this.otpController,
      otpLightVersionModelObj:
          otpLightVersionModelObj ?? this.otpLightVersionModelObj,
    );
  }
}

