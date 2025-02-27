import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:mohamed_s_application1/presentation/add_date_of_birth_light_version/bloc/add_date_of_birth_light_version_bloc';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'bloc/add_date_of_birth_light_version_bloc.dart';
import 'models/add_date_of_birth_light_version_model.dart';

// ignore_for_file: must_be_immutable
class AddDateOfBirthLightVersionDialog extends StatelessWidget {
  const AddDateOfBirthLightVersionDialog({Key? key}) : super(key: key);

  // Builder function for providing the dialog
  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (_) => AddDateOfBirthLightVersionBloc(
        AddDateOfBirthLightVersionState(
          addDateOfBirthLightVersionModelObj: AddDateOfBirthLightVersionModel(),
        )..add(AddDateOfBirthLightVersionInitialEvent()),
      ),
      child: const AddDateOfBirthLightVersionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
          decoration: AppDecoration.white.copyWith(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCalendarone(context),
              CustomElevatedButton(
                text: "1b138".tr,
                onPressed: () {
                  onTaptf(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
 
/// Section Widget for building the Calendar
Widget buildCalendarone(BuildContext context) {
  return SizedBox(
    width: double.maxFinite,
    child: BlocBuilder<AddDateOfBirthLightVersionBloc, AddDateOfBirthLightVersionState>(
      builder: (context, state) {
        return SizedBox(
          height: 350.0,
          width: 318.0,
          child: CalendarDatePicker2(
            config: CalendarDatePicker2Config(),
            calendarType: CalendarDatePicker2Type.single,
            firstDate: DateTime(DateTime.now().year - 5),
            lastDate: DateTime(DateTime.now().year + 5),
            selectedDayHighlightColor: Color(0x19856AFF),
            firstDayOfWeek: 0,
            selectedDayTextStyle: TextStyle(),
            color: appTheme.black900,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            dayTextStyle: TextStyle(
              color: appTheme.black900,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
            disabledDayTextStyle: TextStyle(),
            dayBorderRadius: BorderRadius.circular(8.0),
            value: state.selectedDatesFromCalendar ?? [],
            onValueChanged: (dates) {
              // Update the selectedDatesFromCalendar state
              context.read<AddDateOfBirthLightVersionBloc>().add(
                AddDateOfBirthLightVersionDateChangedEvent(dates),
              );
            },
          ),
        );
      },
    ),
  );
}

/// Function to navigate when tapped
void onTaptf(BuildContext context) {
  NavigatorService.pushNamed(AppRoutes.createProfileLightVersionOneScreen);
}












































































































