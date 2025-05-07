class RegisterScreenResponse {
  final bool success;
  final String message;

  RegisterScreenResponse({required this.success, required this.message});

  factory RegisterScreenResponse.fromJson(Map<String, dynamic> json) {
    return RegisterScreenResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
