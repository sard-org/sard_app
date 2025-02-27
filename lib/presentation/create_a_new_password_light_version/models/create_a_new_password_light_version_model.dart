import 'package:flutter/material.dart';
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
class CreatePasswordLightVersionScreen extends StatelessWidget {
  CreatePasswordLightVersionScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Widget create(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateANewPasswordLightVersionBloc(
        CreateANewPasswordLightVersionState(
          createANewPasswordLightVersionModelObj:
              CreateANewPasswordLightVersionModel(),
        ),
      )..add(CreateANewPasswordLightVersionInitialEvent()),
      child: CreatePasswordLightVersionScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.gray50,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 16.h, top: 33.h, right: 16.h),
                  child: Column(
                    children: [
                      Text(
                        'Create a New Password',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Please enter a new password to continue.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(height: 56.h),
                      _buildCreateNewPasswordField(context),
                      _buildConfirmPasswordField(context),
                      SizedBox(height: 24.h),
                      _buildSubmitButton(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      title: 'New Password',
      actions: [
        AppBarTrailingImage(
          imagePath: 'assets/icons/help_icon.svg',
          onTap: () {
            // Handle help button press
          },
        ),
      ],
    );
  }

  Widget _buildCreateNewPasswordField(BuildContext context) {
    return BlocBuilder<CreateANewPasswordLightVersionBloc,
        CreateANewPasswordLightVersionState>(
      builder: (context, state) {
        return CustomTextFormField(
          controller: state.icontwelveController,
          labelText: 'New Password',
          obscureText: state.isShowPassword,
          suffixIcon: CustomIconButton(
            icon: state.isShowPassword ? Icons.visibility_off : Icons.visibility,
            onTap: () {
              context.read<CreateANewPasswordLightVersionBloc>().add(
                    ChangePasswordVisibilityEvent(
                      value: !state.isShowPassword,
                    ),
                  );
            },
          ),
          validator: ValidationFunctions.validatePassword,
        );
      },
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context) {
    return BlocBuilder<CreateANewPasswordLightVersionBloc,
        CreateANewPasswordLightVersionState>(
      builder: (context, state) {
        return CustomTextFormField(
          controller: state.icononeController,
          labelText: 'Confirm Password',
          obscureText: state.isShowPassword1,
          suffixIcon: CustomIconButton(
            icon: state.isShowPassword1 ? Icons.visibility_off : Icons.visibility,
            onTap: () {
              context.read<CreateANewPasswordLightVersionBloc>().add(
                    ChangePasswordVisibilityEvent1(
                      value: !state.isShowPassword1,
                    ),
                  );
            },
          ),
          validator: (value) => ValidationFunctions.validateConfirmPassword(
            value,
            state.icontwelveController?.text,
          ),
        );
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return CustomElevatedButton(
      text: 'Reset Password',
      style: CustomButtonStyle.primary,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          // Handle password reset submission
        }
      },
    );
  }
}
/// Section Widget
PreferredSizeWidget _buildAppBar(BuildContext context) {
  return CustomAppBar(
    actions: [
      AppBarTrailingImage(
        imagePath: ImageConstant.imgArrowDown,
        margin: EdgeInsets.only(right: 18.h),
      ),
    ],
  );
}
