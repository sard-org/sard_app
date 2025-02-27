part of 'create_a_new_password_light_version_bloc.dart';

/// Abstract class for all events that can be dispatched from the 
/// CreateANewPasswordLightVersion widget.
/// 
/// Events must be immutable and implement the [Equatable] interface.
abstract class CreateANewPasswordLightVersionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Event that is dispatched when the CreateANewPasswordLightVersion widget is first created.
class CreateANewPasswordLightVersionInitialEvent
    extends CreateANewPasswordLightVersionEvent {
  @override
  List<Object> get props => [];
}

/// Event for changing password visibility.
// ignore_for_file: must_be_immutable
class ChangePasswordVisibilityEvent extends CreateANewPasswordLightVersionEvent {
  ChangePasswordVisibilityEvent({required this.value});
  
  final bool value;

  @override
  List<Object> get props => [value];
}

/// Another event for changing password visibility.
// ignore_for_file: must_be_immutable
class ChangePasswordVisibilityEvent1 extends CreateANewPasswordLightVersionEvent {
  ChangePasswordVisibilityEvent1({required this.value});
  
  final bool value;

  @override
  List<Object> get props => [value];
}
