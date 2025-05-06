import 'package:flutter/material.dart';
import '../../../../style/BaseScreen.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../otp/otp.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            _buildAppBar(context), // زر الرجوع مع العنوان
            Expanded(
              child: BaseScreen(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 64),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "نسيت كلمة المرور؟",
                        style: AppTexts.display1Bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور.",
                        style: AppTexts.highlightEmphasis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text("البريد الإلكتروني", style: AppTexts.contentRegular),
                    const SizedBox(height: 8),
                    Directionality(
                      textDirection: TextDirection.rtl, // جعل النص من اليمين
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "أدخل بريدك الإلكتروني",
                          hintStyle: AppTexts.contentRegular,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: AppColors.neutral400),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerificationCodeScreen()),
                  );                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary500,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "إرسال",
                  style: AppTexts.contentEmphasis.copyWith(color: AppColors.neutral100),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primary500,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // زر الرجوع والعنوان على اليمين كما هو
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context), // العودة للصفحة السابقة
              child: Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.arrow_back, color: AppColors.primary500), // السهم على اليمين كما هو
              ),
            ),
            SizedBox(width: 12),
            Text(
              "نسيت كلمة المرور",
              style: AppTexts.heading2Bold.copyWith(
                color: AppColors.neutral100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
