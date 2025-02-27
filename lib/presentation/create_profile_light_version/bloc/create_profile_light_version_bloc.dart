import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/create_profile_light_version_model.dart';
part 'create_profile_light_version_event.dart';
part 'create_profile_light_version_state.dart';

/// A bloc that manages the state of a CreateProfileLightVersion according to the event that is dispatched to it.
class CreateProfileLightVersionBloc extends Bloc<CreateProfileLightVersionEvent,
    CreateProfileLightVersionState> {
  CreateProfileLightVersionBloc(CreateProfileLightVersionState initialState)
      : super(initialState) {
    on<CreateProfileLightVersionInitialEvent>(_onInitialize);
  }

  _onInitialize(
    CreateProfileLightVersionInitialEvent event,
    Emitter<CreateProfileLightVersionState> emit,
  ) async {
    emit(
      state.copyWith(
        framethirtyeighController: TextEditingController(),
        framethirtyeigh1Controller: TextEditingController(),
        icontwoController: TextEditingController(),
        icononeController: TextEditingController(),
      ),
    );
  }
}

