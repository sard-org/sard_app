part of 'if_otp_is_incorrect_light_version_bloc.dart';

/// Represents the state of IfOtpIsIncorrectLightVersion in the application.

// ignore_for_file: must_be_immutable
class IfOtpIsIncorrectLightVersionState extends Equatable {
  IfOtpIsIncorrectLightVersionState(
      {this.ifOtpIsIncorrectLightVersionModelObj});

  IfOtpIsIncorrectLightVersionModel? ifOtpIsIncorrectLightVersionModelObj;

  @override
  List<Object?> get props => [ifOtpIsIncorrectLightVersionModelObj];
  IfOtpIsIncorrectLightVersionState copyWith(
      {IfOtpIsIncorrectLightVersionModel?
          ifOtpIsIncorrectLightVersionModelObj}) {
    return IfOtpIsIncorrectLightVersionState(
      ifOtpIsIncorrectLightVersionModelObj:
          ifOtpIsIncorrectLightVersionModelObj ??
              this.ifOtpIsIncorrectLightVersionModelObj,
    );
  }
}

