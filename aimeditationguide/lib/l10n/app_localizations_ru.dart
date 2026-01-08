// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get hello => 'Привет,';

  @override
  String get howAreYouFeeling => 'Как ты себя\nчувствуешь сегодня?';

  @override
  String get generateMeditation => 'Создать медитацию';

  @override
  String get breathingExercise => 'Дыхательная практика';

  @override
  String get dailyRoutine => 'ДНЕВНОЙ ПЛАН';

  @override
  String get recommendedSessions => 'Рекомендуемые сессии';

  @override
  String get continueLastSession => 'Продолжить прошлую сессию';

  @override
  String continueWith(Object duration) {
    return 'Продолжить сессию $duration';
  }

  @override
  String get backgroundSounds => 'ФОНОВЫЕ ЗВУКИ';

  @override
  String get backgroundVolume => 'Громкость фона';

  @override
  String get prepare => 'Приготовьтесь';

  @override
  String get inhale => 'Вдох';

  @override
  String get hold => 'Задержка';

  @override
  String get exhale => 'Выдох';

  @override
  String get dailyRoutineTitle => 'Твоя рутина на сегодня';

  @override
  String get generateRoutineBtn => 'СОЗДАТЬ НОВЫЙ ПЛАН';

  @override
  String get exerciseDone => 'Готово';

  @override
  String get exerciseLocked => 'Закрыто';

  @override
  String get startExercise => 'Начать';

  @override
  String get allDoneTitle => 'Отличная работа!';

  @override
  String get allDoneSubtitle => 'Ты выполнил весь план на сегодня.';

  @override
  String get addedToHistory => 'Добавлено в историю';

  @override
  String get error => 'Ошибка';

  @override
  String get loadingMeditation => 'Создаем вашу сессию...';

  @override
  String get goal_relax => 'Расслабление';

  @override
  String get goal_focus => 'Концентрация';

  @override
  String get goal_sleep => 'Глубокий сон';

  @override
  String get voice_male => 'Мужской';

  @override
  String get voice_female => 'Женский';

  @override
  String get historyTitle => 'История';

  @override
  String get historyEmpty => 'Истории пока нет';

  @override
  String get historyEmptySub => 'Здесь появятся ваши завершенные сессии';

  @override
  String get deleteConfirm => 'Удалить эту запись?';

  @override
  String get clearAll => 'Очистить всё';

  @override
  String get cancel => 'Отмена';

  @override
  String get delete => 'Удалить';

  @override
  String get sound_none => 'Нет';

  @override
  String get sound_nature => 'Природа';

  @override
  String get sound_ambient => 'Эмбиент';

  @override
  String get sound_rain => 'Дождь';

  @override
  String get calm_breath => 'СПОКОЙНОЕ ДЫХАНИЕ';

  @override
  String get focus_breath => 'ДЫХАНИЕ ФОКУС';

  @override
  String get relax_breath => 'РАССЛАБЛЯЮЩЕЕ ДЫХАНИЕ';

  @override
  String get calm_meditation => 'МЕДИТАЦИЯ ПОКОЯ';

  @override
  String get focus_meditation => 'МЕДИТАЦИЯ ФОКУС';

  @override
  String get relax_meditation => 'РЕЛАКС МЕДИТАЦИЯ';

  @override
  String get unit_min => 'МИН';

  @override
  String get breathingAction => 'Дышим...';

  @override
  String get moodCheckIn => 'Как вы сейчас?';

  @override
  String get duration => 'Длительность';

  @override
  String get startSession => 'Начать практику';

  @override
  String get howAreYouFeelingShort => 'Как вы себя чувствуете?';

  @override
  String get congrats => 'ОТЛИЧНО!';

  @override
  String get routine => 'ПЛАН';

  @override
  String get routineWelcomeMessage => 'Ваш план на сегодня готов. Нажмите НАЧАТЬ, чтобы приступить к выполнению практик.';

  @override
  String get morningPractice => 'Утренняя практика';

  @override
  String get afternoonPractice => 'Дневная практика';

  @override
  String get eveningPractice => 'Вечерняя практика';

  @override
  String get allCompleted => 'ВСЁ ВЫПОЛНЕНО';

  @override
  String get startNext => 'СЛЕДУЮЩАЯ';

  @override
  String get close => 'ЗАКРЫТЬ';

  @override
  String get generatorFillDetails => 'Укажите детали ниже,\nчтобы создать медитацию';

  @override
  String get meditationGoal => 'Цель медитации';

  @override
  String get goalStress => 'Снять стресс';

  @override
  String get goalSleep => 'Улучшить сон';

  @override
  String get goalFocus => 'Концентрация';

  @override
  String get goalEnergy => 'Заряд энергии';

  @override
  String get goalAnxiety => 'Снять тревогу';

  @override
  String get voiceStyle => 'Стиль голоса';

  @override
  String get voiceSoft => 'Мягкий';

  @override
  String get voiceNeutral => 'Нейтральный';

  @override
  String get voiceDeep => 'Глубокий';

  @override
  String get backgroundSound => 'Фоновый звук';

  @override
  String get soundNature => 'Природа';

  @override
  String get soundAmbient => 'Амбиент';

  @override
  String get soundRain => 'Дождь';

  @override
  String get soundNone => 'Без звука';

  @override
  String get generate => 'Создать';

  @override
  String get generating => 'Создание...';

  @override
  String get aiPreparing => 'ИИ готовит вашу сессию';

  @override
  String get personalizedReady => 'Ваша персональная медитация готова';

  @override
  String get ready => 'Готово';

  @override
  String get start => 'Начать';

  @override
  String get meditation => 'Медитация';

  @override
  String get history => 'История';

  @override
  String get meditations => 'Медитации';

  @override
  String get breathing => 'Дыхание';

  @override
  String get meditationHistoryEmpty => 'История медитаций пуста';

  @override
  String get breathingHistoryEmpty => 'История дыхания пуста';

  @override
  String get completed => 'Завершено';

  @override
  String get home => 'Главная';

  @override
  String get onboardingTitle1 => 'Расслабься и фокуссируйся';

  @override
  String get onboardingSubtitle1 => 'с ИИ\nМедитацией';

  @override
  String get onboardingTitle2 => 'ИИ создает';

  @override
  String get onboardingSubtitle2 => 'сессии под\nтвое настроение';

  @override
  String get onboardingTitle3 => 'Слушай и следуй';

  @override
  String get onboardingSubtitle3 => 'советам ИИ';

  @override
  String get onboardingTitle4 => 'Отслеживай';

  @override
  String get onboardingSubtitle4 => 'осознанность и\nпрогресс';

  @override
  String get next => 'Далее';

  @override
  String get startNow => 'Начать сейчас';

  @override
  String get backgroundSoundsLabel => 'Фоновые звуки';

  @override
  String get backgroundSoundsHeader => 'Фоновые звуки';

  @override
  String get backgroundVolumeTitle => 'Громкость фона';

  @override
  String sessionTitle(String goal) {
    return 'Сессия: $goal';
  }

  @override
  String sessionDescription(String voice, String sound) {
    return 'Медитация ($voice) с атмосферой $sound.';
  }

  @override
  String get breathingLabel => 'Дыхание';

  @override
  String get squareBreathing => 'Квадратное дыхание';

  @override
  String get deepRelax => 'Глубокий релакс';

  @override
  String minutesDuration(String count) {
    return '$count мин';
  }

  @override
  String get boxBreathing => 'Коробочное дыхание';
}
