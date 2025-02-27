part of 'login_light_version_two_bloc.dart';

/// Represents the state of LoginLightVersionTwo in the application.

// ignore_for_file: must_be_immutable
class LoginLightVersionTwoState extends Equatable {
  LoginLightVersionTwoState(
      {this.framethirtyeighController,
      this.icononeController,
      this.one = false,
      this.loginLightVersionTwoModelObj});

  TextEditingController? framethirtyeighController;

  TextEditingController? icononeController;

  LoginLightVersionTwoModel? loginLightVersionTwoModelObj;

  bool one;

  @override
  List<Object?> get props => [
        framethirtyeighController,
        icononeController,
        one,
        loginLightVersionTwoModelObj
      ];
  LoginLightVersionTwoState copyWith({
    TextEditingController? framethirtyeighController,
    TextEditingController? icononeController,
    bool? one,
    LoginLightVersionTwoModel? loginLightVersionTwoModelObj,
  }) {
    return LoginLightVersionTwoState(
      framethirtyeighController:
          framethirtyeighController ?? this.framethirtyeighController,
      icononeController: icononeController ?? this.icononeController,
      one: one ?? this.one,
      loginLightVersionTwoModelObj:
          loginLightVersionTwoModelObj ?? this.loginLightVersionTwoModelObj,
    );
  }
}

