import 'package:flutter/material.dart';
import '../../../core/app_export.dart';
import '../../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'bloc/congratulation_profile_light_version_bloc.dart';
import 'models/congratulation_profile_light_version_model.dart';

// ignore_for_file: must_be_immutable
class CongratulationProfileLightVersionDialog extends StatelessWidget {
  const CongratulationProfileLightVersionDialog({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => CongratulationProfileLightVersionBloc(
        CongratulationProfileLightVersionState(
          congratulationProfileLightVersionModelObj:
              CongratulationProfileLightVersionModel(),
        ),
      )..add(CongratulationProfileLightVersionInitialEvent()),
      child: const CongratulationProfileLightVersionDialog(),
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
          padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 36.h),
          decoration: AppDecoration.white.copyWith(
            borderRadius: BorderRadiusStyle.roundedBorder12,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgGroup214,
                height: 164.h,
                width: 176.h,
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      height: 36.h,
                      width: 134.h,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              "lbl37".tr,
                              style: CustomTextStyles.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    CustomImageView(
                      imagePath: ImageConstant.imgAbstract,
                      height: 14.h,
                      width: double.infinity,
                    ),
                    Text(
                      "text_example".tr,
                      style: CustomTextStyles.titleSmallGray500,
                    ),
                    const SizedBox(height: 24.0),
                    CustomElevatedButton(
                      text: "bis".tr,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(height: 6.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
