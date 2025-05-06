import 'package:flutter/material.dart';
import 'package:sard/src/screens/Home/home.dart';
import '../../../../main.dart';
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
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        // استخدام SafeArea لضمان عدم تداخل المحتوى مع الشاشة
        body: SafeArea(
          child: BaseScreen(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.06),
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
                        focusNode: _emailFocusNode,
                        nextFocusNode: _passwordFocusNode,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildTextField(
                        label: 'كلمة المرور',
                        hint: 'أدخل كلمة المرور',
                        controller: _passwordController,
                        focusNode: _passwordFocusNode,
                        obscureText: _obscurePassword,
                        toggleVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        // إضافة onSubmitted لإغلاق لوحة المفاتيح عند الضغط على زر Done
                        onSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                      ),
                      // إضافة Padding بدلاً من Row للتحكم بشكل أفضل في عرض المحتوى
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (val) {
                                      setState(() {
                                        _rememberMe = val!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 4),
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
                      ),
                      const SizedBox(height: 24),
                      // يمكن استخدام SizedBox أو Container حول الزر للتحكم في حجمه
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MainScreen()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            // إضافة padding لتجنب مشاكل النص الطويل
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          ),
                          child: Text(
                            "تسجيل الدخول",
                            style: AppTexts.contentEmphasis.copyWith(color: AppColors.neutral100),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
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
                              child: Text(
                                "إنشاء حساب",
                                style: AppTexts.contentEmphasis.copyWith(
                                    color: AppColors.primary500,
                                    decoration: TextDecoration.underline
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // إضافة مساحة إضافية في الأسفل لضمان عدم وجود overflow
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocusNode,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
    TextInputType? keyboardType,
    ValueChanged<String>? onSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTexts.contentRegular),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.right,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: nextFocusNode != null ? TextInputAction.next : TextInputAction.done,
          onFieldSubmitted: (value) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else if (onSubmitted != null) {
              onSubmitted(value);
            }
          },
          // استخدام TextField بدلاً من TextFormField للحصول على سلوك أفضل
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTexts.contentRegular,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutral400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutral400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary500, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            // تعديل موضع أيقونة العرض لتكون في اليسار (مع اتجاه RTL)
            suffixIcon: toggleVisibility != null
                ? IconButton(
              onPressed: toggleVisibility,
              icon: Icon(
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