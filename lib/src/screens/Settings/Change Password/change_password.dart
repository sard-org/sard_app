import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../style/BaseScreen.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import 'cubit/change_password_cubit.dart';
import 'cubit/change_password_state.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  String? _passwordError;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearError() {
    if (_passwordError != null) {
      setState(() {
        _passwordError = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChangePasswordCubit(),
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordError) {
            setState(() {
              _passwordError = state.message;
            });
          } else if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message.toString())),
            );
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: BaseScreen(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        _buildPasswordField(
                          "كلمة المرور القديمة",
                          _oldPasswordController,
                          _obscureOldPassword,
                          "كلمة المرور القديمة",
                              () {
                            setState(() {
                              _obscureOldPassword = !_obscureOldPassword;
                            });
                          },
                          onChanged: (_) => _clearError(),
                        ),
                        _buildPasswordField(
                          "كلمة المرور الجديدة",
                          _newPasswordController,
                          _obscureNewPassword,
                          "كلمة المرور الجديدة",
                              () {
                            setState(() {
                              _obscureNewPassword = !_obscureNewPassword;
                            });
                          },
                          onChanged: (_) => _clearError(),
                        ),
                        _buildPasswordField(
                          "تأكيد كلمة المرور الجديدة",
                          _confirmPasswordController,
                          _obscureConfirmPassword,
                          "تأكيد كلمة المرور الجديدة",
                              () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                          onChanged: (_) => _clearError(),
                        ),

                        if (_passwordError != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0, top: 4.0, left: 16.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _passwordError!,
                                style: TextStyle(color: Colors.red, fontSize: 14),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),

                        Spacer(),
                        UpdateButton(
                          title: state is ChangePasswordLoading ? "جاري التحديث..." : "تحديث",
                          onPressed: state is ChangePasswordLoading
                              ? () {}
                              : () {
                            FocusScope.of(context).unfocus(); // Hide keyboard
                            context.read<ChangePasswordCubit>().changePassword(
                              oldPassword: _oldPasswordController.text,
                              newPassword: _newPasswordController.text,
                              confirmPassword: _confirmPasswordController.text,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary500,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end, // زر الرجوع والعنوان على اليمين
        children: [
          Text(
            "تغيير كلمة المرور",
            style: AppTexts.heading2Bold.copyWith(
              color: AppColors.neutral100,
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_forward, color: AppColors.primary500), // السهم على اليمين
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(
      String label,
      TextEditingController controller,
      bool obscureText,
      String hint,
      VoidCallback toggleVisibility,
      {Function(String)? onChanged}
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // جعل العنوان على اليمين
      children: [
        Text(label, style: AppTexts.contentRegular),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTexts.contentRegular,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutral400),
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: GestureDetector( // العين على اليسار
              onTap: toggleVisibility,
              child: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.neutral400,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }
}

class UpdateButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const UpdateButton({required this.title, required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary500,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        title,
        style: AppTexts.contentEmphasis.copyWith(
          color: AppColors.neutral100,
        ),
      ),
    );
  }
}