// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import "package:flutter/material.dart";
import "package:splash_screen_view/SplashScreenView.dart";
import 'package:voicetranslate/corps.dart';
import "package:shared_preferences/shared_preferences.dart";
import 'package:voicetranslate/description.dart';
import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";

FirebaseMessaging firebaseMessage = FirebaseMessaging.instance;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("onbackgroundMessage : ");
  print(message.notification!.body);
}

void _bootStrapFirebase() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("onMessage : ");
    print(message.notification!.body);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  _bootStrapFirebase();
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
  bool? isFirst;

  @override
  void initState() {
    firebaseMessage.requestPermission();
    pref.then((SharedPreferences _prefs) {
      setState(() {
        isFirst = _prefs.getBool("isFirst") ?? true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isFirst == null)
      return Container(
        color: Colors.white,
      );
    return SplashScreenView(
      navigateRoute: isFirst! ? Description() : Corps(),
      backgroundColor: Colors.white,
      imageSrc: "assets/Lt.png",
      text: "TraductorApp",
      textType: TextType.ScaleAnimatedText,
      textStyle: TextStyle(
        color: Colors.purple,
        fontWeight: FontWeight.bold,
        fontSize: 21,
      ),
      imageSize: 260,
    );
  }
}
