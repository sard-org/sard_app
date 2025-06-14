class ErrorTranslator {
  /// Translates common English error messages to Arabic
  static String translateError(String errorMessage) {
    // Clean the error message by removing extra spaces and converting to lowercase
    final cleanMessage = errorMessage.trim().toLowerCase();

    // Map of common error messages in English to Arabic
    final Map<String, String> errorMap = {
      'user already exists': 'المستخدم موجود بالفعل',
      'email already exists': 'البريد الإلكتروني موجود بالفعل',
      'user not found': 'المستخدم غير موجود',
      'invalid credentials': 'بيانات الدخول غير صحيحة',
      'invalid email': 'البريد الإلكتروني غير صحيح',
      'invalid password': 'كلمة المرور غير صحيحة',
      'password too short': 'كلمة المرور قصيرة جداً',
      'password too weak': 'كلمة المرور ضعيفة',
      'email is required': 'البريد الإلكتروني مطلوب',
      'password is required': 'كلمة المرور مطلوبة',
      'name is required': 'الاسم مطلوب',
      'invalid phone number': 'رقم الهاتف غير صحيح',
      'phone number already exists': 'رقم الهاتف موجود بالفعل',
      'account not verified': 'الحساب غير مفعل',
      'verification code expired': 'رمز التحقق منتهي الصلاحية',
      'invalid verification code': 'رمز التحقق غير صحيح',
      'too many requests': 'تم إرسال طلبات كثيرة، يرجى الانتظار',
      'network error': 'خطأ في الشبكة',
      'server error': 'خطأ في الخادم',
      'connection timeout': 'انتهت مهلة الاتصال',
      'unauthorized': 'غير مخول للوصول',
      'forbidden': 'ممنوع الوصول',
      'not found': 'غير موجود',
      'internal server error': 'خطأ داخلي في الخادم',
      'bad request': 'طلب غير صحيح',
      'service unavailable': 'الخدمة غير متاحة',
    };

    // Check for exact matches first
    if (errorMap.containsKey(cleanMessage)) {
      return errorMap[cleanMessage]!;
    }

    // Check for partial matches
    for (final entry in errorMap.entries) {
      if (cleanMessage.contains(entry.key)) {
        return entry.value;
      }
    }

    // If no translation found, return the original message
    // This ensures we don't lose any important error information
    return errorMessage;
  }

  /// Translates error messages with context (status code)
  static String translateErrorWithContext(
      String errorMessage, int? statusCode) {
    final translatedMessage = translateError(errorMessage);

    // If translation was found (different from original), return it
    if (translatedMessage != errorMessage) {
      return translatedMessage;
    }

    // If no specific translation found, provide generic message based on status code
    switch (statusCode) {
      case 400:
        return 'طلب غير صحيح - يرجى التحقق من البيانات المدخلة';
      case 401:
        return 'غير مخول - يرجى تسجيل الدخول مرة أخرى';
      case 403:
        return 'ممنوع الوصول - ليس لديك صلاحية لتنفيذ هذه العملية';
      case 404:
        return 'غير موجود - المورد المطلوب غير متاح';
      case 409:
        return 'تعارض في البيانات - المعلومات موجودة بالفعل';
      case 422:
        return 'بيانات غير صالحة - يرجى التحقق من المعلومات المدخلة';
      case 429:
        return 'تم تجاوز الحد المسموح - يرجى الانتظار قبل المحاولة مرة أخرى';
      case 500:
        return 'خطأ في الخادم - يرجى المحاولة لاحقاً';
      case 502:
        return 'خطأ في البوابة - يرجى المحاولة لاحقاً';
      case 503:
        return 'الخدمة غير متاحة مؤقتاً - يرجى المحاولة لاحقاً';
      case 504:
        return 'انتهت مهلة الاتصال - يرجى المحاولة مرة أخرى';
      default:
        return translatedMessage;
    }
  }
}
