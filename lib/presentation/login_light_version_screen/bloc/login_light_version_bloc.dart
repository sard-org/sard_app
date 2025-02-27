import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/login_light_version_model.dart';
import '../models/loginlight_tab_model.dart';

part 'login_light_version_event.dart';
part 'login_light_version_state.dart';

/// A bloc that manages the state of a LoginLightVersion according to the event that is dispatched to it.
class LoginLightVersionBloc extends Bloc<LoginLightVersionEvent, LoginLightVersionState> {
  LoginLightVersionBloc(LoginLightVersionState initialState) : super(initialState) {
    on<LoginLightVersionInitialEvent>(_onInitialize);
  }

  _onInitialize(
    LoginLightVersionInitialEvent event,
    Emitter<LoginLightVersionState> emit,
  ) async {
    emit(
      state.copyWith(
        searchController: TextEditingController(),
      ),
    );

    emit(
      state.copyWith(
        loginlightTabModelObj: state.loginlightTabModelObj?.copyWith(
          booklistItemList: fillBooklistItemList(),
        ),
      ),
    );
  }

  List<BooklistItemModel> fillBooklistItemList() {
    return [
      BooklistItemModel(
        tf: "msg11".tr,
        tf1: "msg14".tr,
        description: "msg13".tr,
        tf2: "msg11".tr,
        tf3: "msg14".tr,
        descriptionOne: "msg13".tr,
      ),
      BooklistItemModel(),
      BooklistItemModel(),
    ];
  }
}