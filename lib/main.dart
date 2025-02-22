import 'package:flutter/material.dart';
import 'package:todo/pages/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/pages/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Убедитесь, что инициализация завершена
  await Firebase.initializeApp(); // Инициализируйте Firebase
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.deepOrangeAccent,
    ),
    initialRoute: '/',
    routes: {
      '/': (context) => MainScreen(),
      '/todo': (context) => Home(),
    },
  ));
}