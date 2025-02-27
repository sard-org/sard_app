part of 'create_profile_light_version_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///CreateProfileLightVersion widget.
///
/// Events must be immutable and implement the [Equatable] interface.
class CreateProfileLightVersionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the CreateProfileLightVersion widget is first created.
class CreateProfileLightVersionInitialEvent
    extends CreateProfileLightVersionEvent {
  @override
  List<Object?> get props => [];
}

