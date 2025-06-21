import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sard/src/screens/auth/login/View/Login.dart';

import '../../../../../../style/BaseScreen.dart';
import '../../../../../../style/Colors.dart';
import '../../../../../../style/Fonts.dart';
import '../../../../../utils/error_translator.dart';
import '../../registration/logic/register_cubit.dart';
import '../../registration/logic/register_state.dart';

class VerificationCodeScreen extends StatefulWidget {
  final String email;

  const VerificationCodeScreen({Key? key, required this.email})
      : super(key: key);

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isErrorShown = false;

  // Add local timer management like in forgot password screen
  Timer? _timer;
  int _secondsRemaining = 600; // 10 minutes like in cubit

  @override
  void initState() {
    super.initState();
    _startTimer();

    // Fix focus management to work properly with RTL
    for (int i = 0; i < 3; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1 && i < 3) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }

    // Don't automatically send OTP - backend sends it during registration
    // Just start the timer to sync with cubit timer
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final registerCubit = BlocProvider.of<RegisterCubit>(context);
      // Sync local timer with cubit timer
      if (registerCubit.secondsRemaining > 0) {
        setState(() {
          _secondsRemaining = registerCubit.secondsRemaining;
        });
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
        }
      });
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

  void _resendCode() {
    setState(() {
      _secondsRemaining = 600; // Reset to 10 minutes
      _isErrorShown = false;
    });
    _startTimer();

    _resetInputFields();

    final registerCubit = BlocProvider.of<RegisterCubit>(context);
    registerCubit.resendOtp();
  }

  // دالة لصق الكود من الحافظة
  Future<void> _handlePaste() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data?.text != null) {
        String pastedText = data!.text!.replaceAll(RegExp(r'\D'), ''); // إزالة كل ما ليس رقم
        
        if (pastedText.length >= 4) {
          // ملء الحقول الأربعة
          for (int i = 0; i < 4; i++) {
            _controllers[i].text = pastedText[i];
          }
          
          setState(() {
            _isErrorShown = false;
          });
          
          // التحقق التلقائي بعد لصق الكود
          Future.delayed(const Duration(milliseconds: 200), () {
            final otp = _getFullOtpCode();
            if (otp.length == 4) {
              final registerCubit = BlocProvider.of<RegisterCubit>(context);
              registerCubit.verifyOtp(otp: otp);
            }
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  'تم لصق الكود بنجاح',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orange,
              content: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  'الكود المنسوخ غير صحيح أو غير مكتمل',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'فشل في لصق الكود',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
  }

  // إضافة popup النجاح في أسفل الصفحة
  void _showSuccessPopup() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // العنوان
                Text(
                  'إنشاء حساب',
                  style: AppTexts.heading1Bold.copyWith(
                    color: AppColors.neutral1000,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // خط فاصل
                Container(
                  height: 1,
                  width: double.infinity,
                  color: AppColors.neutral300,
                ),
                const SizedBox(height: 24),
                
                // أيقونة النجاح
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.green200.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.green200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // النص الرئيسي
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'تم تسجيل حسابك ',
                        style: AppTexts.heading2Bold.copyWith(
                          color: AppColors.neutral1000,
                        ),
                      ),
                      TextSpan(
                        text: 'بنجاح',
                        style: AppTexts.heading2Bold.copyWith(
                          color: AppColors.green200,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // النص الفرعي
                Text(
                  'حاول الاحتفاظ بكلمة المرور بعيداً لتفادي نسيانها في المرات القادمة، كما يجب أن تكون حسابك و بياناتك آمنة.',
                  style: AppTexts.contentRegular.copyWith(
                    color: AppColors.neutral600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // زر تسجيل الدخول
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // إغلاق الـ popup
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'تسجيل الدخول',
                      style: AppTexts.contentEmphasis.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
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
    return BlocConsumer<RegisterCubit, RegisterStates>(
      listener: (context, state) {
        if (state is OtpVerificationSuccessState) {
          // إظهار popup النجاح بدلاً من SnackBar والتنقل المباشر
          _showSuccessPopup();
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
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
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
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              duration: const Duration(seconds: 3),
            ),
          );

          // إعادة تعيين حالة الخطأ وحقول الإدخال وإعادة تشغيل المؤقت
          setState(() {
            _isErrorShown = false;
          });
          _resetInputFields();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: BaseScreen(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'أدخل ',
                                  style: AppTexts.display1Bold.copyWith(color: AppColors.neutral1000), // لون البداية
                                ),
                                TextSpan(
                                  text: 'رمز التحقق',
                                  style: AppTexts.display1Bold.copyWith(color: AppColors.primary500), // اللون المميز
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'لقد قمنا بإرسال رمز التأكيد للبريد الإلكتروني التالي:',
                            style: AppTexts.highlightEmphasis.copyWith(color: AppColors.neutral600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            widget.email,
                            style: AppTexts.contentEmphasis,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 36),
                          // حقول إدخال OTP مع ترتيب صحيح وإدارة focus محسنة
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (index) {
                              // استخدام RTL index مثل شاشة forgot password
                              int rtlIndex = 3 - index;
                              return SizedBox(
                                width: 60,
                                child: TextField(
                                  controller: _controllers[rtlIndex],
                                  focusNode: _focusNodes[rtlIndex],
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  keyboardType: TextInputType.number,
                                  maxLength: 1,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: _isErrorShown
                                        ? AppColors.red100
                                        : (_controllers[rtlIndex].text.isNotEmpty
                                            ? AppColors.primary800
                                            : AppColors.neutral1000),
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

                                    // تحسين إدارة التنقل بين الحقول
                                    if (value.isNotEmpty && rtlIndex < 3) {
                                      _focusNodes[rtlIndex + 1].requestFocus();
                                    } else if (value.isEmpty && rtlIndex > 0) {
                                      _focusNodes[rtlIndex - 1].requestFocus();
                                    }

                                    // إذا تم إدخال جميع الأرقام الأربعة، قم بالتحقق تلقائيًا
                                    if (_controllers.every((controller) =>
                                        controller.text.isNotEmpty)) {
                                      // تأخير بسيط لإظهار الرقم الأخير قبل التحقق
                                      Future.delayed(
                                          const Duration(milliseconds: 200), () {
                                        final otp = _getFullOtpCode();
                                        if (otp.length == 4) {
                                          final registerCubit =
                                              BlocProvider.of<RegisterCubit>(
                                                  context);
                                          registerCubit.verifyOtp(otp: otp);
                                        }
                                      });
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 16),
                          // زر لصق الكود - حجم أصغر
                          Center(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: _handlePaste,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary500.withOpacity(0.1),
                                        AppColors.primary600.withOpacity(0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: AppColors.primary500.withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary500.withOpacity(0.08),
                                        blurRadius: 6,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.content_paste_rounded,
                                        size: 16,
                                        color: AppColors.primary600,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'لصق الكود',
                                        style: AppTexts.contentBold.copyWith(
                                          color: AppColors.primary600,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '(${_formatTime(_secondsRemaining)}) سينتهي الرمز خلال',
                                style: AppTexts.contentRegular.copyWith(
                                  color: _secondsRemaining == 0 
                                    ? AppColors.neutral600 
                                    : AppColors.primary500
                                ),
                              ),
                              const SizedBox(width: 4),
                              TextButton(
                                onPressed:
                                    _secondsRemaining == 0 ? _resendCode : null,
                                child: Text(
                                  'إعادة الإرسال',
                                  style: AppTexts.contentEmphasis.copyWith(
                                    color: _secondsRemaining == 0
                                        ? AppColors.primary500
                                        : AppColors.neutral400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
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
                                  final registerCubit =
                                      BlocProvider.of<RegisterCubit>(context);
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
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
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
                                  style: AppTexts.contentEmphasis
                                      .copyWith(color: Colors.white),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Wrap(
                          children: [
                            Text(
                              "هل لديك حساب بالفعل؟",
                              style: AppTexts.contentRegular
                                  .copyWith(color: AppColors.neutral900),
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
