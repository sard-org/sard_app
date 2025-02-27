import 'package:equatable/equatable.dart';
import 'chipviewprinter_item_model.dart';
import 'list_item_model.dart';
import 'listseven_item_model.dart';

/// This class is used in the [login_light_version_one_initial_page] screen.

// ignore_for_file: must_be_immutable
class LoginLightVersionOneInitialModel extends Equatable {
  LoginLightVersionOneInitialModel(
      {this.chipviewprinterItemList = const [],
      this.listItemList = const [],
      this.listsevenItemList = const []});

  List<ChipviewprinterItemModel> chipviewprinterItemList;

  List<ListItemModel> listItemList;

  List<ListsevenItemModel> listsevenItemList;

  LoginLightVersionOneInitialModel copyWith({
    List<ChipviewprinterItemModel>? chipviewprinterItemList,
    List<ListItemModel>? listItemList,
    List<ListsevenItemModel>? listsevenItemList,
  }) {
    return LoginLightVersionOneInitialModel(
      chipviewprinterItemList:
          chipviewprinterItemList ?? this.chipviewprinterItemList,
      listItemList: listItemList ?? this.listItemList,
      listsevenItemList: listsevenItemList ?? this.listsevenItemList,
    );
  }

  @override
  List<Object?> get props =>
      [chipviewprinterItemList, listItemList, listsevenItemList];
}

