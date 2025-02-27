part of 'login_light_version_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///LoginLightVersion widget.
///
/// Events must be immutable and implement the [Equatable] interface.
class LoginLightVersionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the LoginLightVersion widget is first created.
class LoginLightVersionInitialEvent extends LoginLightVersionEvent {
  @override
  List<Object?> get props => [];
}

