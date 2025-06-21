import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../style/BaseScreen.dart';
import '../../../../../../style/Colors.dart';
import '../../../../../../style/Fonts.dart';
import '../../../../../utils/text_input_formatters.dart';
import '../../../login/View/Login.dart';
import '../../otp/View/otp.dart';

import '../logic/register_cubit.dart';
import '../logic/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // إضافة controller للـ ScrollView لتجنب مشكلة الـ overflow عند فتح لوحة المفاتيح
  final ScrollController _scrollController = ScrollController();

  // إضافة متغيرات لرسائل الخطأ
  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  
  // متغيرات مؤشر قوة كلمة المرور
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.grey;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // دالة التحقق من صحة الاسم
  String? _validateName(String name) {
    if (name.trim().isEmpty) {
      return 'الاسم الكامل مطلوب';
    }
    if (name.trim().length < 2) {
      return 'الاسم يجب أن يكون أكثر من حرفين';
    }
    return null;
  }

  // دالة التحقق من صحة البريد الإلكتروني
  String? _validateEmail(String email) {
    if (email.trim().isEmpty) {
      return 'البريد الإلكتروني مطلوب';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email.trim())) {
      return 'البريد الإلكتروني غير صحيح';
    }
    return null;
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
      _nameError = _validateName(_nameController.text);
      _emailError = _validateEmail(_emailController.text);
      _passwordError = _validatePassword(_passwordController.text);
      _confirmPasswordError = _validateConfirmPassword(
        _passwordController.text,
        _confirmPasswordController.text,
      );
    });

    return _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            // Create a completely new RegisterCubit for OTP screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) =>
                      RegisterCubit()..setRegisteredEmail(state.email),
                  child: VerificationCodeScreen(email: state.email),
                ),
              ),
            );
          } else if (state is RegisterErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(state.error),
                ),
              ),
            );
          } else if (state is PasswordsNotMatchingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text('كلمة المرور وتأكيد كلمة المرور غير متطابقين'),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
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
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'مرحبًا بك في ',
                                      style: AppTexts.display1Bold.copyWith(color: AppColors.neutral1000),
                                    ),
                                    TextSpan(
                                      text: 'سرد',
                                      style: AppTexts.display1Bold.copyWith(color: AppColors.primary500), // غيّر اللون حسب رغبتك
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "الرجاء إدخال بريدك الإلكتروني وسنرسل رمز التأكيد إلى بريدك الإلكتروني",
                                style: AppTexts.highlightEmphasis.copyWith(color: AppColors.neutral600),
                                textAlign: TextAlign.center,

                              ),
                            ),
                            const SizedBox(height: 24),
                            _buildTextField(
                                "الاسم الكامل", "أدخل اسمك", _nameController,
                                errorText: _nameError),
                            const SizedBox(height: 16),
                            _buildTextField("البريد الإلكتروني",
                                "أدخل بريدك الإلكتروني", _emailController,
                                isEmailField: true, errorText: _emailError),
                            const SizedBox(height: 16),
                            _buildTextField(
                              "كلمة المرور",
                              "أدخل كلمة المرور",
                              _passwordController,
                              obscureText: _obscurePassword,
                              errorText: _passwordError,
                              showStrengthIndicator: true,
                              toggleVisibility: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              "تأكيد كلمة المرور",
                              "أعد إدخال كلمة المرور",
                              _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              errorText: _confirmPasswordError,
                              toggleVisibility: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
                                });
                              },
                            ),
                            _buildPasswordRequirements(),
                            const SizedBox(height: 24),
                            _buildRegisterButton(context, state),
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
        },
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context, RegisterStates state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: state is RegisterLoadingState
              ? null
              : () {
                  if (_validateForm()) {
                    BlocProvider.of<RegisterCubit>(context).registerUser(
                      name: _nameController.text,
                      email: _emailController.text.toLowerCase(),
                      password: _passwordController.text,
                      confirmPassword: _confirmPasswordController.text,
                    );
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary500,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: state is RegisterLoadingState
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  "إنشاء حساب",
                  style: AppTexts.contentEmphasis
                      .copyWith(color: AppColors.neutral100),
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
              style: AppTexts.contentAccent.copyWith(
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

  Widget _buildPasswordRequirements() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            ': شروط كلمة المرور',
            style: AppTexts.contentAccent.copyWith(
              color: AppColors.neutral600,
            ),
            textAlign: TextAlign.right,
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
    );
  }

  Widget _buildPasswordRequirement(String requirement, bool isMet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            requirement,
            style: AppTexts.captionAccent.copyWith(
              color: isMet ? Colors.green : AppColors.neutral500,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: isMet ? Colors.green : AppColors.neutral400,
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
    bool isEmailField = false,
    String? errorText,
    bool showStrengthIndicator = false,
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
            inputFormatters:
                isEmailField ? [LowercaseTextInputFormatter()] : null,
            onChanged: (value) {
              // إزالة رسالة الخطأ عند بدء الكتابة
              setState(() {
                if (label == "الاسم الكامل") _nameError = null;
                if (label == "البريد الإلكتروني") _emailError = null;
                if (label == "كلمة المرور") {
                  _passwordError = null;
                  _calculatePasswordStrength(value);
                }
                if (label == "تأكيد كلمة المرور") {
                  _confirmPasswordError = null;
                  // تحديث شروط كلمة المرور لإظهار حالة التطابق
                }
              });
            },
            onTap: () {
              // التمرير لأسفل عند الضغط على الحقل لتجنب مشكلة الـ overflow
              Future.delayed(const Duration(milliseconds: 300), () {
                if (_scrollController.hasClients) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                }
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
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.red100),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.red100, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          if (showStrengthIndicator && controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _passwordStrengthText,
                        style: AppTexts.contentRegular.copyWith(
                          color: _passwordStrengthColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        ': قوة كلمة المرور',
                        style: AppTexts.contentAccent.copyWith(
                          color: AppColors.neutral600,

                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: LinearProgressIndicator(
                      value: _passwordStrength,
                      backgroundColor: AppColors.neutral300,
                      valueColor: AlwaysStoppedAnimation<Color>(_passwordStrengthColor),
                    ),
                  ),
                ],
              ),
            ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 8),
              child: Text(
                errorText,
                style: AppTexts.contentRegular.copyWith(
                  color: AppColors.red100,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
            ),
        ],
      ),
    );
  }
}
