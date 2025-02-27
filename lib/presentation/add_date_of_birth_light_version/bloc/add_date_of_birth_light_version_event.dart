part of 'add_date_of_birth_light_version_bloc.dart';

/// Abstract class for all events that can be dispatched from the
/// AddDateOfBirthLightVersion widget.
/// Events must be immutable and implement the [Equatable] interface.
abstract class AddDateOfBirthLightVersionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event that is dispatched when the AddDateOfBirthLightVersion widget is first created.
class AddDateOfBirthLightVersionInitialEvent extends AddDateOfBirthLightVersionEvent {
  @override
  List<Object?> get props => [];
}
