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

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String selectedGender = "ذكر";
  XFile? _pickedImage;
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
            if (_lastUserName != user.name ||
                _lastPhoneNumber != user.phone ||
                selectedGender != (user.gender == 'male' ? 'ذكر' : 'أنثى')) {
              _emailController.text = user.email;
              _nameController.text = user.name;
              _phoneController.text = user.phone ?? '';
              selectedGender = user.gender == 'male' ? 'ذكر' : 'أنثى';
              _lastUserName = user.name;
              _lastPhoneNumber = user.phone;
              setState(() {});
            }
          }
          if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تم تحديث البيانات بنجاح')),
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
                                    child: _pickedImage != null
                                        ? Image.file(
                                            File(_pickedImage!.path),
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          )
                                        : (state is ProfileLoaded &&
                                                state.user.imageUrl != null
                                            ? Image.network(
                                                state.user.imageUrl!,
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/img/Avatar.png',
                                                    width: 80,
                                                    height: 80,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              )
                                            : Image.asset(
                                                'assets/img/Avatar.png',
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.cover,
                                              )),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: _pickImage,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green,
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
                              child: Text(
                                _nameController.text,
                                style: AppTexts.heading2Bold,
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
                            _buildEmailField(),
                            _buildPhoneField(),
                            _buildDropdownField(
                                "النوع", ["ذكر", "أنثى"], selectedGender,
                                (value) {
                              setState(() {
                                selectedGender = value!;
                              });
                            }),
                            SizedBox(height: 24),
                            if (state is ProfileUpdateLoading)
                              Center(child: CircularProgressIndicator()),
                            if (state is! ProfileUpdateLoading)
                              UpdateButton(
                                title: "تحديث",
                                onPressed: _validateAndUpdate,
                              ),
                          ],
                        ),
                      ),
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
            hintText: "01023359621",
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
      String selectedValue, Function(String?) onChanged) {
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
    // تحويل النوع
    String genderApiValue = selectedGender == 'ذكر' ? 'male' : 'female';

    // جمع البيانات
    final data = {
      'name': _nameController.text,
      'phone': _phoneController.text,
      'gender': genderApiValue,
      // أضف أي بيانات أخرى حسب الحاجة
    };

    // استدعاء التحديث
    context.read<ProfileCubit>().updateUserProfile(data);
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }
}
