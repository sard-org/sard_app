import 'package:flutter/material.dart';
import '../../../../style/BaseScreen.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../Forgot Password/forgot_password_screen.dart';
import '../Register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BaseScreen(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "أهلاً بعودتك!",
                  style: AppTexts.display1Bold,
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "الرجاء إدخال بريدك الإلكتروني وكلمة المرور للوصول إلى حسابك.",
                  style: AppTexts.highlightEmphasis,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              _buildTextField(
                label: 'البريد الإلكتروني',
                hint: 'أدخل بريدك الإلكتروني',
                controller: _emailController,
              ),
              _buildTextField(
                label: 'كلمة المرور',
                hint: 'أدخل كلمة المرور',
                controller: _passwordController,
                obscureText: _obscurePassword,
                toggleVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (val) {
                          setState(() {
                            _rememberMe = val!;
                          });
                        },
                      ),
                      Text("تذكرني", style: AppTexts.contentRegular),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                      );
                    },
                    child: Text(
                      "نسيت كلمة المرور",
                      style: AppTexts.contentRegular.copyWith(
                        color: AppColors.primary500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // تنفيذ تسجيل الدخول
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "تسجيل الدخول",
                  style: AppTexts.contentEmphasis.copyWith(color: AppColors.neutral100),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  children: [
                    Text(
                      "ليس لديك حساب؟",
                      style: AppTexts.contentRegular.copyWith(
                        color: AppColors.neutral900,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      child: Text("إنشاء حساب", style: AppTexts.contentEmphasis.copyWith(
                          color: AppColors.primary500,
                          decoration: TextDecoration.underline
                      )),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTexts.contentRegular),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
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
            prefixIcon: toggleVisibility != null
                ? GestureDetector(
              onTap: toggleVisibility,
              child: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.neutral400,
              ),
            )
                : null,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
