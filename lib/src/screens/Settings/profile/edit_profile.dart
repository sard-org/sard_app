import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sard/src/screens/Settings/profile/profile_cubit.dart';
import 'package:sard/src/screens/Settings/profile/profile_state.dart';
import '../../../../style/BaseScreen.dart';
import '../../../../style/Colors.dart';
import '../../../../style/Fonts.dart';
import '../Change Password/change_password.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../../../utils/error_translator.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String? selectedGender;
  XFile? _pickedImage;
  Uint8List? _imageBytes; // For web compatibility
  String? _lastUserName;
  String? _lastPhoneNumber;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        BlocProvider.of<ProfileCubit>(context).getUserProfile();
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded || state is ProfileUpdateSuccess) {
            final user = state is ProfileLoaded
                ? state.user
                : (state as ProfileUpdateSuccess).user;
            String? newGender;
            if (user.gender == 'male') {
              newGender = 'ذكر';
            } else if (user.gender == 'female') {
              newGender = 'أنثى';
            } else {
              newGender = null; // لم يتم اختيار النوع بعد
            }
            
            if (_lastUserName != user.name ||
                _lastPhoneNumber != user.phone ||
                selectedGender != newGender) {
              _emailController.text = user.email;
              _nameController.text = user.name;
              _phoneController.text = user.phone ?? '';
              selectedGender = newGender;
              _lastUserName = user.name;
              _lastPhoneNumber = user.phone;
              setState(() {});
            }
          }
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'تم تحديث البيانات بنجاح',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                backgroundColor: AppColors.green200,
                duration: Duration(seconds: 3),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            // تنظيف الصورة المحددة بعد النجاح
            setState(() {
              _pickedImage = null;
              _imageBytes = null;
            });
          }
          if (state is ProfileError) {
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
          if (state is ProfileUpdateError) {
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
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: BaseScreen(
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Center(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipOval(
                                    child: _buildImageWidget(state),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: _pickImage,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.green200,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Colors.white, width: 2),
                                        ),
                                        padding: EdgeInsets.all(4),
                                        child: Icon(Icons.camera_alt,
                                            color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Center(
                              child: BlocBuilder<ProfileCubit, ProfileState>(
                                builder: (context, state) {
                                  if (state is ProfileLoaded) {
                                    return Text(
                                      state.user.name,
                                      style: AppTexts.heading2Bold,
                                    );
                                  }
                                  if (state is ProfileUpdateSuccess) {
                                    return Text(
                                      state.user.name,
                                      style: AppTexts.heading2Bold,
                                    );
                                  }
                                  return Text(
                                    "",
                                    style: AppTexts.heading2Bold,
                                  );
                                },
                              ),
                            ),
                            if (_pickedImage != null)
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  margin: EdgeInsets.only(top: 8),
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.green.shade300),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "لقد قمت باضافة صوره جديده",
                                        style: AppTexts.contentRegular.copyWith(
                                          color: Colors.green.shade700,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
                                    ],
                                  ),
                                ),
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("الاسم", style: AppTexts.contentRegular),
                                SizedBox(height: 8),
                                TextField(
                                  controller: _nameController,
                                  onChanged: (_) => setState(() {}),
                                  textAlign: TextAlign.right,
                                  decoration: InputDecoration(
                                    hintText: "الاسم",
                                    hintStyle: AppTexts.contentRegular,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: AppColors.neutral400),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 12),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _buildEmailField(),
                            const SizedBox(height: 16),
                            _buildPhoneField(),
                            const SizedBox(height: 16),
                            _buildDropdownField(
                                "النوع", ["ذكر", "أنثى"], selectedGender,
                                (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            }),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // زر التحديث في أسفل الشاشة
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: UpdateButton(
                      title: "تحديث",
                      isLoading: state is ProfileUpdateLoading,
                      onPressed: _validateAndUpdate,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.primary500,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "تعديل البيانات",
            style: AppTexts.heading2Bold.copyWith(
              color: AppColors.neutral100,
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_forward, color: AppColors.primary500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("البريد الإلكتروني", style: AppTexts.contentRegular),
        SizedBox(height: 8),
        TextField(
          controller: _emailController,
          textAlign: TextAlign.right,
          keyboardType: TextInputType.emailAddress,
          enabled: false, // Make email field non-editable
          decoration: InputDecoration(
            hintText: "ahmdhsamhmd2@gmail.com",
            hintStyle: AppTexts.contentRegular,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutral400),
            ),
            filled: true,
            fillColor:
                AppColors.neutral200, // Gray background to indicate disabled
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutral300),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 4, right: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "لا يمكن تغيير البريد الإلكتروني",
                textAlign: TextAlign.right,
                style: AppTexts.contentRegular.copyWith(
                  color: AppColors.neutral500,
                  fontSize: 12,
                ),
              ),
              Text(
                "لتغيير البريد الإلكتروني تواصل مع الدعم الفني",
                textAlign: TextAlign.right,
                style: AppTexts.contentRegular.copyWith(
                  color: AppColors.primary500,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("رقم الهاتف", style: AppTexts.contentRegular),
        SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          textAlign: TextAlign.right,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: "قم بادخال رقم هاتفك",
            hintStyle: AppTexts.contentRegular,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.neutral400),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> options,
      String? selectedValue, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: AppTexts.contentRegular),
        SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral400),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectedValue,
                hint: Text(
                  "قم بالاختيار",
                  textAlign: TextAlign.right,
                  style: AppTexts.contentRegular.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
                icon: Icon(Icons.arrow_drop_down, color: AppColors.neutral500),
                items: options.map((option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(option, textAlign: TextAlign.right),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  void _validateAndUpdate() {
    // التحقق من اختيار النوع
    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              'يرجى اختيار النوع',
              textAlign: TextAlign.right,
              style: TextStyle(fontFamily: 'Cairo'),
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // تحويل النوع
    String genderApiValue = selectedGender == 'ذكر' ? 'male' : 'female';

    // جمع البيانات
    final data = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'gender': genderApiValue,
      // أضف أي بيانات أخرى حسب الحاجة
    };

    // تحويل الصورة إلى File إذا تم اختيارها (للموبايل فقط)
    File? imageFile;
    if (_pickedImage != null && !kIsWeb) {
      imageFile = File(_pickedImage!.path);
    }

    // استدعاء التحديث مع الصورة
    if (kIsWeb && _imageBytes != null) {
      // For web, use bytes
      context.read<ProfileCubit>().updateUserProfile(
        data,
        imageBytes: _imageBytes,
        imageName: _pickedImage?.name ?? 'profile_image.jpg',
      );
    } else {
      // For mobile or no image
      context.read<ProfileCubit>().updateUserProfile(data, imageFile: imageFile);
    }
  }

  Widget _buildImageWidget(ProfileState state) {
    // If new image is picked
    if (_pickedImage != null) {
      if (kIsWeb) {
        // For web, use Image.memory with bytes
        if (_imageBytes != null) {
          return Image.memory(
            _imageBytes!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          );
        } else {
          return Image.asset(
            'assets/img/Avatar.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          );
        }
      } else {
        // For mobile, use Image.file
        return Image.file(
          File(_pickedImage!.path),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        );
      }
    }
    
    // If no new image, show existing profile image or default
    if (state is ProfileLoaded && state.user.imageUrl != null) {
      return Image.network(
        state.user.imageUrl!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/img/Avatar.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          );
        },
      );
    }
    
    // Default avatar
    return Image.asset(
      'assets/img/Avatar.png',
      width: 80,
      height: 80,
      fit: BoxFit.cover,
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
      
      // For web, also load the bytes
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      }
    }
  }
}

class UpdateButton extends StatelessWidget {
  final String title;
  final bool isLoading;
  final VoidCallback onPressed;

  const UpdateButton({
    Key? key,
    required this.title,
    required this.isLoading,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary500,
          disabledBackgroundColor: AppColors.primary300,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2.0,
                ),
              )
            : Text(
                title,
                style: AppTexts.highlightAccent.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
