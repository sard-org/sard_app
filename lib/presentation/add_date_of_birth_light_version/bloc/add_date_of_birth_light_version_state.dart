part of 'add_date_of_birth_light_version_bloc.dart';

/// Represents the state of AddDateOfBirthLightVersion in the application.
class AddDateOfBirthLightVersionState extends Equatable {
  final AddDateOfBirthLightVersionModel? addDateOfBirthLightVersionModelObj;
  final List? selectedDatesFromCalendar;

  AddDateOfBirthLightVersionState({
    this.selectedDatesFromCalendar,
    this.addDateOfBirthLightVersionModelObj,
  });

  @override
  List<Object?> get props => [selectedDatesFromCalendar ?? [], addDateOfBirthLightVersionModelObj ?? null];

  AddDateOfBirthLightVersionState copyWith({
    List? selectedDatesFromCalendar,
    AddDateOfBirthLightVersionModel? addDateOfBirthLightVersionModelObj,
  }) {
    return AddDateOfBirthLightVersionState(
      selectedDatesFromCalendar: selectedDatesFromCalendar ?? this.selectedDatesFromCalendar,
      addDateOfBirthLightVersionModelObj: addDateOfBirthLightVersionModelObj ?? this.addDateOfBirthLightVersionModelObj,
    );
  }
}
