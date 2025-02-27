part of 'create_profile_light_version_one_bloc.dart';

/// Abstract class for all events that can be dispatched from the 
/// CreateProfileLightVersionOne widget.
/// 
/// Events must be immutable and implement the [Equatable] interface.
abstract class CreateProfileLightVersionOneEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Event that is dispatched when the CreateProfileLightVersionOne widget is first created.
class CreateProfileLightVersionOneInitialEvent extends CreateProfileLightVersionOneEvent {
  @override
  List<Object> get props => [];
}
