part of 'congratulation_create_a_new_password_bloc.dart';

/// Abstract class for all events that can be dispatched 
/// from the CongratulationCreateNewPassword widget.
///
/// Events must be immutable and implement the [Equatable] interface.
abstract class CongratulationCreateNewPasswordEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Event that is dispatched when the CongratulationCreateNewPassword widget is first created.
class CongratulationCreateNewPasswordInitialEvent
    extends CongratulationCreateNewPasswordEvent {
  @override
  List<Object> get props => [];
}
