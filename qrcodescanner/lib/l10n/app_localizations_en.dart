// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'AI QR Scanner';

  @override
  String get scannerTab => 'Scanner';

  @override
  String get generatorTab => 'Create';

  @override
  String get historyTab => 'History';

  @override
  String get scannerTitle => 'Scan QR Code';

  @override
  String get scanInstruction => 'Point your camera at a QR code';

  @override
  String get scanStatusInitial => 'Point the camera at a QR code';

  @override
  String get aiAnalysisTitle => 'AI Analysis';

  @override
  String get aiSecurityAnalysisTitle => 'AI Security Analysis:';

  @override
  String get aiAnalyzingProgress => 'Analyzing content...';

  @override
  String get analyzingSafety => 'Analyzing safety...';

  @override
  String get copyDataMessage => 'QR Data copied';

  @override
  String get copyAnalysisMessage => 'Analysis copied';

  @override
  String get scanAgainButton => 'Scan again';

  @override
  String get resultScreenTitle => 'Scan Result';

  @override
  String get codeContentLabel => 'Code content:';

  @override
  String get copyButton => 'Copy';

  @override
  String get openButton => 'Open';

  @override
  String get historyScreenTitle => 'Scan History';

  @override
  String get historyEmpty => 'History is empty';

  @override
  String get deleteConfirmTitle => 'Clear history?';

  @override
  String get deleteConfirmContent => 'This action cannot be undone.';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get deleteButton => 'Delete';

  @override
  String get noData => 'No data';

  @override
  String get noAnalysis => 'No analysis';

  @override
  String get qrDataLabel => 'QR Data:';

  @override
  String get aiVerdictLabel => 'AI Verdict:';

  @override
  String get closeButton => 'Close';

  @override
  String get generatorTitle => 'Create QR';

  @override
  String get generatorInputLabel => 'Enter text or link';

  @override
  String get generatorPlaceholder => 'Enter data to generate';

  @override
  String get saveToGallery => 'Save to gallery';

  @override
  String get saveSuccess => 'QR code saved to gallery!';

  @override
  String get saveError => 'Error while saving';

  @override
  String get premiumFeature => 'Premium feature';

  @override
  String get readingImage => 'Reading image...';

  @override
  String get noQrFound => 'No QR code found in photo';

  @override
  String get errorReadingFile => 'Error reading file';

  @override
  String get errorNetwork => 'Network or API error. Check your internet.';

  @override
  String get errorAnalysis => 'Analysis failed. Please try again.';

  @override
  String get premiumTitle => 'Get Premium Access';

  @override
  String get premiumDescription =>
      'Scan unlimited QR codes, use AI analysis, and remove all ads.';

  @override
  String get restoreButton => 'Restore';

  @override
  String get proAccess => 'Access all pro features';

  @override
  String get termsAndPrivacy =>
      'By continuing, you agree to our Terms of Service and Privacy Policy.';

  @override
  String get loadingProducts => 'Loading products...';

  @override
  String codeDetected(String code) {
    return 'Code detected: $code';
  }

  @override
  String get premium_access => 'Premium Access';

  @override
  String get premium_description => 'Unlimited scans, AI analysis, and no ads.';

  @override
  String get no_products =>
      'No available products.\nCheck Apphud dashboard settings.';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get restore_purchases => 'Restore Purchases';

  @override
  String get aiSystemPrompt =>
      'You are a cybersecurity expert. Analyze the QR code data and respond strictly following this plan: 1. Content: [copy the raw data here]. 2. Research: [briefly explain what this link or text is for based on your knowledge]. 3. Recommendation: [state clearly if the user should proceed/open it or not and why]. Provide the answer in English.';
}
