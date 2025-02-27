part of 'congratulation_create_a_new_password_bloc.dart';

import 'package:mohamed_s_application1/presentation/congratulation_creat_a_new_password/models/congratulation_creat_a_new_password_model.dart';

/// Represents the state of CongratulationCreateNewPassword in the application.
// ignore_for_file: must_be_immutable
class CongratulationCreateNewPasswordState extends Equatable {
  CongratulationCreateNewPasswordState({this.congratulationCreateNewPasswordModelObj});

  final CongratulationCreateNewPasswordModel? congratulationCreateNewPasswordModelObj;

  @override
  List<Object?> get props => [congratulationCreateNewPasswordModelObj];

  CongratulationCreateNewPasswordState copyWith({
    CongratulationCreateNewPasswordModel? congratulationCreateNewPasswordModelObj,
  }) {
    return CongratulationCreateNewPasswordState(
      congratulationCreateNewPasswordModelObj: congratulationCreateNewPasswordModelObj ?? this.congratulationCreateNewPasswordModelObj,
    );
  }
}
