// ignore_for_file: prefer_const_constructors, avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace
import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';

class PoyDrawer extends StatefulWidget {
  const PoyDrawer({Key? key}) : super(key: key);

  @override
  _PoyDrawerState createState() => _PoyDrawerState();
}

class _PoyDrawerState extends State<PoyDrawer> {
  var offset = Offset(20, 20);
  OverlayEntry? entry;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      ),
      child: Theme(
        data: ThemeData(
          brightness: Brightness.dark,
        ),
        child: Drawer(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    DrawerHeader(
                      child: Container(
                        child: Stack(
                          children: [
                            Lottie.asset(
                                "assets/lottie/77488-translate-language.json"),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                "Traduction App",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      title: Text("Partager l'application"),
                      onTap: () {},
                      leading: Icon(Icons.share),
                    ),
                    ListTile(
                      title: Text("Evaluez nous"),
                      onTap: () {},
                      leading: Icon(Icons.star),
                    ),
                    ListTile(
                      title: Text("Nous contacter"),
                      onTap: () {},
                      leading: Icon(Icons.mail),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                child: Text(
                  "version 1.0",
                  style: TextStyle(
                    color: Colors.white60,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
