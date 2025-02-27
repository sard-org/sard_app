part of 'otp_light_version_one_bloc.dart';

/// Represents the state of OtpLightVersionOne in the application.

// ignore_for_file: must_be_immutable
class OtpLightVersionOneState extends Equatable {
  OtpLightVersionOneState(
      {this.otpController, this.otpLightVersionOneModelObj});

  TextEditingController? otpController;

  OtpLightVersionOneModel? otpLightVersionOneModelObj;

  @override
  List<Object?> get props => [otpController, otpLightVersionOneModelObj];
  OtpLightVersionOneState copyWith({
    TextEditingController? otpController,
    OtpLightVersionOneModel? otpLightVersionOneModelObj,
  }) {
    return OtpLightVersionOneState(
      otpController: otpController ?? this.otpController,
      otpLightVersionOneModelObj:
          otpLightVersionOneModelObj ?? this.otpLightVersionOneModelObj,
    );
  }
}

