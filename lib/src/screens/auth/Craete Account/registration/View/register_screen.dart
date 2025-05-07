import 'package:flutter/material.dart';
import '../../../../../../style/BaseScreen.dart';
import '../../../../../../style/Colors.dart';
import '../../../../../../style/Fonts.dart';
import '../../../login/View/Login.dart';
import '../../otp/View/otp.dart';

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

  // إضافة controller للـ ScrollView لتجنب مشكلة الـ overflow عند فتح لوحة المفاتيح
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BaseScreen(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "مرحبًا بك في سرد",
                          style: AppTexts.display1Bold,
                          textAlign: TextAlign.center,
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
                      const SizedBox(height: 24),
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
                      _buildRegisterButton(),
                      const SizedBox(height: 16),
                      _buildLoginLink(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      // إضافة resizeToAvoidBottomInset لمنع المشاكل عند ظهور لوحة المفاتيح
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (_passwordController.text != _confirmPasswordController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text('كلمة المرور وتأكيد كلمة المرور غير متطابقي'),
                    ),
                )
              );
              return;
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerificationCodeScreen(), // غيّر اسم الصفحة حسب ما عندك
              ),
            );

          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary500,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: Text(
            "إنشاء حساب",
            style: AppTexts.contentEmphasis.copyWith(color: AppColors.neutral100),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
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
    );
  }

  Widget _buildTextField(
      String label,
      String hint,
      TextEditingController controller, {
        bool obscureText = false,
        VoidCallback? toggleVisibility,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(label, style: AppTexts.contentRegular),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            textAlign: TextAlign.right,
            obscureText: obscureText,
            onTap: () {
              // التمرير لأسفل عند الضغط على الحقل لتجنب مشكلة الـ overflow
              Future.delayed(const Duration(milliseconds: 300), () {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              });
            },
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        ],
      ),
    );
  }
}