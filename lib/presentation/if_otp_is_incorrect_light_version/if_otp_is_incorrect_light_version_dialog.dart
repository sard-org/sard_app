import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/custom_elevated_button.dart';
import 'bloc/if_otp_is_incorrect_light_version_bloc.dart';
import 'models/if_otp_is_incorrect_light_version_model.dart';
import '../../widgets/custom_image_view.dart';

class IfOtpIsIncorrectLightVersionDialog extends StatelessWidget {
  const IfOtpIsIncorrectLightVersionDialog({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<IfOtpIsIncorrectLightVersionBloc>(
      create: (context) => IfOtpIsIncorrectLightVersionBloc(
        IfOtpIsIncorrectLightVersionState(
          ifOtpIsIncorrectLightVersionModelObj:
              IfOtpIsIncorrectLightVersionModel(),
        ),
      )..add(IfOtpIsIncorrectLightVersionInitialEvent()),
      child: const IfOtpIsIncorrectLightVersionDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.h),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomImageView(
              imagePath: ImageConstant.imgTick1,
              height: 124.h,
              width: 126.h,
            ),
            SizedBox(height: 16.h),
            Text(
              "lbl31".tr,
              style: CustomTextStyles.titleMediumRedA200,
            ),
            SizedBox(height: 4.h),
            Text(
              "msg22".tr,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: CustomTextStyles.titleSmallGray500,
            ),
            SizedBox(height: 18.h),
            CustomElevatedButton(
              text: "lbl32".tr,
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
