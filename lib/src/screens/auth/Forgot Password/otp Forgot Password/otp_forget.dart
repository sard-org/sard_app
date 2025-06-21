import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../style/BaseScreen.dart';
import '../../../../../style/Colors.dart';
import '../../../../../style/Fonts.dart';
import '../../../../utils/error_translator.dart';
import '../../login/View/Login.dart';
import '../Create a New Password/create_a_new_password.dart';
import '../password_reset_cubits.dart';
import '../password_reset_api_service.dart';
import '../password_reset_states.dart';

class OtpVerificationCodeScreen extends StatefulWidget {
  final String email;
  
  const OtpVerificationCodeScreen({super.key, required this.email});

  @override
  State<OtpVerificationCodeScreen> createState() => _OtpVerificationCodeScreenState();
}

class _OtpVerificationCodeScreenState extends State<OtpVerificationCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  Timer? _timer;
  int _secondsRemaining = 600;

  @override
  void initState() {
    super.initState();
    _startTimer();

    for (int i = 0; i < 3; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
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

  void _resendCode() {
    setState(() {
      _secondsRemaining = 600;
    });
    _startTimer();

    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();

    context.read<OtpVerificationCubit>().resendOtp();
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
    return BlocProvider(
      create: (context) {
        final cubit = OtpVerificationCubit(PasswordResetApiService.init());
        cubit.setEmail(widget.email);
        return cubit;
      },
      child: BlocConsumer<OtpVerificationCubit, PasswordResetState>(
        listener: (context, state) {
          if (state is OtpVerificationSuccess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateNewPassword(email: state.email),
              ),
            );
          } else if (state is OtpVerificationError) {
            String errorMessage = ErrorTranslator.translateError(state.message);
            if (state.attemptsLeft > 0) {
              String attemptText = state.attemptsLeft == 1 ? 'محاولة' : 'محاولات';
              errorMessage += '. المتبقي: ${state.attemptsLeft} $attemptText';
            }
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontFamily: 'Cairo'),
                  ),
                ),
                backgroundColor: AppColors.red100,
              ),
            );
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(4, (index) {
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
                                      color: _controllers[rtlIndex].text.isNotEmpty
                                          ? AppColors.primary800
                                          : Colors.black,
                                    ),
                                    decoration: InputDecoration(
                                      counterText: '',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.neutral300),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: AppColors.primary500, width: 2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    onChanged: (value) {
                                      setState(() {});
                                      if (value.isNotEmpty && rtlIndex < 3) {
                                        _focusNodes[rtlIndex + 1].requestFocus();
                                      } else if (value.isEmpty && rtlIndex > 0) {
                                        _focusNodes[rtlIndex - 1].requestFocus();
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
                                  '(${_formatTime(_secondsRemaining)}) سينتهي الرمز خلال',
                                  style: AppTexts.contentRegular.copyWith(
                                    color: _secondsRemaining == 0 
                                      ? AppColors.neutral600 
                                      : AppColors.primary500
                                  ),
                                ),
                                const SizedBox(width: 4),
                                TextButton(
                                  onPressed: _secondsRemaining == 0 ? _resendCode : null,
                                  child: Text(
                                    'إعادة الإرسال',
                                    style: AppTexts.contentEmphasis.copyWith(
                                      color: _secondsRemaining == 0 ? AppColors.primary500 : AppColors.neutral400,
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: state is OtpVerificationLoading
                                ? null
                                : () {
                                    String code = _controllers.map((controller) => controller.text).join();
                                    if (code.length == 4) {
                                      context.read<OtpVerificationCubit>().verifyOtp(code);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: Text('الرجاء إدخال الرمز كاملاً'),
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
                            child: state is OtpVerificationLoading
                                ? CircularProgressIndicator(color: AppColors.neutral100)
                                : Text(
                                    'تحقق',
                                    style: AppTexts.contentEmphasis.copyWith(color: AppColors.neutral100),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Wrap(
                            children: [
                              Text(
                                "هل لديك حساب بالفعل؟",
                                style: AppTexts.contentRegular.copyWith(color: AppColors.neutral900),
                              ),
                              const SizedBox(width: 4),
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
                            ],
                          ),
                        ),
                      ],
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
