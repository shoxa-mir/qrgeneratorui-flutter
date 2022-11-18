import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
    return FutureBuilder(
        future: init_admob(),
        builder: (context, snapshot) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomePage(),
          );
        });
  }

  Future<InitializationStatus> init_admob() {
    return MobileAds.instance.initialize();
  }
}
