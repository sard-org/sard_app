part of 'congratulation_profile_light_version_bloc.dart';

/// Represents the state of CongratulationProfileLightVersion in the application.
// ignore_for_file: must_be_immutable
class CongratulationProfileLightVersionState extends Equatable {
  CongratulationProfileLightVersionState({this.congratulationProfileLightVersionModelObj});

  final CongratulationProfileLightVersionModel? congratulationProfileLightVersionModelObj;

  @override
  List<Object?> get props => [congratulationProfileLightVersionModelObj];

  CongratulationProfileLightVersionState copyWith({
    CongratulationProfileLightVersionModel? congratulationProfileLightVersionModelObj,
  }) {
    return CongratulationProfileLightVersionState(
      congratulationProfileLightVersionModelObj: congratulationProfileLightVersionModelObj ?? this.congratulationProfileLightVersionModelObj,
    );
  }
}
