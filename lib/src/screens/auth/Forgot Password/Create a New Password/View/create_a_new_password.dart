import 'package:flutter/material.dart';

import '../../../../../../main.dart';
import '../../../../../../style/BaseScreen.dart';
import '../../../../../../style/Colors.dart';
import '../../../../../../style/Fonts.dart';
import '../../../login/View/Login.dart';


class CreateNewPassword extends StatefulWidget {
  const CreateNewPassword({super.key});

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

  void _createPassword() {
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    RegExp uppercaseRegExp = RegExp(r'[A-Z]');
    RegExp lowercaseRegExp = RegExp(r'[a-z]');
    RegExp digitRegExp = RegExp(r'\d');
    RegExp symbolRegExp = RegExp(r'[@#$%^&+=]');

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('الرجاء إدخال جميع الحقول'),
          ),
        ),
      );
    } else if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('كلمات المرور غير متطابقة'),
          ),
        ),
      );
    } else if (!uppercaseRegExp.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('يجب أن تحتوي كلمة المرور على حرف كبير'),
          ),
        ),
      );
    } else if (!lowercaseRegExp.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('يجب أن تحتوي كلمة المرور على حرف صغير'),
          ),
        ),
      );
    } else if (!digitRegExp.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('يجب أن تحتوي كلمة المرور على رقم'),
          ),
        ),
      );
    } else if (!symbolRegExp.hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text('يجب أن تحتوي كلمة المرور على رمز خاص'),
          ),
        ),
      );
    } else {
      // إذا كانت جميع المدخلات صحيحة، سيتم التنقل إلى الصفحة التالية
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen ()), // استبدل "الصفحة_الجديدة" بالصفحة المطلوبة
    );
  }
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

  @override
  Widget build(BuildContext context) {
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
                      textDirection: TextDirection.rtl, // تأكيد الاتجاه هنا أيضًا
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
                    onPressed: _createPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
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
                          textDirection: TextDirection.rtl, // تأكيد الاتجاه هنا أيضًا
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
                        textDirection: TextDirection.rtl, // تأكيد الاتجاه هنا
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
