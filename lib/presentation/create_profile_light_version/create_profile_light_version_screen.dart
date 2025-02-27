import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'bloc/create_profile_light_version_bloc.dart';
import 'models/create_profile_light_version_model.dart';

// ignore_for_file: must_be_immutable
class CreateProfileLightVersionScreen extends StatelessWidget {
  CreateProfileLightVersionScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateProfileLightVersionBloc(
        CreateProfileLightVersionState(
          createProfileLightVersionModelObj: CreateProfileLightVersionModel(),
        ),
      )..add(CreateProfileLightVersionInitialEvent()),
      child: CreateProfileLightVersionScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray50,
      appBar: _buildAppbar(context),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildColumnHeading(context),
                  _buildContainer(context),
                  _buildColumn(context),
                  SizedBox(height: 62.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgArrowDown,
          margin: EdgeInsets.only(right: 18.h),
        ),
      ],
    );
  }

  Widget _buildColumnHeading(BuildContext context) {
    return Column(
      children: [
        Text("msg".tr, style: theme.textTheme.headlineLarge),
        SizedBox(height: 6),
        Text(
          "msg2".tr,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildContainer(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      decoration: AppDecoration.white.copyWith(
        borderRadius: BorderRadiusStyle.roundedBorder12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("lbl".tr, style: theme.textTheme.titleMedium),
          SizedBox(height: 10.h),
          _buildFramethirtyeigh(context),
          SizedBox(height: 16.h),
          Text("msg3".tr, style: theme.textTheme.titleMedium),
          SizedBox(height: 8.h),
          _buildFramethirtyeigh1(context),
          SizedBox(height: 16.h),
          Text("1b13".tr, style: theme.textTheme.titleMedium),
          SizedBox(height: 8.h),
          _buildIcontwo(context),
          SizedBox(height: 16.h),
          Text("msg6".tr, style: theme.textTheme.titleMedium),
          SizedBox(height: 8.h),
          _buildIconone(context),
        ],
      ),
    );
  }

  Widget _buildColumn(BuildContext context) {
    return Column(
      children: [
        _buildSubmitButton(context),
        GestureDetector(
          onTap: () => onTapTxttf(context),
          child: Text(
            "1b15".tr,
            style: theme.textTheme.titleSmall!.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFramethirtyeigh(BuildContext context) {
    return BlocSelector<CreateProfileLightVersionBloc, CreateProfileLightVersionState, TextEditingController?>(
      selector: (state) => state.framethirtyeighController,
      builder: (context, controller) {
        return CustomTextFormField(
          controller: controller,
          hintText: "1b12".tr,
          contentPadding: EdgeInsets.all(12.h),
        );
      },
    );
  }

  Widget _buildFramethirtyeigh1(BuildContext context) {
    return BlocSelector<CreateProfileLightVersionBloc, CreateProfileLightVersionState, TextEditingController?>(
      selector: (state) => state.framethirtyeigh1Controller,
      builder: (context, controller) {
        return CustomTextFormField(
          controller: controller,
          hintText: "msg4".tr,
          contentPadding: EdgeInsets.all(12.h),
        );
      },
    );
  }

  Widget _buildIcontwo(BuildContext context) {
    return BlocSelector<CreateProfileLightVersionBloc, CreateProfileLightVersionState, TextEditingController?>(
      selector: (state) => state.icontwoController,
      builder: (context, controller) {
        return CustomTextFormField(
          controller: controller,
          hintText: "msg5".tr,
          obscureText: true,
          textInputType: TextInputType.visiblePassword,
          prefix: Padding(
            padding: EdgeInsets.all(12.h),
            child: CustomImageView(imagePath: ImageConstant.imgIcon, height: 24.h, width: 24.h),
          ),
          validator: (value) {
            if (value == null || !isValidPassword(value, isRequired: true)) {
              return "err_msg_please_enter_valid_password".tr;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildIconone(BuildContext context) {
    return BlocSelector<CreateProfileLightVersionBloc, CreateProfileLightVersionState, TextEditingController?>(
      selector: (state) => state.icononeController,
      builder: (context, controller) {
        return CustomTextFormField(
          controller: controller,
          hintText: "msg7".tr,
          obscureText: true,
          textInputType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          prefix: Padding(
            padding: EdgeInsets.all(12.h),
            child: CustomImageView(imagePath: ImageConstant.imgIcon, height: 24.h, width: 24.h),
          ),
          validator: (value) {
            if (value == null || !isValidPassword(value, isRequired: true)) {
              return "err_msg_please_enter_valid_password".tr;
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl4".tr,
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          // تنفيذ الإجراء عند الضغط
        }
      },
    );
  }

  void onTapTxttf(BuildContext context) {
    NavigatorService.pushNamed(AppRoutes.loginLightVersionTwoScreen);
  }
}
