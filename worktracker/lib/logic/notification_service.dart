import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(settings);

    // ВАЖНО: Создаем канал для Android (обязательно для Android 8.0+)
    if (Platform.isAndroid) {
      final androidImplementation = _notifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      
      // Запрашиваем разрешение (появится окно "Разрешить уведомления?")
      await androidImplementation?.requestNotificationsPermission();

      const channel = AndroidNotificationChannel(
        'timer_channel', // ID должен совпадать с тем, что в методе show
        'Timer Notifications',
        description: 'Уведомления о завершении таймера фокуса',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      await androidImplementation?.createNotificationChannel(channel);
    }
  }

  static Future<void> showNotification({required String title, required String body}) async {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    await _notifications.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'timer_channel', // Тот же ID, что мы создали выше
          'Timer Notifications',
          importance: Importance.max,
          priority: Priority.high,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm, // Помечаем как важный сигнал
        ),
        iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
      ),
    );
  }
}