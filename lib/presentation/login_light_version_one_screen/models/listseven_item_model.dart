import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';

/// This class is used in the [listseven_item_widget] screen.

// ignore_for_file: must_be_immutable
class ListsevenItemModel extends Equatable {
  ListsevenItemModel({this.seven, this.tf, this.tf1, this.id}) {
    seven = seven ?? "lbl_72".tr;
    tf = tf ?? "lbl29".tr;
    tf1 = tf1 ?? "lbl30".tr;
    id = id ?? "";
  }

  String? seven;

  String? tf;

  String? tf1;

  String? id;

  ListsevenItemModel copyWith({
    String? seven,
    String? tf,
    String? tf1,
    String? id,
  }) {
    return ListsevenItemModel(
      seven: seven ?? this.seven,
      tf: tf ?? this.tf,
      tf1: tf1 ?? this.tf1,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [seven, tf, tf1, id];
}

