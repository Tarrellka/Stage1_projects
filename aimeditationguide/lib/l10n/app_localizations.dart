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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get hello;

  /// No description provided for @howAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'How are you\nfeeling today?'**
  String get howAreYouFeeling;

  /// No description provided for @generateMeditation.
  ///
  /// In en, this message translates to:
  /// **'Generate Meditation'**
  String get generateMeditation;

  /// No description provided for @breathingExercise.
  ///
  /// In en, this message translates to:
  /// **'Breathing Exercise'**
  String get breathingExercise;

  /// No description provided for @dailyRoutine.
  ///
  /// In en, this message translates to:
  /// **'DAILY ROUTINE'**
  String get dailyRoutine;

  /// No description provided for @recommendedSessions.
  ///
  /// In en, this message translates to:
  /// **'Recommended Sessions'**
  String get recommendedSessions;

  /// No description provided for @continueLastSession.
  ///
  /// In en, this message translates to:
  /// **'Continue Last Session'**
  String get continueLastSession;

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Continue with {duration} session'**
  String continueWith(Object duration);

  /// No description provided for @backgroundSounds.
  ///
  /// In en, this message translates to:
  /// **'BACKGROUND SOUNDS'**
  String get backgroundSounds;

  /// No description provided for @backgroundVolume.
  ///
  /// In en, this message translates to:
  /// **'Background Volume'**
  String get backgroundVolume;

  /// No description provided for @prepare.
  ///
  /// In en, this message translates to:
  /// **'Prepare'**
  String get prepare;

  /// No description provided for @inhale.
  ///
  /// In en, this message translates to:
  /// **'Inhale'**
  String get inhale;

  /// No description provided for @hold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get hold;

  /// No description provided for @exhale.
  ///
  /// In en, this message translates to:
  /// **'Exhale'**
  String get exhale;

  /// No description provided for @dailyRoutineTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Daily Routine'**
  String get dailyRoutineTitle;

  /// No description provided for @generateRoutineBtn.
  ///
  /// In en, this message translates to:
  /// **'GENERATE NEW ROUTINE'**
  String get generateRoutineBtn;

  /// No description provided for @exerciseDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get exerciseDone;

  /// No description provided for @exerciseLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get exerciseLocked;

  /// No description provided for @startExercise.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startExercise;

  /// No description provided for @allDoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Excellent work!'**
  String get allDoneTitle;

  /// No description provided for @allDoneSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You have completed your daily plan.'**
  String get allDoneSubtitle;

  /// No description provided for @addedToHistory.
  ///
  /// In en, this message translates to:
  /// **'Added to history'**
  String get addedToHistory;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @loadingMeditation.
  ///
  /// In en, this message translates to:
  /// **'Creating your session...'**
  String get loadingMeditation;

  /// No description provided for @goal_relax.
  ///
  /// In en, this message translates to:
  /// **'Relaxation'**
  String get goal_relax;

  /// No description provided for @goal_focus.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get goal_focus;

  /// No description provided for @goal_sleep.
  ///
  /// In en, this message translates to:
  /// **'Deep Sleep'**
  String get goal_sleep;

  /// No description provided for @voice_male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get voice_male;

  /// No description provided for @voice_female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get voice_female;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No meditations yet'**
  String get historyEmpty;

  /// No description provided for @historyEmptySub.
  ///
  /// In en, this message translates to:
  /// **'Your completed sessions will appear here'**
  String get historyEmptySub;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this record?'**
  String get deleteConfirm;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @sound_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get sound_none;

  /// No description provided for @sound_nature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get sound_nature;

  /// No description provided for @sound_ambient.
  ///
  /// In en, this message translates to:
  /// **'Ambient music'**
  String get sound_ambient;

  /// No description provided for @sound_rain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get sound_rain;

  /// No description provided for @calm_breath.
  ///
  /// In en, this message translates to:
  /// **'CALM BREATH'**
  String get calm_breath;

  /// No description provided for @focus_breath.
  ///
  /// In en, this message translates to:
  /// **'FOCUS BREATH'**
  String get focus_breath;

  /// No description provided for @relax_breath.
  ///
  /// In en, this message translates to:
  /// **'RELAX BREATH'**
  String get relax_breath;

  /// No description provided for @calm_meditation.
  ///
  /// In en, this message translates to:
  /// **'CALM MEDITATION'**
  String get calm_meditation;

  /// No description provided for @focus_meditation.
  ///
  /// In en, this message translates to:
  /// **'FOCUS MEDITATION'**
  String get focus_meditation;

  /// No description provided for @relax_meditation.
  ///
  /// In en, this message translates to:
  /// **'RELAX MEDITATION'**
  String get relax_meditation;

  /// No description provided for @unit_min.
  ///
  /// In en, this message translates to:
  /// **'MIN'**
  String get unit_min;

  /// No description provided for @breathingAction.
  ///
  /// In en, this message translates to:
  /// **'Breathing...'**
  String get breathingAction;

  /// No description provided for @moodCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Mood Check-in'**
  String get moodCheckIn;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @startSession.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get startSession;

  /// No description provided for @howAreYouFeelingShort.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get howAreYouFeelingShort;

  /// No description provided for @congrats.
  ///
  /// In en, this message translates to:
  /// **'CONGRATS'**
  String get congrats;

  /// No description provided for @routine.
  ///
  /// In en, this message translates to:
  /// **'ROUTINE'**
  String get routine;

  /// No description provided for @routineWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Your plan for today is ready. Press START SESSION to begin the practices.'**
  String get routineWelcomeMessage;

  /// No description provided for @morningPractice.
  ///
  /// In en, this message translates to:
  /// **'Morning Practice'**
  String get morningPractice;

  /// No description provided for @afternoonPractice.
  ///
  /// In en, this message translates to:
  /// **'Afternoon Practice'**
  String get afternoonPractice;

  /// No description provided for @eveningPractice.
  ///
  /// In en, this message translates to:
  /// **'Evening Practice'**
  String get eveningPractice;

  /// No description provided for @allCompleted.
  ///
  /// In en, this message translates to:
  /// **'ALL COMPLETED'**
  String get allCompleted;

  /// No description provided for @startNext.
  ///
  /// In en, this message translates to:
  /// **'START NEXT'**
  String get startNext;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'CLOSE'**
  String get close;

  /// No description provided for @generatorFillDetails.
  ///
  /// In en, this message translates to:
  /// **'Fill in the details below to\ngenerate a meditation'**
  String get generatorFillDetails;

  /// No description provided for @meditationGoal.
  ///
  /// In en, this message translates to:
  /// **'Meditation Goal'**
  String get meditationGoal;

  /// No description provided for @goalStress.
  ///
  /// In en, this message translates to:
  /// **'Reduce stress'**
  String get goalStress;

  /// No description provided for @goalSleep.
  ///
  /// In en, this message translates to:
  /// **'Improve sleep'**
  String get goalSleep;

  /// No description provided for @goalFocus.
  ///
  /// In en, this message translates to:
  /// **'Increase focus'**
  String get goalFocus;

  /// No description provided for @goalEnergy.
  ///
  /// In en, this message translates to:
  /// **'Boost energy'**
  String get goalEnergy;

  /// No description provided for @goalAnxiety.
  ///
  /// In en, this message translates to:
  /// **'Calm anxiety'**
  String get goalAnxiety;

  /// No description provided for @voiceStyle.
  ///
  /// In en, this message translates to:
  /// **'Voice Style'**
  String get voiceStyle;

  /// No description provided for @voiceSoft.
  ///
  /// In en, this message translates to:
  /// **'Soft'**
  String get voiceSoft;

  /// No description provided for @voiceNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get voiceNeutral;

  /// No description provided for @voiceDeep.
  ///
  /// In en, this message translates to:
  /// **'Deep'**
  String get voiceDeep;

  /// No description provided for @backgroundSound.
  ///
  /// In en, this message translates to:
  /// **'Background Sound'**
  String get backgroundSound;

  /// No description provided for @soundNature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get soundNature;

  /// No description provided for @soundAmbient.
  ///
  /// In en, this message translates to:
  /// **'Ambient music'**
  String get soundAmbient;

  /// No description provided for @soundRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get soundRain;

  /// No description provided for @soundNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get soundNone;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @generating.
  ///
  /// In en, this message translates to:
  /// **'Generating...'**
  String get generating;

  /// No description provided for @aiPreparing.
  ///
  /// In en, this message translates to:
  /// **'AI is preparing your session'**
  String get aiPreparing;

  /// No description provided for @personalizedReady.
  ///
  /// In en, this message translates to:
  /// **'Your personalized meditation is ready'**
  String get personalizedReady;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @meditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get meditation;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @meditations.
  ///
  /// In en, this message translates to:
  /// **'Meditations'**
  String get meditations;

  /// No description provided for @breathing.
  ///
  /// In en, this message translates to:
  /// **'Breathing'**
  String get breathing;

  /// No description provided for @meditationHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Meditation history is empty'**
  String get meditationHistoryEmpty;

  /// No description provided for @breathingHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Breathing history is empty'**
  String get breathingHistoryEmpty;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Relax & Focus'**
  String get onboardingTitle1;

  /// No description provided for @onboardingSubtitle1.
  ///
  /// In en, this message translates to:
  /// **'with AI\nMeditation'**
  String get onboardingSubtitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'AI Creates'**
  String get onboardingTitle2;

  /// No description provided for @onboardingSubtitle2.
  ///
  /// In en, this message translates to:
  /// **'Sessions for\nYour Mood'**
  String get onboardingSubtitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Listen & Follow'**
  String get onboardingTitle3;

  /// No description provided for @onboardingSubtitle3.
  ///
  /// In en, this message translates to:
  /// **'AI Guidance'**
  String get onboardingSubtitle3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Track Your'**
  String get onboardingTitle4;

  /// No description provided for @onboardingSubtitle4.
  ///
  /// In en, this message translates to:
  /// **'Mindfulness &\nProgress'**
  String get onboardingSubtitle4;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @startNow.
  ///
  /// In en, this message translates to:
  /// **'Start Now'**
  String get startNow;

  /// No description provided for @backgroundSoundsLabel.
  ///
  /// In en, this message translates to:
  /// **'Background sounds'**
  String get backgroundSoundsLabel;

  /// No description provided for @backgroundSoundsHeader.
  ///
  /// In en, this message translates to:
  /// **'Background Sounds'**
  String get backgroundSoundsHeader;

  /// No description provided for @backgroundVolumeTitle.
  ///
  /// In en, this message translates to:
  /// **'Background Volume'**
  String get backgroundVolumeTitle;

  /// No description provided for @sessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Your {goal} Session'**
  String sessionTitle(String goal);

  /// No description provided for @sessionDescription.
  ///
  /// In en, this message translates to:
  /// **'Custom {voice} voice meditation with {sound} atmosphere.'**
  String sessionDescription(String voice, String sound);

  /// No description provided for @breathingLabel.
  ///
  /// In en, this message translates to:
  /// **'Breathing'**
  String get breathingLabel;

  /// No description provided for @squareBreathing.
  ///
  /// In en, this message translates to:
  /// **'Square Breathing'**
  String get squareBreathing;

  /// No description provided for @deepRelax.
  ///
  /// In en, this message translates to:
  /// **'Deep Relax'**
  String get deepRelax;

  /// No description provided for @minutesDuration.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutesDuration(String count);

  /// No description provided for @boxBreathing.
  ///
  /// In en, this message translates to:
  /// **'Box Breathing'**
  String get boxBreathing;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
