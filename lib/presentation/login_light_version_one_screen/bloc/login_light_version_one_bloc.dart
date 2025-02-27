import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';
import '../models/chipviewprinter_item_model.dart';
import '../models/list_item_model.dart';
import '../models/listseven_item_model.dart';
import '../models/login_light_version_one_initial_model.dart';
import '../models/login_light_version_one_model.dart';
part 'login_light_version_one_event.dart';
part 'login_light_version_one_state.dart';

/// A bloc that manages the state of a loginLightVersionOne according to the event that is dispatched to it.
class LoginLightVersionOneBloc
    extends Bloc<LoginLightVersionOneEvent, LoginLightVersionOneState> {
    LoginLightVersionOneBloc(LoginLightVersionOneState initialState)
    : super(initialState) {
        on<LoginLightVersionOneInitialEvent>(_onInitialize);
        on<UpdateChipViewEvent>(_updateChipView);
    }

    _onInitialize(
        LoginLightVersionOneInitialEvent event,
        Emitter<LoginLightVersionOneState> emit,
    ) async {
        emit(
            state.copyWith(
                searchController: TextEditingController(),
            ),
        );
        emit(
            state.copyWith(
                loginLightVersionOneInitialModelObj:
                state.loginLightVersionOneInitialModelObj?.copyWith(
                    listsevenItemList: fillListsevenItemList(),
                    listItemList: fillListItemList(),
                    chipviewprinterItemList: fillChipviewprinterItemList(),
                ),
            ),
        );
    }

    _updateChipView(
        UpdateChipViewEvent event,
        Emitter<LoginLightVersionOneState> emit,
    ) {
        List<ChipviewprinterItemModel> newList = List<ChipviewprinterItemModel>.from(
            state.loginLightVersionOneInitialModelObj!.chipviewprinterItemList
        );
        newList[event.index] = newList[event.index].copyWith(
            isSelected: event.isSelected,
        );

        emit(
            state.copyWith(
                loginLightVersionOneInitialModelObj: state
                    .loginLightVersionOneInitialModelObj
                    ?.copyWith(chipviewprinterItemList: newList),
        );
    }
}       List<ListsevenItemModel> fillListsevenItemList() {
    return [
        ListsevenItemModel(seven: "IbI_72".tr, tf: "IbI29".tr, tf1: "IbI30".tr),
        ListsevenItemModel(seven: "IbI_72".tr, tf: "IbI29".tr, tf1: "IbI30".tr),
        ListsevenItemModel(seven: "IbI_72".tr, tf: "IbI29".tr, tf1: "IbI30".tr),
    ];
}

List<ListItemModel> fillListItemList() {
    return [
        ListItemModel(
            tf: "msg11".tr,
            tf1: "msg12".tr,
            description: "msg13".tr,
            tf2: "msg11".tr,
            tf3: "msg14".tr,
            descriptionOne: "msg13".tr,
        ),
    ];
}

List<ChipviewprinterItemModel> fillChipviewprinterItemList() {
    return [
        ChipviewprinterItemModel(printerTwo: "IbI20".tr),
        ChipviewprinterItemModel(printerTwo: "IbI21".tr),
        ChipviewprinterItemModel(printerTwo: "IbI20".tr),
        ChipviewprinterItemModel(printerTwo: "IbI22".tr),
    ];
}
