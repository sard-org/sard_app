part of 'create_a_new_password_light_version_bloc.dart';

/// Represents the state of CreateANewPasswordLightVersion in the application.
// ignore_for_file: must_be_immutable
class CreateANewPasswordLightVersionState extends Equatable {
  CreateANewPasswordLightVersionState({
    this.icontwelveController,
    this.icononeController,
    this.isShowPassword = true,
    this.isShowPassword1 = true,
    this.createANewPasswordLightVersionModelObj,
  });

  TextEditingController? icontwelveController;
  TextEditingController? icononeController;
  CreateANewPasswordLightVersionModel? createANewPasswordLightVersionModelObj;
  bool isShowPassword;
  bool isShowPassword1;

  @override
  List<Object?> get props => [
        icontwelveController,
        icononeController,
        isShowPassword,
        isShowPassword1,
        createANewPasswordLightVersionModelObj,
      ];

  CreateANewPasswordLightVersionState copyWith({
    TextEditingController? icontwelveController,
    TextEditingController? icononeController,
    bool? isShowPassword,
    bool? isShowPassword1,
    CreateANewPasswordLightVersionModel? createANewPasswordLightVersionModelObj,
  }) {
    return CreateANewPasswordLightVersionState(
      icontwelveController: icontwelveController ?? this.icontwelveController,
      icononeController: icononeController ?? this.icononeController,
      isShowPassword: isShowPassword ?? this.isShowPassword,
      isShowPassword1: isShowPassword1 ?? this.isShowPassword1,
      createANewPasswordLightVersionModelObj:
          createANewPasswordLightVersionModelObj ??
              this.createANewPasswordLightVersionModelObj,
    );
  }
}
