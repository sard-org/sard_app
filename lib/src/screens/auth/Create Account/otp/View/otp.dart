import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sard/src/screens/Home/home.dart';
import 'package:sard/src/screens/auth/login/View/Login.dart';

import '../../../../../../main.dart';
import '../../../../../../style/BaseScreen.dart';
import '../../../../../../style/Colors.dart';
import '../../../../../../style/Fonts.dart';
import '../../registration/logic/register_cubit.dart';
import '../../registration/logic/register_state.dart';


class VerificationCodeScreen extends StatefulWidget {
  final String email;

  const VerificationCodeScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
      4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isErrorShown = false;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 3; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }

    // Send OTP when screen is first opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final registerCubit = BlocProvider.of<RegisterCubit>(context);
      registerCubit.sendOtp(email: widget.email);
    });
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _getFullOtpCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  // إعادة تعيين حقول الإدخال
  void _resetInputFields() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = RegisterCubit();
        // Remove automatic OTP send on screen creation
        return cubit;
      },
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is OtpVerificationSuccessState) {
            // إظهار رسالة النجاح
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.green100,
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    state.message,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                duration: const Duration(seconds: 2),
              ),
            );
            // التنقل إلى صفحة تسجيل الدخول بعد التحقق من الرمز بنجاح
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          } else if (state is OtpVerificationErrorState) {
            setState(() {
              _isErrorShown = true;
            });

            // إظهار رسالة الخطأ مع عدد المحاولات المتبقية
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.red100,
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    '${state.error}. المحاولات المتبقية: ${state.attemptsLeft}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                duration: const Duration(seconds: 3),
              ),
            );

            // إعادة تعيين حقول الإدخال
            _resetInputFields();
          } else if (state is MaxAttemptsReachedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.red100,
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'تم تجاوز الحد الأقصى للمحاولات، سيتم إرسال رمز جديد',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                duration: Duration(seconds: 3),
              ),
            );

            // إعادة تعيين حقول الإدخال
            _resetInputFields();
          } else if (state is OtpSentSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.green100,
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    state.message,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
                duration: const Duration(seconds: 3),
              ),
            );

            // إعادة تعيين حالة الخطأ وحقول الإدخال
            setState(() {
              _isErrorShown = false;
            });
            _resetInputFields();
          }
        },
        builder: (context, state) {
          final registerCubit = BlocProvider.of<RegisterCubit>(context);
          final secondsRemaining = state is TimerTickState ? state
              .secondsRemaining : registerCubit.secondsRemaining;

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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            'أدخل رمز التحقق',
                            style: AppTexts.display1Bold,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'لقد قمنا بإرسال رمز التأكيد للبريد الإلكتروني التالي:',
                            style: AppTexts.highlightEmphasis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.email,
                            style: AppTexts.contentEmphasis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 36),
                          // عكس ترتيب حقول الإدخال ليكون من اليسار لليمين
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (index) {
                              // استخدام index معكوس للحصول على ترتيب من اليسار لليمين
                              final reversedIndex = 3 - index;
                              return SizedBox(
                                width: 60,
                                child: TextField(
                                  controller: _controllers[reversedIndex],
                                  focusNode: _focusNodes[reversedIndex],
                                  textAlign: TextAlign.center,
                                  // استخدام TextDirection.ltr لجعل الكتابة من اليسار لليمين
                                  textDirection: TextDirection.ltr,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: _isErrorShown
                                        ? AppColors.red100
                                        : (_controllers[reversedIndex].text.isNotEmpty
                                        ? AppColors.primary800
                                        : AppColors.neutral1000 ),
                                  ),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: _isErrorShown
                                              ? AppColors.red100
                                              : AppColors.neutral300),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: _isErrorShown
                                              ? AppColors.red100
                                              : AppColors.primary500,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      if (_isErrorShown) {
                                        _isErrorShown = false;
                                      }
                                    });

                                    if (value.isNotEmpty && reversedIndex > 0) {
                                      _focusNodes[reversedIndex - 1].requestFocus();
                                    } else if (value.isEmpty && reversedIndex < 3) {
                                      _focusNodes[reversedIndex + 1].requestFocus();
                                    }

                                    // إذا تم إدخال جميع الأرقام الأربعة، قم بالتحقق تلقائيًا
                                    if (_controllers.every((controller) => controller.text.isNotEmpty)) {
                                      // تأخير بسيط لإظهار الرقم الأخير قبل التحقق
                                      Future.delayed(const Duration(milliseconds: 200), () {
                                        final otp = _getFullOtpCode();
                                        if (otp.length == 4) {
                                          registerCubit.verifyOtp(otp: otp);
                                        }
                                      });
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '(${_formatTime(
                                    secondsRemaining)}) سينتهي الرمز خلال',
                                style: AppTexts.contentRegular.copyWith(
                                    color: AppColors.primary500),
                              ),
                              const SizedBox(width: 4),
                              TextButton(
                                onPressed: secondsRemaining == 0
                                    ? () => registerCubit.resendOtp()
                                    : null,
                                child: Text(
                                  'إعادة الإرسال',
                                  style: AppTexts.contentEmphasis.copyWith(
                                    color: secondsRemaining == 0 ? AppColors
                                        .primary500 : AppColors.neutral400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  // هذا الجزء يمثل الـ "ناڤ بار" الذي يحتوي على الأزرار في أسفل الصفحة
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: state is OtpVerificationLoadingState
                                ? null
                                : () {
                              final otp = _getFullOtpCode();
                              if (otp.length == 4) {
                                registerCubit.verifyOtp(otp: otp);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.orange,
                                    content: Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: Text(
                                        'الرجاء إدخال الرمز كاملاً (4 أرقام)',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary500,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: state is OtpVerificationLoadingState
                                ? const CircularProgressIndicator(
                                color: Colors.white)
                                : Text(
                              'تحقق',
                              style: AppTexts.contentEmphasis.copyWith(
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Wrap(
                            children: [
                              Text(
                                "هل لديك حساب بالفعل؟",
                                style: AppTexts.contentRegular.copyWith(
                                    color: AppColors.neutral900),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_back, color: AppColors.primary500),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "رمز التحقق",
            style: AppTexts.heading2Bold.copyWith(color: AppColors.neutral100),
          ),
        ],
      ),
    );
  }
}