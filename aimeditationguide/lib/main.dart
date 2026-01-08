import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart'; // Добавлено
import '/l10n/app_localizations.dart'; 
import 'screens/splash_screen.dart';
import 'screens/paywall_screen.dart'; 
import 'controller/daily_routine_controller.dart';
import 'controller/history_controller.dart';

void main() { 
  WidgetsFlutterBinding.ensureInitialized();
  
  // await Firebase.initializeApp();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DailyRoutineController()),
        ChangeNotifierProvider(create: (_) => HistoryController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate, 
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
      home: const SplashScreen(), 
    );
  }
}