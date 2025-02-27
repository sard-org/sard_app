import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import '../core/app_export.dart';
import 'en/en_translations.dart';

extension LocalizationExtension on String {
  String get tr => AppLocalization.of().getString(this);
}

class AppLocalization {
  AppLocalization(this.locale);
  
  final Locale locale;
  
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': en,
  };
  
  static AppLocalization of() {
    return Localizations.of<AppLocalization>(NavigatorService.navigatorKey.currentContext!, AppLocalization)!;
  }
  
  static List<String> languages() => _localizedValues.keys.toList();
  
  String getString(String text) {
    return _localizedValues[locale.languageCode]?[text] ?? text;
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return AppLocalization.languages().contains(locale.languageCode);
  }
  
  // Returning a synchronous Future here because the "load" operation is synchronous
  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture<AppLocalization>(AppLocalization(locale));
  }
  
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
