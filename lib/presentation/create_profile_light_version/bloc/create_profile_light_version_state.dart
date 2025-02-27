part of 'create_profile_light_version_bloc.dart';

/// Represents the state of CreateProfileLightVersion in the application.

// ignore_for_file: must_be_immutable
class CreateProfileLightVersionState extends Equatable {
  CreateProfileLightVersionState({
    this.framethirtyeighController,
    this.framethirtyeigh1Controller,
    this.icontwoController,
    this.icononeController,
    this.createProfileLightVersionModelObj,
  });

  TextEditingController? framethirtyeighController;
  TextEditingController? framethirtyeigh1Controller;
  TextEditingController? icontwoController;
  TextEditingController? icononeController;
  CreateProfileLightVersionModel? createProfileLightVersionModelObj;

  @override
  List<Object?> get props => [
        framethirtyeighController,
        framethirtyeigh1Controller,
        icontwoController,
        icononeController,
        createProfileLightVersionModelObj,
      ];

  CreateProfileLightVersionState copyWith({
    TextEditingController? framethirtyeighController,
    TextEditingController? framethirtyeigh1Controller,
    TextEditingController? icontwoController,
    TextEditingController? icononeController,
    CreateProfileLightVersionModel? createProfileLightVersionModelObj,
  }) {
    return CreateProfileLightVersionState(
      framethirtyeighController:
          framethirtyeighController ?? this.framethirtyeighController,
      framethirtyeigh1Controller:
          framethirtyeigh1Controller ?? this.framethirtyeigh1Controller,
      icontwoController: icontwoController ?? this.icontwoController,
      icononeController: icononeController ?? this.icononeController,
      createProfileLightVersionModelObj:
          createProfileLightVersionModelObj ?? this.createProfileLightVersionModelObj,
    );
  }
}
