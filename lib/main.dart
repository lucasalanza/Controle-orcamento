import 'package:controleOrcamentos/models/temaModel.dart';
import 'package:controleOrcamentos/screens/homeScreen.dart';
import 'package:controleOrcamentos/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: TemaModel.singleton,
      builder: (context, child) {
        return MaterialApp(
          title: 'Orçamentos Pessoal',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
                brightness: TemaModel.singleton.modoEscuro == true
                    ? Brightness.dark
                    : Brightness.light),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
