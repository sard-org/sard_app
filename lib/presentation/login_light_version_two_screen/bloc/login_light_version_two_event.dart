part of 'login_light_version_two_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///LoginLightVersionTwo widget.
///
/// Events must be immutable and implement the [Equatable] interface.
class LoginLightVersionTwoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the LoginLightVersionTwo widget is first created.
class LoginLightVersionTwoInitialEvent extends LoginLightVersionTwoEvent {
  @override
  List<Object?> get props => [];
}

///Event for changing checkbox

// ignore_for_file: must_be_immutable
class ChangeCheckBoxEvent extends LoginLightVersionTwoEvent {
  ChangeCheckBoxEvent({required this.value});

  bool value;

  @override
  List<Object?> get props => [value];
}

