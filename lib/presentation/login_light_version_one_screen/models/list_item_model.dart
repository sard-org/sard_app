import 'package:equatable/equatable.dart';
import '../../../core/app_export.dart';

// This class is used in the [list_item_widget] screen.
// ignore_for_file: must_be_immutable
class ListItemModel extends Equatable {
    ListItemModel({
        this.tf,
        this.tf1,
        this.description,
        this.tf2,
        this.tf3,
        this.descriptionOne,
        this.id,
    }) {
        tf = tf ?? "msg11".tr;
        tf1 = tf1 ?? "msg12".tr;
        description = description ?? "msg13".tr;
        tf2 = tf2 ?? "msg11".tr;
        tf3 = tf3 ?? "msg14".tr;
        descriptionOne = descriptionOne ?? "msg13".tr;
        id = id ?? "";
    }

    String? tf;
    String? tf1;
    String? description;
    String? tf2;
    String? tf3;
    String? descriptionOne;
    String? id;

    ListItemModel copyWith({
        String? tf,
        String? tf1,
        String? description,
        String? tf2,
        String? tf3,
        String? descriptionOne,
        String? id,
    }) {
        return ListItemModel(
            tf: tf ?? this.tf,
            tf1: tf1 ?? this.tf1,
            description: description ?? this.description,
            tf2: tf2 ?? this.tf2,
            tf3: tf3 ?? this.tf3,
            descriptionOne: descriptionOne ?? this.descriptionOne,
            id: id ?? this.id,
        );
    }

    @override
    List<Object?> get props => [tf, tf1, description, tf2, tf3, descriptionOne, id];
}