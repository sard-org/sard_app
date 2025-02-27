part of 'if_otp_is_incorrect_light_version_one_bloc.dart';

/// Represents the state of IfOtpIsIncorrectLightVersionOne in the application.

// ignore_for_file: must_be_immutable
class IfOtpIsIncorrectLightVersionOneState extends Equatable {
  IfOtpIsIncorrectLightVersionOneState(
      {this.ifOtpIsIncorrectLightVersionOneModelObj});

  IfOtpIsIncorrectLightVersionOneModel? ifOtpIsIncorrectLightVersionOneModelObj;

  @override
  List<Object?> get props => [ifOtpIsIncorrectLightVersionOneModelObj];
  IfOtpIsIncorrectLightVersionOneState copyWith(
      {IfOtpIsIncorrectLightVersionOneModel?
          ifOtpIsIncorrectLightVersionOneModelObj}) {
    return IfOtpIsIncorrectLightVersionOneState(
      ifOtpIsIncorrectLightVersionOneModelObj:
          ifOtpIsIncorrectLightVersionOneModelObj ??
              this.ifOtpIsIncorrectLightVersionOneModelObj,
    );
  }
}

