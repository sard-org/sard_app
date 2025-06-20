import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../style/BaseScreen.dart';
import '../../../../../style/Colors.dart';
import '../../../../../style/Fonts.dart';
import '../../../../utils/text_input_formatters.dart';
import '../../../../utils/error_translator.dart';
import '../password_reset_cubits.dart';
import '../password_reset_api_service.dart';
import '../otp Forgot Password/otp_forget.dart';
import '../password_reset_states.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(PasswordResetApiService.init()),
      child: BlocConsumer<ForgetPasswordCubit, PasswordResetState>(
        listener: (context, state) {
          if (state is ForgetPasswordSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OtpVerificationCodeScreen(email: state.email),
              ),
            );
          } else if (state is ForgetPasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    ErrorTranslator.translateError(state.message),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  _buildAppBar(context),
                  Expanded(
                    child: BaseScreen(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 64),
                          Align(
                            alignment: Alignment.center,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'نسيت ',
                                    style: AppTexts.display1Bold.copyWith(color: AppColors.neutral1000),
                                  ),
                                  TextSpan(
                                    text: 'كلمة المرور؟',
                                    style: AppTexts.display1Bold.copyWith(color: AppColors.primary500), // غيّر اللون حسب رغبتك
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              "أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور.",
                              style: AppTexts.highlightEmphasis.copyWith(color: AppColors.neutral600),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text("البريد الإلكتروني",
                              style: AppTexts.contentRegular),
                          const SizedBox(height: 8),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              inputFormatters: [LowercaseTextInputFormatter()],
                              decoration: InputDecoration(
                                hintText: "أدخل بريدك الإلكتروني",
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
                      onPressed: state is ForgetPasswordLoading
                          ? null
                          : () {
                              if (_emailController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text(
                                        'الرجاء إدخال البريد الإلكتروني',
                                        style: TextStyle(color: AppColors.neutral100),
                                      ),
                                    ),
                                    backgroundColor:  AppColors.red100,
                                  ),

                                );
                                return;
                              }
                              context
                                  .read<ForgetPasswordCubit>()
                                  .sendResetEmail(
                                      _emailController.text.toLowerCase());
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary500,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: state is ForgetPasswordLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "إرسال",
                              style: AppTexts.contentEmphasis
                                  .copyWith(color: AppColors.neutral100),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
          mainAxisAlignment:
              MainAxisAlignment.start, // زر الرجوع والعنوان على اليمين كما هو
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
                child: Icon(Icons.arrow_back,
                    color: AppColors.primary500), // السهم على اليمين كما هو
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
