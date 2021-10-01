// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:lottie/lottie.dart';
import 'package:voicetranslate/animation/animationWidget.dart';
import 'package:voicetranslate/constante/couleur.dart';

class Description extends StatefulWidget {
  const Description({Key? key}) : super(key: key);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  int initialPage = 0;
  TextStyle style = TextStyle(color: Colors.white);
  bool showFAB = false;

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: showFAB
          ? FloatingActionButton(
              backgroundColor: Colors.purple,
              heroTag: "FAB",
              onPressed: () {
                setState(() {
                  prefs.then((_prefs) {
                    _prefs.setBool("isFirst", false);
                  });
                });
                Navigator.pushReplacementNamed(context, "/corps");
              },
              child: Icon(Icons.arrow_forward_rounded),
            )
          : null,
      body: Stack(
        children: [
          Container(
            child: CarouselSlider(
              items: [
                Container(
                  width: double.infinity,
                  color: mycolor4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimationWidget(
                        second: 1,
                        depart: Depart.top,
                        child: Text(
                          "Bienvenue ",
                          textAlign: TextAlign.center,
                          style: style.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Container(
                        child: Lottie.asset(
                          "assets/lottie/9656-onboarding-page-1.json",
                          height: 300,
                        ),
                      ),
                      Text(
                        "La langue n'est plus une barrière maintenant !",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: mycolor2,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimationWidget(
                        depart: Depart.top,
                        second: 1,
                        child: Text(
                          "Choissisez votre langue puis parlez...",
                          textAlign: TextAlign.center,
                          style: style.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Container(
                        child: Lottie.asset(
                            "assets/lottie/65263-mic-animation.json"),
                        height: 200,
                      ),
                      Text(
                        "Vous pouvez aussi saisir votre phrase au clavier",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: mycolor1,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimationWidget(
                        second: 1,
                        depart: Depart.top,
                        child: Text(
                          "Avec l'intelligence artificiel , vous avez la possibilité de traduire le text sur les photos",
                          textAlign: TextAlign.center,
                          style: style.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Container(
                        height: 230,
                        child: Lottie.asset(
                          "assets/lottie/67532-artificial-intelligence-robot.json",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              options: CarouselOptions(
                  initialPage: initialPage,
                  viewportFraction: 1,
                  height: size.height,
                  onPageChanged: (int page, reason) {
                    setState(() {
                      initialPage = page;
                      if (initialPage != 2) {
                        setState(() {
                          showFAB = false;
                        });
                      } else {
                        setState(() {
                          showFAB = true;
                        });
                      }
                    });
                  }),
            ),
          ),
          Positioned(
            bottom: 30,
            left: (size.width / 2) - 20,
            child: Container(
              child: LayoutBuilder(builder: (context, c) {
                return Row(
                  children: [
                    Container(
                      width: initialPage == 0 ? 25 : 10,
                      height: 8,
                      decoration: BoxDecoration(
                        color: initialPage == 0 ? Colors.purple : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(width: 6),
                    Container(
                      width: initialPage == 1 ? 25 : 10,
                      height: 8,
                      decoration: BoxDecoration(
                        color: initialPage == 1 ? Colors.purple : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(width: 6),
                    Container(
                      width: initialPage == 2 ? 25 : 10,
                      height: 8,
                      decoration: BoxDecoration(
                        color: initialPage == 2 ? Colors.purple : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  mycontainer(int page) {}
}
