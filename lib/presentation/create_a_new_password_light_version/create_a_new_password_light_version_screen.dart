import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mohamed_s_application1/presentation/craet_a_new_password_light_version/bloc/craet_a_new_password_light_version_state.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'bloc/create_a_new_password_light_version_bloc.dart';
import 'models/create_a_new_password_light_version_model.dart';

// ignore_for_file: must_be_immutable
class CreateANewPasswordLightVersionScreen extends StatelessWidget {
  CreateANewPasswordLightVersionScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateANewPasswordLightVersionBloc(
        CreateANewPasswordLightVersionState(
          createANewPasswordLightVersionModelObj: CreateANewPasswordLightVersionModel(),
        ),
      )..add(CreateANewPasswordLightVersionInitialEvent()),
      child: CreateANewPasswordLightVersionScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray50,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(left: 16.h, top: 32.h, right: 16.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "msg25".tr,
                          style: theme.textTheme.headlineSmall,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "msg26".tr,
                          style: theme.textTheme.bodyLarge,
                        ),
                        SizedBox(height: 56.h),
                        _buildCreateANewPassword(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomSection(context),
    );
  }

  /// **App Bar**
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgArrowDown,
          margin: EdgeInsets.only(right: 18.h),
        ),
      ],
    );
  }

  /// **Password Fields**
  Widget _buildCreateANewPassword(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "msg27".tr,
            style: theme.textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          BlocBuilder<CreateANewPasswordLightVersionBloc, CreateANewPasswordLightVersionState>(
            builder: (context, state) {
              return CustomTextFormField(
                controller: state.passwordController,
                hintText: "msg28".tr,
                textInputType: TextInputType.visiblePassword,
                suffix: InkWell(
                  onTap: () {
                    context.read<CreateANewPasswordLightVersionBloc>().add(
                          ChangePasswordVisibilityEvent(value: !state.isShowPassword),
                        );
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(16.h, 12.h, 12.h, 12.h),
                    child: CustomImageView(
                      imagePath: ImageConstant.imgIcon,
                      height: 24.h,
                      width: 24.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                obscureText: state.isShowPassword,
                contentPadding: EdgeInsets.all(12.h),
                validator: (value) {
                  if (value == null || !isValidPassword(value, isRequired: true)) {
                    return "err_msg_please_enter_valid_password".tr;
                  }
                  return null;
                },
              );
            },
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  /// **Bottom Section**
  Widget _buildBottomSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 18.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomElevatedButton(
            text: "1b14".tr,
            margin: EdgeInsets.only(bottom: 12.h),
          ),
        ],
      ),
    );
  }
}
