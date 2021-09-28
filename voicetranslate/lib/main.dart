// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import "package:splash_screen_view/SplashScreenView.dart";
import 'package:voicetranslate/corps.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHome(),
      debugShowCheckedModeBanner: false,
      title: "voiceTranslator",
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: Corps(),
      backgroundColor: Colors.white,
    );
  }
}
