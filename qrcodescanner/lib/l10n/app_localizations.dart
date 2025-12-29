import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'AI QR Scanner'**
  String get appTitle;

  /// No description provided for @scannerTab.
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get scannerTab;

  /// No description provided for @generatorTab.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get generatorTab;

  /// No description provided for @historyTab.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTab;

  /// No description provided for @scannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scannerTitle;

  /// No description provided for @scanInstruction.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at a QR code'**
  String get scanInstruction;

  /// No description provided for @scanStatusInitial.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at a QR code'**
  String get scanStatusInitial;

  /// No description provided for @aiAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis'**
  String get aiAnalysisTitle;

  /// No description provided for @aiSecurityAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Security Analysis:'**
  String get aiSecurityAnalysisTitle;

  /// No description provided for @aiAnalyzingProgress.
  ///
  /// In en, this message translates to:
  /// **'Analyzing content...'**
  String get aiAnalyzingProgress;

  /// No description provided for @analyzingSafety.
  ///
  /// In en, this message translates to:
  /// **'Analyzing safety...'**
  String get analyzingSafety;

  /// No description provided for @copyDataMessage.
  ///
  /// In en, this message translates to:
  /// **'QR Data copied'**
  String get copyDataMessage;

  /// No description provided for @copyAnalysisMessage.
  ///
  /// In en, this message translates to:
  /// **'Analysis copied'**
  String get copyAnalysisMessage;

  /// No description provided for @scanAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Scan again'**
  String get scanAgainButton;

  /// No description provided for @resultScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get resultScreenTitle;

  /// No description provided for @codeContentLabel.
  ///
  /// In en, this message translates to:
  /// **'Code content:'**
  String get codeContentLabel;

  /// No description provided for @copyButton.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyButton;

  /// No description provided for @openButton.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openButton;

  /// No description provided for @historyScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan History'**
  String get historyScreenTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'History is empty'**
  String get historyEmpty;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear history?'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteConfirmContent;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @noAnalysis.
  ///
  /// In en, this message translates to:
  /// **'No analysis'**
  String get noAnalysis;

  /// No description provided for @qrDataLabel.
  ///
  /// In en, this message translates to:
  /// **'QR Data:'**
  String get qrDataLabel;

  /// No description provided for @aiVerdictLabel.
  ///
  /// In en, this message translates to:
  /// **'AI Verdict:'**
  String get aiVerdictLabel;

  /// No description provided for @closeButton.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeButton;

  /// No description provided for @generatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Create QR'**
  String get generatorTitle;

  /// No description provided for @generatorInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter text or link'**
  String get generatorInputLabel;

  /// No description provided for @generatorPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter data to generate'**
  String get generatorPlaceholder;

  /// No description provided for @saveToGallery.
  ///
  /// In en, this message translates to:
  /// **'Save to gallery'**
  String get saveToGallery;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'QR code saved to gallery!'**
  String get saveSuccess;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Error while saving'**
  String get saveError;

  /// No description provided for @premiumFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium feature'**
  String get premiumFeature;

  /// No description provided for @readingImage.
  ///
  /// In en, this message translates to:
  /// **'Reading image...'**
  String get readingImage;

  /// No description provided for @noQrFound.
  ///
  /// In en, this message translates to:
  /// **'No QR code found in photo'**
  String get noQrFound;

  /// No description provided for @errorReadingFile.
  ///
  /// In en, this message translates to:
  /// **'Error reading file'**
  String get errorReadingFile;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network or API error. Check your internet.'**
  String get errorNetwork;

  /// No description provided for @errorAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis failed. Please try again.'**
  String get errorAnalysis;

  /// No description provided for @premiumTitle.
  ///
  /// In en, this message translates to:
  /// **'Get Premium Access'**
  String get premiumTitle;

  /// No description provided for @premiumDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan unlimited QR codes, use AI analysis, and remove all ads.'**
  String get premiumDescription;

  /// No description provided for @restoreButton.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreButton;

  /// No description provided for @proAccess.
  ///
  /// In en, this message translates to:
  /// **'Access all pro features'**
  String get proAccess;

  /// No description provided for @termsAndPrivacy.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to our Terms of Service and Privacy Policy.'**
  String get termsAndPrivacy;

  /// No description provided for @loadingProducts.
  ///
  /// In en, this message translates to:
  /// **'Loading products...'**
  String get loadingProducts;

  /// Text showing the scanned QR content
  ///
  /// In en, this message translates to:
  /// **'Code detected: {code}'**
  String codeDetected(String code);

  /// No description provided for @premium_access.
  ///
  /// In en, this message translates to:
  /// **'Premium Access'**
  String get premium_access;

  /// No description provided for @premium_description.
  ///
  /// In en, this message translates to:
  /// **'Unlimited scans, AI analysis, and no ads.'**
  String get premium_description;

  /// No description provided for @no_products.
  ///
  /// In en, this message translates to:
  /// **'No available products.\nCheck Apphud dashboard settings.'**
  String get no_products;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @restore_purchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restore_purchases;

  /// No description provided for @aiSystemPrompt.
  ///
  /// In en, this message translates to:
  /// **'You are a cybersecurity expert. Analyze the QR code data and respond strictly following this plan: 1. Content: [copy the raw data here]. 2. Research: [briefly explain what this link or text is for based on your knowledge]. 3. Recommendation: [state clearly if the user should proceed/open it or not and why]. Provide the answer in English.'**
  String get aiSystemPrompt;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
