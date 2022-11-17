import 'package:flutter/material.dart';
import 'package:qrgeneratorui/HomePage.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const QrGeneratorApp());
}

class QrGeneratorApp extends StatelessWidget {
  const QrGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
