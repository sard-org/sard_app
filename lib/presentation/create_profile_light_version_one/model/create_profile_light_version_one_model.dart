import 'package:equatable/equatable.dart';
import '../../../data/models/selectionPopupModel/selection_popup_model.dart';

/// This class defines the variables used in the [create_profile_light_version_one_screen],
/// and is typically used to hold data that is passed between different parts of the application.
/// ignore_for_file: must_be_immutable
class CreateProfileLightVersionOneModel extends Equatable {
  CreateProfileLightVersionOneModel({this.dropdownItemList = const []});

  List<SelectionPopupModel> dropdownItemList;

  CreateProfileLightVersionOneModel copyWith({
    List<SelectionPopupModel>? dropdownItemList,
  }) {
    return CreateProfileLightVersionOneModel(
      dropdownItemList: dropdownItemList ?? this.dropdownItemList,
    );
  }

  @override
  List<Object?> get props => [dropdownItemList];
}
