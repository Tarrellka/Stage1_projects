import 'package:flutter/material.dart';
import 'screens/menu_screen.dart';

void main() => runApp(ZooLogicaApp());

class ZooLogicaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ЗооЛогика',
      theme: ThemeData(primarySwatch: Colors.green),
      debugShowCheckedModeBanner: false,
      home: MenuScreen(),
    );
  }
}