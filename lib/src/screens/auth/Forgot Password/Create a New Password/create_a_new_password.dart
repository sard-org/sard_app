import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../main.dart';
import '../../../../../style/BaseScreen.dart';
import '../../../../../style/Colors.dart';
import '../../../../../style/Fonts.dart';
import '../../login/View/Login.dart';
import '../password_reset_cubits.dart';
import '../password_reset_api_service.dart';
import '../password_reset_states.dart';

class CreateNewPassword extends StatefulWidget {
  final String email;
  
  const CreateNewPassword({super.key, required this.email});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = CreatePasswordCubit(PasswordResetApiService.init());
        cubit.setEmail(widget.email);
        return cubit;
      },
      child: BlocConsumer<CreatePasswordCubit, PasswordResetState>(
        listener: (context, state) {
          if (state is CreatePasswordSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
              (route) => false,
            );
          } else if (state is CreatePasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: BaseScreen(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              'إنشاء كلمة مرور جديدة',
                              style: AppTexts.heading2Accent,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              'قم بتعيين كلمة مرور قوية للحفاظ على أمان حسابك',
                              style: AppTexts.highlightEmphasis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 60),
                          _buildPasswordField(
                            'كلمة المرور',
                            _passwordController,
                            !_isPasswordVisible,
                            'أدخل كلمة المرور',
                            () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildPasswordField(
                            'تأكيد كلمة المرور',
                            _confirmPasswordController,
                            !_isConfirmPasswordVisible,
                            'أدخل تأكيد كلمة المرور',
                            () {
                              setState(() {
                                _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 36),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: state is CreatePasswordLoading
                              ? null
                              : () {
                                  context.read<CreatePasswordCubit>().createNewPassword(
                                    _passwordController.text,
                                    _confirmPasswordController.text,
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: state is CreatePasswordLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'إنشاء كلمة المرور',
                                  style: AppTexts.contentEmphasis.copyWith(color: Colors.white),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Wrap(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                              },
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  "تسجيل الدخول",
                                  style: AppTexts.contentEmphasis.copyWith(
                                    color: AppColors.primary500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                "هل لديك حساب بالفعل؟",
                                style: AppTexts.contentRegular.copyWith(color: AppColors.neutral900),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscureText, String hint, VoidCallback toggleVisibility) {
    return Directionality(
      textDirection: TextDirection.ltr, // تحديد الاتجاه من اليمين لليسار
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // جعل العنوان على اليمين
        children: [
          Text(label, style: AppTexts.highlightEmphasis),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            textAlign: TextAlign.right, // ضبط النص ليكون من اليمين
            obscureText: obscureText,
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
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primary500,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.rtl, // تأكيد الاتجاه هنا
            child: Text(
              "إنشاء كلمة مرور جديدة",
              style: AppTexts.heading2Bold.copyWith(color: AppColors.neutral100),
            ),
          ),
        ],
      ),
    );
  }
}
