import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logic/theme_provider.dart';
import 'logic/notification_service.dart';
import 'logic/timer_controller.dart';
import 'models/task_models.dart'; 
import 'screens/main_holder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await NotificationService.init();
  } catch (e) {
    debugPrint("Notification Error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TimerController()),
        ChangeNotifierProvider(create: (_) => TaskModels()), 
      ],
      child: const WorkUtilityApp(),
    ),
  );
}

class WorkUtilityApp extends StatelessWidget {
  const WorkUtilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Теперь любой экран внутри MaterialApp будет иметь доступ к TaskModels
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Work Utility',
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: const Color(0xFF3366FF),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF3366FF),
      ),
      home: const MainHolder(),
    );
  }
}