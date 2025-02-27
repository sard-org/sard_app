import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/app_export.dart';
import '../../core/utils/validation_functions.dart';
import '../../data/models/selectionPopupModel/selection_popup_model.dart';
import '../../theme/custom_button_style.dart';
import '../../widgets/app_bar/appbar_trailing_image.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_drop_down.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_icon_button.dart';
import '../../widgets/custom_text_form_field.dart';
import 'bloc/create_profile_light_version_one_bloc.dart';
import 'models/create_profile_light_version_one_model.dart';

class CreateProfileLightVersionOneScreen extends StatelessWidget {
  CreateProfileLightVersionOneScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateProfileLightVersionOneBloc(
        CreateProfileLightVersionOneState(
          createProfileLightVersionOneModelObj: CreateProfileLightVersionOneModel(),
        ),
      )..add(CreateProfileLightVersionOneInitialEvent()),
      child: CreateProfileLightVersionOneScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray50,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildColumnHeading(context),
                  SizedBox(height: 20),
                  _buildFormFields(context),
                  SizedBox(height: 30),
                  _buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// بناء الـ AppBar
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      actions: [
        AppbarTrailingImage(
          imagePath: ImageConstant.imgArrowDown,
          margin: EdgeInsets.only(right: 18.0),
        ),
      ],
    );
  }

  /// بناء عنوان الشاشة
  Widget _buildColumnHeading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "msg".tr,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        SizedBox(height: 6),
        Text(
          "msg2".tr,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  /// بناء الحقول النصية داخل النموذج
  Widget _buildFormFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(context, "msg4".tr),
        _buildTextField(context, "1b12".tr),
        _buildTextField(context, "msg42".tr),
        _buildPasswordField(context, "msg5".tr),
        _buildPasswordField(context, "msg7".tr),
      ],
    );
  }

  /// إنشاء حقل إدخال نصي عادي
  Widget _buildTextField(BuildContext context, String hintText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: CustomTextFormField(
        hintText: hintText,
        contentPadding: EdgeInsets.all(12.0),
      ),
    );
  }

  /// إنشاء حقل إدخال لكلمة المرور
  Widget _buildPasswordField(BuildContext context, String hintText) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: CustomTextFormField(
        hintText: hintText,
        obscureText: true,
        textInputType: TextInputType.visiblePassword,
        contentPadding: EdgeInsets.all(12.0),
        validator: (value) {
          if (value == null || !isValidPassword(value, isRequired: true)) {
            return "err_msg_please_enter_valid_password".tr;
          }
          return null;
        },
      ),
    );
  }

  /// زر إرسال النموذج
  Widget _buildSubmitButton(BuildContext context) {
    return CustomElevatedButton(
      text: "lbl4".tr,
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          // تنفيذ عملية إرسال البيانات
        }
      },
    );
  }
}
