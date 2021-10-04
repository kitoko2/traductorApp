// ignore_for_file: prefer_const_constructors, avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:voicetranslate/constante/contacter.dart';

class PoyDrawer extends StatefulWidget {
  const PoyDrawer({Key? key}) : super(key: key);

  @override
  _PoyDrawerState createState() => _PoyDrawerState();
}

class _PoyDrawerState extends State<PoyDrawer> {
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
                      onTap: () {
                        partagerApplication();
                      },
                      leading: Icon(Icons.share),
                    ),
                    ListTile(
                      title: Text("Evaluez nous"),
                      onTap: evaluationPopUp,
                      leading: Icon(Icons.star),
                    ),
                    ListTile(
                      title: Text("Nous contacter"),
                      onTap: () {
                        contactPopUp();
                      },
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

  // mes fonctions

  partagerApplication() async {
    await Share.share(
      "lien github du projet",
    );
  }

  evaluationPopUp() {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Pas disponible"),
            content: Text(
                "vous pourrez evaluer l'application une fois sur le store"),
            actions: [
              CupertinoDialogAction(
                child: Text("retour"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  contactPopUp() {
    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            title: Text("Nous contacter"),
            cancelButton: CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {},
              child: Text("retour"),
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  contactMail();
                },
                child: Text(
                  "Mail",
                ),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  contactNumberWhatsApp();
                },
                child: Text(
                  "Whatssap",
                ),
              ),
            ],
          );
        });
  }
}
