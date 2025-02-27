part of 'otp_time_end_light_version_bloc.dart';

/// Represents the state of OtpTimeEndLightVersion in the application.

// ignore_for_file: must_be_immutable
class OtpTimeEndLightVersionState extends Equatable {
  OtpTimeEndLightVersionState(
      {this.otpController, this.otpTimeEndLightVersionModelObj});

  TextEditingController? otpController;

  OtpTimeEndLightVersionModel? otpTimeEndLightVersionModelObj;

  @override
  List<Object?> get props => [otpController, otpTimeEndLightVersionModelObj];
  OtpTimeEndLightVersionState copyWith({
    TextEditingController? otpController,
    OtpTimeEndLightVersionModel? otpTimeEndLightVersionModelObj,
  }) {
    return OtpTimeEndLightVersionState(
      otpController: otpController ?? this.otpController,
      otpTimeEndLightVersionModelObj:
          otpTimeEndLightVersionModelObj ?? this.otpTimeEndLightVersionModelObj,
    );
  }
}

