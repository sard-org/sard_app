part of 'create_profile_light_version_one_bloc.dart';

/// Represents the state of CreateProfileLightVersionOne in the application.
/// ignore_for_file: must_be_immutable
class CreateProfileLightVersionOneState extends Equatable {
  CreateProfileLightVersionOneState({
    this.framethirtyeighController,
    this.framethirtyeigh1Controller,
    this.framethirtyeigh2Controller,
    this.inputfieldoneController,
    this.iconfourController,
    this.icononeController,
    this.selectedDropDownValue,
    this.createProfileLightVersionOneModelObj,
  });

  TextEditingController? framethirtyeighController;
  TextEditingController? framethirtyeigh1Controller;
  TextEditingController? framethirtyeigh2Controller;
  TextEditingController? inputfieldoneController;
  TextEditingController? iconfourController;
  TextEditingController? icononeController;
  SelectionPopupModel? selectedDropDownValue;
  CreateProfileLightVersionOneModel? createProfileLightVersionOneModelObj;

  @override
  List<Object?> get props => [
        framethirtyeighController,
        framethirtyeigh1Controller,
        framethirtyeigh2Controller,
        inputfieldoneController,
        iconfourController,
        icononeController,
        selectedDropDownValue,
        createProfileLightVersionOneModelObj,
      ];

  CreateProfileLightVersionOneState copyWith({
    TextEditingController? framethirtyeighController,
    TextEditingController? framethirtyeigh1Controller,
    TextEditingController? framethirtyeigh2Controller,
    TextEditingController? inputfieldoneController,
    TextEditingController? iconfourController,
    TextEditingController? icononeController,
    SelectionPopupModel? selectedDropDownValue,
    CreateProfileLightVersionOneModel? createProfileLightVersionOneModelObj,
  }) {
    return CreateProfileLightVersionOneState(
      framethirtyeighController:
          framethirtyeighController ?? this.framethirtyeighController,
      framethirtyeigh1Controller:
          framethirtyeigh1Controller ?? this.framethirtyeigh1Controller,
      framethirtyeigh2Controller:
          framethirtyeigh2Controller ?? this.framethirtyeigh2Controller,
      inputfieldoneController:
          inputfieldoneController ?? this.inputfieldoneController,
      iconfourController: iconfourController ?? this.iconfourController,
      icononeController: icononeController ?? this.icononeController,
      selectedDropDownValue:
          selectedDropDownValue ?? this.selectedDropDownValue,
      createProfileLightVersionOneModelObj:
          createProfileLightVersionOneModelObj ??
              this.createProfileLightVersionOneModelObj,
    );
  }
}
