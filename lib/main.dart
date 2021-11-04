import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ml/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const EasyMLApp());
}

class EasyMLApp extends StatelessWidget {
  const EasyMLApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const locale = Locale("ja", "JP");
    return MaterialApp(
      debugShowCheckedModeBanner: false, // デバッグ用の帯を消す
      // 日本語用設定
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData.dark(),
      supportedLocales: const [
        locale,
      ],
      title: 'Easy ML',
      home: HomePage(),
    );
  }
}
