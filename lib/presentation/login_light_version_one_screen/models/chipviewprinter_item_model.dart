import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';

/// This class is used in the [chipviewprinter_item_widget] screen.

// ignore_for_file: must_be_immutable
class ChipviewprinterItemModel extends Equatable {
  ChipviewprinterItemModel({this.printerTwo, this.isSelected}) {
    printerTwo = printerTwo ?? "lbl20".tr;
    isSelected = isSelected ?? false;
  }

  String? printerTwo;

  bool? isSelected;

  ChipviewprinterItemModel copyWith({
    String? printerTwo,
    bool? isSelected,
  }) {
    return ChipviewprinterItemModel(
      printerTwo: printerTwo ?? this.printerTwo,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [printerTwo, isSelected];
}

