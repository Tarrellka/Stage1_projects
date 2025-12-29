// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'AI QR Сканер';

  @override
  String get scannerTab => 'Сканер';

  @override
  String get generatorTab => 'Создать';

  @override
  String get historyTab => 'История';

  @override
  String get scannerTitle => 'Сканировать QR-код';

  @override
  String get scanInstruction => 'Наведите камеру на QR-код';

  @override
  String get scanStatusInitial => 'Наведите камеру на QR-код';

  @override
  String get aiAnalysisTitle => 'AI Анализ';

  @override
  String get aiSecurityAnalysisTitle => 'AI Анализ безопасности:';

  @override
  String get aiAnalyzingProgress => 'Анализируем содержимое...';

  @override
  String get analyzingSafety => 'Анализирую безопасность...';

  @override
  String get copyDataMessage => 'Данные QR скопированы';

  @override
  String get copyAnalysisMessage => 'Анализ скопирован';

  @override
  String get scanAgainButton => 'Сканировать еще';

  @override
  String get resultScreenTitle => 'Результат сканирования';

  @override
  String get codeContentLabel => 'Содержимое кода:';

  @override
  String get copyButton => 'Копировать';

  @override
  String get openButton => 'Открыть';

  @override
  String get historyScreenTitle => 'История сканирований';

  @override
  String get historyEmpty => 'История пуста';

  @override
  String get deleteConfirmTitle => 'Очистить историю?';

  @override
  String get deleteConfirmContent => 'Это действие нельзя будет отменить.';

  @override
  String get cancelButton => 'Отмена';

  @override
  String get deleteButton => 'Удалить';

  @override
  String get noData => 'Нет данных';

  @override
  String get noAnalysis => 'Анализ отсутствует';

  @override
  String get qrDataLabel => 'Данные QR:';

  @override
  String get aiVerdictLabel => 'Вердикт ИИ:';

  @override
  String get closeButton => 'Закрыть';

  @override
  String get generatorTitle => 'Создать QR';

  @override
  String get generatorInputLabel => 'Введите текст или ссылку';

  @override
  String get generatorPlaceholder => 'Введите данные для генерации';

  @override
  String get saveToGallery => 'Сохранить в галерею';

  @override
  String get saveSuccess => 'QR-код сохранен в галерею!';

  @override
  String get saveError => 'Ошибка при сохранении';

  @override
  String get premiumFeature => 'Премиум функция';

  @override
  String get readingImage => 'Читаю изображение...';

  @override
  String get noQrFound => 'QR-код не найден на фото';

  @override
  String get errorReadingFile => 'Ошибка при чтении файла';

  @override
  String get errorNetwork => 'Ошибка сети или API. Проверьте интернет.';

  @override
  String get errorAnalysis => 'Ошибка анализа. Попробуйте еще раз.';

  @override
  String get premiumTitle => 'Получите Premium доступ';

  @override
  String get premiumDescription =>
      'Безлимитное сканирование, AI анализ и никакой рекламы.';

  @override
  String get restoreButton => 'Восстановить';

  @override
  String get proAccess => 'Доступ ко всем PRO функциям';

  @override
  String get termsAndPrivacy =>
      'Продолжая, вы соглашаетесь с условиями использования и политикой конфиденциальности.';

  @override
  String get loadingProducts => 'Загрузка продуктов...';

  @override
  String codeDetected(String code) {
    return 'Код обнаружен: $code';
  }

  @override
  String get premium_access => 'Premium Access';

  @override
  String get premium_description =>
      'Безлимитные сканы, ИИ-анализ и отсутствие рекламы.';

  @override
  String get no_products =>
      'Нет доступных продуктов.\nПроверьте настройки в панели Apphud.';

  @override
  String get upgrade => 'Улучшить';

  @override
  String get restore_purchases => 'Восстановить покупки';

  @override
  String get aiSystemPrompt =>
      'Ты эксперт по кибербезопасности. Проанализируй данные QR-кода и ответь строго по плану: 1. Содержимое: [просто скопируй текст из QR]. 2. Исследование: [кратко опиши, куда ведет эта ссылка или для чего нужен этот текст]. 3. Рекомендация: [напиши, стоит ли переходить/открывать это и почему]. Ответ давай на русском языке.';
}
