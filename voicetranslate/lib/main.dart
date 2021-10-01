// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import "package:splash_screen_view/SplashScreenView.dart";
import 'package:voicetranslate/corps.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:voicetranslate/description.dart';
import "package:firebase_core/firebase_core.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      routes: {
        "/corps": (context) => Corps(),
      },
    );
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Future<SharedPreferences> pref = SharedPreferences.getInstance();
  bool isFirst = false;

  @override
  void initState() {
    pref.then((SharedPreferences _prefs) {
      setState(() {
        isFirst = _prefs.getBool("isFirst") ?? true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: isFirst ? Description() : Corps(),
      backgroundColor: Colors.white,
      imageSrc: "assets/undraw_conversation_h12g.png",
      imageSize: 260,
    );
  }
}
