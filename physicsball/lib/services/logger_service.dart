import 'dart:developer' as dev;

class LoggerService {
  // Логирование обычных действий пользователя
  static void logAction(String message) {
    dev.log(' [ACTION] $message', name: 'APP_LOG');
  }

  // Логирование ошибок (со стеком вызовов для отладки)
  static void logError(String message, [dynamic error, StackTrace? stack]) {
    dev.log(
      ' [ERROR] $message', 
      error: error, 
      stackTrace: stack, 
      name: 'APP_LOG'
    );
  }

  // Логирование изменений состояния системы
  static void logInfo(String message) {
    dev.log(' [INFO] $message', name: 'APP_LOG');
  }
}