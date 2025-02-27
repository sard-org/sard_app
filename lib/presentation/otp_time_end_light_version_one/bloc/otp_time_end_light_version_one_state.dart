part of 'otp_time_end_light_version_one_bloc.dart';

/// Represents the state of OtpTimeEndLightVersionOne in the application.

// ignore_for_file: must_be_immutable
class OtpTimeEndLightVersionOneState extends Equatable {
  OtpTimeEndLightVersionOneState(
      {this.otpController, this.otpTimeEndLightVersionOneModelObj});

  TextEditingController? otpController;

  OtpTimeEndLightVersionOneModel? otpTimeEndLightVersionOneModelObj;

  @override
  List<Object?> get props => [otpController, otpTimeEndLightVersionOneModelObj];
  OtpTimeEndLightVersionOneState copyWith({
    TextEditingController? otpController,
    OtpTimeEndLightVersionOneModel? otpTimeEndLightVersionOneModelObj,
  }) {
    return OtpTimeEndLightVersionOneState(
      otpController: otpController ?? this.otpController,
      otpTimeEndLightVersionOneModelObj: otpTimeEndLightVersionOneModelObj ??
          this.otpTimeEndLightVersionOneModelObj,
    );
  }
}

