part of 'congratulation_profile_light_version_bloc.dart';

/// Abstract class for all events that can be dispatched from the
/// CongratulationProfileLightVersion widget.
///
/// Events must be immutable and implement the [Equatable] interface.
abstract class CongratulationProfileLightVersionEvent extends Equatable {
  const CongratulationProfileLightVersionEvent();

  @override
  List<Object> get props => [];
}

/// Event that is dispatched when the CongratulationProfileLightVersion widget is first created.
class CongratulationProfileLightVersionInitialEvent
    extends CongratulationProfileLightVersionEvent {
  const CongratulationProfileLightVersionInitialEvent();

  @override
  List<Object> get props => [];
}
