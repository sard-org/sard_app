import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../models/create_profile_light_version_one_model.dart';

part 'create_profile_light_version_one_event.dart';
part 'create_profile_light_version_one_state.dart';

/// A bloc that manages the state of a CreateProfileLightVersionOne according to the event that is dispatched to it.
class CreateProfileLightVersionOneBloc
    extends Bloc<CreateProfileLightVersionOneEvent, CreateProfileLightVersionOneState> {
  CreateProfileLightVersionOneBloc()
      : super(CreateProfileLightVersionOneState(
          createProfileLightVersionOneModelObj: CreateProfileLightVersionOneModel(),
        )) {
    on<CreateProfileLightVersionOneInitialEvent>(_onInitialize);
  }

  Future<void> _onInitialize(
      CreateProfileLightVersionOneInitialEvent event, Emitter<CreateProfileLightVersionOneState> emit) async {
    emit(state.copyWith(
      framethirtyeighController: TextEditingController(),
      framethirtyeigh1Controller: TextEditingController(),
      framethirtyeigh2Controller: TextEditingController(),
      inputfieldoneController: TextEditingController(),
      iconfourController: TextEditingController(),
      icononeController: TextEditingController(),
      createProfileLightVersionOneModelObj: state.createProfileLightVersionOneModelObj?.copyWith(
        dropdownItemList: fillDropdownItemList(),
      ),
    ));
  }

  List<SelectionPopupModel> fillDropdownItemList() {
    return [
      SelectionPopupModel(id: 1, title: "Item One", isSelected: true),
      SelectionPopupModel(id: 2, title: "Item Two"),
      SelectionPopupModel(id: 3, title: "Item Three"),
    ];
  }
}
