part of 'login_light_version_one_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///LoginLightVersionOne widget.
///
/// Events must be immutable and implement the [Equatable] interface.
class LoginLightVersionOneEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the LoginLightVersionOne widget is first created.
class LoginLightVersionOneInitialEvent extends LoginLightVersionOneEvent {
  @override
  List<Object?> get props => [];
}

///Event for changing ChipView selection

// ignore_for_file: must_be_immutable
class UpdateChipViewEvent extends LoginLightVersionOneEvent {
  UpdateChipViewEvent({required this.index, this.isSelected});

  int index;

  bool? isSelected;

  @override
  List<Object?> get props => [index, isSelected];
}

