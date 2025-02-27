part of 'forgot_password_light_version_bloc.dart';

/// Abstract class for all events that can be dispatched from the
///ForgotPasswordLightVersion widget.
///
/// Events must be immutable and implement the [Equatable] interface.
class ForgotPasswordLightVersionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the ForgotPasswordLightVersion widget is first created.
class ForgotPasswordLightVersionInitialEvent
    extends ForgotPasswordLightVersionEvent {
  @override
  List<Object?> get props => [];
}

