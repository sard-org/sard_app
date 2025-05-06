import 'package:flutter/material.dart';
import '../../../../style/BaseScreen.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../login/Login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BaseScreen(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 64),
            Align(
              alignment: Alignment.center,
              child: Text(
                "مرحبًا بك في سرد",
                style: AppTexts.display1Bold,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: Text(
                "الرجاء إدخال بريدك الإلكتروني وسنرسل رمز التأكيد إلى بريدك الإلكتروني",
                style: AppTexts.highlightEmphasis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            _buildTextField("الاسم الكامل", "أدخل اسمك", _nameController),
            _buildTextField("البريد الإلكتروني", "أدخل بريدك الإلكتروني", _emailController),
            _buildTextField(
              "كلمة المرور",
              "أدخل كلمة المرور",
              _passwordController,
              obscureText: _obscurePassword,
              toggleVisibility: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            _buildTextField(
              "تأكيد كلمة المرور",
              "أعد إدخال كلمة المرور",
              _confirmPasswordController,
              obscureText: _obscurePassword,
              toggleVisibility: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text != _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("كلمة المرور وتأكيد كلمة المرور غير متطابقين")),
                  );
                  return;
                }

                // تنفيذ إنشاء الحساب
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "إنشاء حساب",
                style: AppTexts.contentEmphasis.copyWith(color: AppColors.neutral100),
              ),
            ),
            const SizedBox(height: 16),
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
                    child: Text(
                      "تسجيل الدخول",
                      style: AppTexts.contentEmphasis.copyWith(
                        color: AppColors.primary500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "هل لديك حساب بالفعل؟",
                    style: AppTexts.contentRegular.copyWith(
                      color: AppColors.neutral900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      String hint,
      TextEditingController controller, {
        bool obscureText = false,
        VoidCallback? toggleVisibility,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
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
