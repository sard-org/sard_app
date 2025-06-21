import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../style/BaseScreen.dart';
import '../../../../../style/Colors.dart';
import '../../../../../style/Fonts.dart';
import '../../login/View/Login.dart';
import '../password_reset_cubits.dart';
import '../password_reset_api_service.dart';
import '../password_reset_states.dart';

class CreateNewPassword extends StatefulWidget {
  final String email;

  const CreateNewPassword({super.key, required this.email});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  
  // إضافة متغيرات لرسائل الخطأ
  String? _passwordError;
  String? _confirmPasswordError;
  
  // متغيرات مؤشر قوة كلمة المرور
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.grey;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // دالة حساب قوة كلمة المرور
  void _calculatePasswordStrength(String password) {
    double strength = 0.0;
    String strengthText = '';
    Color strengthColor = Colors.grey;

    if (password.isEmpty) {
      setState(() {
        _passwordStrength = 0.0;
        _passwordStrengthText = '';
        _passwordStrengthColor = Colors.grey;
      });
      return;
    }

    // الطول (8-20 حرف)
    if (password.length >= 8 && password.length <= 20) strength += 0.2;
    
    // الأحرف الكبيرة
    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;
    
    // الأحرف الصغيرة
    if (RegExp(r'[a-z]').hasMatch(password)) strength += 0.2;
    
    // الأرقام
    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;
    
    // الرموز الخاصة
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength += 0.2;

    // تحديد النص واللون بناءً على القوة
    if (strength < 0.4) {
      strengthText = 'ضعيفة';
      strengthColor = AppColors.red100;
    } else if (strength < 0.8) {
      strengthText = 'متوسطة';
      strengthColor = AppColors.yellow200;
    } else {
      strengthText = 'قوية';
      strengthColor = AppColors.green200;
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = strengthText;
      _passwordStrengthColor = strengthColor;
    });
  }

  // دالة التحقق من صحة كلمة المرور
  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'كلمة المرور مطلوبة';
    }
    if (password.length < 8) {
      return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
    }
    if (password.length > 20) {
      return 'كلمة المرور يجب ألا تزيد عن 20 حرف';
    }
    if (password.contains(' ')) {
      return 'كلمة المرور لا يجب أن تحتوي على مسافات';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'كلمة المرور يجب أن تحتوي على حرف كبير (A-Z)';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'كلمة المرور يجب أن تحتوي على حرف صغير (a-z)';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'كلمة المرور يجب أن تحتوي على رقم';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'كلمة المرور يجب أن تحتوي على رمز خاص (!@#\$%^&*)';
    }
    return null;
  }

  // دالة التحقق من تطابق كلمة المرور
  String? _validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'تأكيد كلمة المرور مطلوب';
    }
    
    if (password != confirmPassword) {
      return 'كلمة المرور وتأكيد كلمة المرور غير متطابقين';
    }
    
    // التحقق من نفس شروط كلمة المرور الأساسية
    return _validatePassword(confirmPassword);
  }

  // دالة التحقق من صحة جميع البيانات
  bool _validateForm() {
    setState(() {
      _passwordError = _validatePassword(_passwordController.text);
      _confirmPasswordError = _validateConfirmPassword(
        _passwordController.text,
        _confirmPasswordController.text,
      );
    });

    return _passwordError == null && _confirmPasswordError == null;
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
                  'نسيت كلمة المرور',
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
                        text: 'تم تغير كلمة المرور ',
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = CreatePasswordCubit(PasswordResetApiService.init());
        cubit.setEmail(widget.email);
        return cubit;
      },
      child: BlocConsumer<CreatePasswordCubit, PasswordResetState>(
        listener: (context, state) {
          if (state is CreatePasswordSuccess) {
            // إظهار popup النجاح بدلاً من SnackBar والتنقل المباشر
            _showSuccessPopup();
          } else if (state is CreatePasswordError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.red100,
              ),
            );
          }
        },
        builder: (context, state) {
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
                          const SizedBox(height: 16),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'إنشاء كلمة ',
                                    style: AppTexts.heading2Accent.copyWith(color: AppColors.neutral1000), // لون "إنشاء"
                                  ),
                                  TextSpan(
                                    text: 'مرور جديدة',
                                    style: AppTexts.heading2Accent.copyWith(color: AppColors.primary500), // غيّر اللون حسب ما يناسبك
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              'قم بتعيين كلمة مرور قوية للحفاظ على أمان حسابك',
                              style: AppTexts.highlightEmphasis.copyWith(color: AppColors.neutral600),
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
                            errorText: _passwordError,
                            showStrengthIndicator: true,
                          ),
                          const SizedBox(height: 16),
                          _buildPasswordField(
                            'تأكيد كلمة المرور',
                            _confirmPasswordController,
                            !_isConfirmPasswordVisible,
                            'أدخل تأكيد كلمة المرور',
                            () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                            errorText: _confirmPasswordError,
                          ),
                          _buildPasswordRequirements(),
                          const SizedBox(height: 36),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: state is CreatePasswordLoading
                              ? null
                              : () {
                                  if (_validateForm()) {
                                    context
                                        .read<CreatePasswordCubit>()
                                        .createNewPassword(
                                          _passwordController.text,
                                          _confirmPasswordController.text,
                                        );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: state is CreatePasswordLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'إنشاء كلمة المرور',
                                  style: AppTexts.contentEmphasis
                                      .copyWith(color: Colors.white),
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
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: Directionality(
                                textDirection: TextDirection.rtl,
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
                              textDirection: TextDirection.rtl,
                              child: Text(
                                "هل لديك حساب بالفعل؟",
                                style: AppTexts.contentRegular
                                    .copyWith(color: AppColors.neutral900),
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
        },
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'شروط كلمة المرور :',
              style: AppTexts.contentAccent.copyWith(
                color: AppColors.neutral600,
              ),
            ),
            const SizedBox(height: 4),
            _buildPasswordRequirement(
              '8 أحرف علي الأقل و 20 حرف بحد أقصى', 
              password.length >= 8 && password.length <= 20
            ),
            _buildPasswordRequirement(
              'عدم وجود مسافات', 
              !password.contains(' ')
            ),
            _buildPasswordRequirement(
              'تحتوي علي رقم ورمز',
              RegExp(r'[0-9]').hasMatch(password) && RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)
            ),
            _buildPasswordRequirement(
              'تحتوي علي حرف كبير (A-Z) و حرف صغير (a-z)', 
              RegExp(r'[A-Z]').hasMatch(password) && RegExp(r'[a-z]').hasMatch(password)
            ),
            _buildPasswordRequirement(
              'تطابق كلمة المرور', 
              password.isNotEmpty && confirmPassword.isNotEmpty && password == confirmPassword
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordRequirement(String requirement, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: isMet ? AppColors.green200 : AppColors.neutral400,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              requirement,
              style: AppTexts.captionAccent.copyWith(
                color: isMet ? AppColors.green200 : AppColors.neutral500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool obscureText, String hint, VoidCallback toggleVisibility, 
      {String? errorText, bool showStrengthIndicator = false}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTexts.highlightEmphasis),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            textDirection: TextDirection.rtl,
            obscureText: obscureText,
            onChanged: (value) {
              // إزالة رسالة الخطأ عند بدء الكتابة وتحديث الشروط
              setState(() {
                if (label == "كلمة المرور") {
                  _passwordError = null;
                  _calculatePasswordStrength(value);
                }
                if (label == "تأكيد كلمة المرور") _confirmPasswordError = null;
              });
            },
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTexts.contentRegular,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: errorText != null ? AppColors.red100 : AppColors.neutral400,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: errorText != null ? AppColors.red100 : AppColors.neutral400,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: errorText != null ? AppColors.red100 : AppColors.primary500,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: GestureDetector(
                onTap: toggleVisibility,
                child: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.neutral400,
                ),
              ),
            ),
          ),
          if (showStrengthIndicator && controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'قوة كلمة المرور : ',
                        style: AppTexts.contentAccent.copyWith(
                          color: AppColors.neutral600,
                        ),
                      ),
                      Text(
                        _passwordStrengthText,
                        style: AppTexts.contentRegular.copyWith(
                          color: _passwordStrengthColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: _passwordStrength,
                    backgroundColor: AppColors.neutral300,
                    valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
                  ),
                ],
              ),
            ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                errorText,
                style: AppTexts.contentRegular.copyWith(
                  color: AppColors.red100,
                  fontSize: 12,
                ),
              ),
            ),
          SizedBox(height: 12),
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
              style:
                  AppTexts.heading2Bold.copyWith(color: AppColors.neutral100),
            ),
          ),
        ],
      ),
    );
  }
}
