part of 'forgot_password_light_version_bloc.dart';

/// Represents the state of ForgotPasswordLightVersion in the application.

// ignore_for_file: must_be_immutable
class ForgotPasswordLightVersionState extends Equatable {
  ForgotPasswordLightVersionState(
      {this.framethirtyeighController,
      this.forgotPasswordLightVersionModelObj});

  TextEditingController? framethirtyeighController;

  ForgotPasswordLightVersionModel? forgotPasswordLightVersionModelObj;

  @override
  List<Object?> get props =>
      [framethirtyeighController, forgotPasswordLightVersionModelObj];
  ForgotPasswordLightVersionState copyWith({
    TextEditingController? framethirtyeighController,
    ForgotPasswordLightVersionModel? forgotPasswordLightVersionModelObj,
  }) {
    return ForgotPasswordLightVersionState(
      framethirtyeighController:
          framethirtyeighController ?? this.framethirtyeighController,
      forgotPasswordLightVersionModelObj: forgotPasswordLightVersionModelObj ??
          this.forgotPasswordLightVersionModelObj,
    );
  }
}

