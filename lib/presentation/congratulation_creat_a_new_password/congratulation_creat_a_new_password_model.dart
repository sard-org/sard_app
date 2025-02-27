import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohamed_s_application1/presentation/congratulation_creat_a_new_password/bloc/congratulation_creat_a_new_password_bloc.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'bloc/congratulation_create_a_new_password_bloc.dart';
import 'models/congratulation_create_a_new_password_model.dart';

// ignore_for_file: must_be_immutable
class CongratulationCreatePasswordDialog extends StatelessWidget {
  const CongratulationCreatePasswordDialog({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<CongratulationCreateNewPasswordBloc>(
      create: (context) => CongratulationCreateNewPasswordBloc(
        CongratulationCreateNewPasswordState(
          congratulationCreateNewPasswordModelObj: CongratulationCreateNewPasswordModel(),
        ),
      )..add(CongratulationCreateNewPasswordInitialEvent()),
      child: const CongratulationCreatePasswordDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 30.h),
          decoration: AppDecoration.white.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageConstant.imgGroup, 
                height: 186.h, 
                width: 108.h,
              ),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.only(right: 4.h),
                child: Text(
                  "Congratulations! Your password has been reset successfully.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: CustomTextStyles.titleMediumPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "You can now log in with your new password.",
                style: CustomTextStyles.titleSmallGray500,
              ),
              SizedBox(height: 44.h),
              CustomElevatedButton(
                text: "Continue".tr,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
