// ignore_for_file: avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_constructors

import 'dart:io';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voicetranslate/constante/couleur.dart';
import "package:avatar_glow/avatar_glow.dart";
import "package:speech_to_text/speech_to_text.dart" as stt;
import "package:flutter_tts/flutter_tts.dart" as tts;
import "package:translator/translator.dart";
import 'package:voicetranslate/constante/enddrawer.dart';
import 'package:voicetranslate/langue.dart';
import "package:modal_bottom_sheet/modal_bottom_sheet.dart";
import "package:clipboard/clipboard.dart";
import "package:google_ml_kit/google_ml_kit.dart";

class Corps extends StatefulWidget {
  const Corps({Key? key}) : super(key: key);

  @override
  _CorpsState createState() => _CorpsState();
}

class _CorpsState extends State<Corps> {
  TextStyle style = const TextStyle(color: Colors.white);

  stt.SpeechToText speech = stt.SpeechToText();
  tts.FlutterTts textSpech = tts.FlutterTts();

  bool ecoute = false;
  String? motEntrer = "";

  GoogleTranslator googleTranslator = GoogleTranslator();

  String? resultatTraduction = "";

  bool toucher = false;
  bool load = false;

  Langue langueDepart =
      Langue(nom: "francais", abreger: 'fr', image: "assets/france.png");
  Langue langueArriver =
      Langue(nom: "Anglais", abreger: 'en', image: "assets/angleterre.png");

  traductor(
      {@required String? phrase,
      @required String? depart,
      @required String? arriver}) async {
    try {
      setState(() {
        load = true;
      });
      var a = await googleTranslator.translate(phrase!,
          from: depart!, to: arriver!);
      setState(() {
        resultatTraduction = a.text;
        load = false;
      });

      speak(arriver, resultatTraduction!);
    } catch (e) {
      // error de traduction
      // if Failed host lookup: 'translate.googleapis.com' pas connection
      print("traduction error not connection");
      print(e.toString());
      traductor(phrase: phrase, depart: depart, arriver: arriver);
    }
  }

  speak(String setLanguage, String phrase) async {
    textSpech.setLanguage(setLanguage);
    textSpech.speak(phrase).then(
          (value) => print("value speak $value"),
          onError: (error) => print("error speek $error"),
        );
  }

  InputImage? inputImage;
  TextDetector textDetector = GoogleMlKit.vision.textDetector();

  bool isLoading = false;
  bool showFAB = true;
  ScrollController scrollController = ScrollController();

  getTextOnImage() async {
    var resultat = "";
    ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      inputImage = InputImage.fromFile(File(image.path));
      setState(() {
        isLoading = true;
      });

      RecognisedText recognisedText =
          await textDetector.processImage(inputImage!);
      for (var block in recognisedText.blocks) {
        print(block.text);
        setState(() {
          resultat += block.text + " ";
        });
      }
      setState(() {
        isLoading = false;
      });
      if (resultat != "") {
        setState(() {
          motEntrer = resultat;
          toucher = true;
          traductor(
            phrase: motEntrer,
            depart: langueDepart.abreger,
            arriver: langueArriver.abreger,
          );
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      var direction = scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.reverse) {
        setState(() {
          showFAB = false;
        });
      } else {
        setState(() {
          showFAB = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mycolor1,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mycolor3,
        title: const Text("Voice Translate"),
        actions: [
          Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: const Icon(
                    Icons.settings,
                    size: 20,
                  ),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: mycolor4,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        ],
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                decoration: BoxDecoration(color: mycolor1),
                child: Column(
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            changeDepartLangue(true);
                          },
                          child: Row(
                            children: [
                              const SizedBox(width: 20),
                              Container(
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage(langueDepart.image!),
                                ),
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                "${langueDepart.nom}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 15),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color:
                                motEntrer != "" ? mycolor4 : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            border: motEntrer != ""
                                ? Border.all(color: Colors.white54, width: 0.5)
                                : null,
                          ),
                          width: double.infinity,
                          child: !toucher
                              ? Center(
                                  child: Text(
                                    "Appuiyer sur le boutton 'micro' et dites quelque chose...",
                                    style: style.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                )
                              : Text(
                                  motEntrer!,
                                  style: style.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: motEntrer != "" && !load,
                      child: IconButton(
                        onPressed: () async {
                          textSpech
                              .stop(); // stoper pour eviter les melanges de voix
                          setState(() {
                            var intermediaire = langueDepart;
                            langueDepart = langueArriver;
                            langueArriver = intermediaire;
                            motEntrer = resultatTraduction;
                            traductor(
                              phrase: motEntrer,
                              depart: langueDepart.abreger,
                              arriver: langueArriver.abreger,
                            );
                          });
                        },
                        icon: const Icon(
                          Icons.autorenew_rounded,
                          color: Colors.white38,
                          size: 29,
                        ),
                      ),
                    ),
                    if (motEntrer == "" || load)
                      const SizedBox(
                        height: 10,
                      ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            changeDepartLangue(false);
                          },
                          child: Row(
                            children: [
                              const SizedBox(width: 20),
                              Container(
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage(langueArriver.image!),
                                ),
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(width: 15),
                              Text(
                                "${langueArriver.nom}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (resultatTraduction != "" && !ecoute)
                                GestureDetector(
                                  onTap: () {
                                    speak(langueArriver.abreger!,
                                        resultatTraduction!);
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    child: Icon(
                                      Icons.volume_up,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.purple,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              Spacer(),
                              if (resultatTraduction != "" && !ecoute)
                                IconButton(
                                  onPressed: () {
                                    FlutterClipboard.copy(resultatTraduction!)
                                        .then(
                                      (value) => ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          duration: Duration(seconds: 1),
                                          content: Text("Text copié"),
                                        ),
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        load
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                  border: motEntrer != ""
                                      ? Border.all(
                                          color: Colors.white54, width: 0.5)
                                      : null,
                                ),
                                // height: 200,
                                width: double.infinity,
                                child: Text(
                                  "$resultatTraduction",
                                  style: style.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      endDrawer: PoyDrawer(),
      bottomSheet: showFAB
          ? Container(
              height: 60,
              color: mycolor1,
              child: Row(
                children: [
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      getTextOnImage();
                    },
                    icon: const Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      showClavier();
                    },
                    icon: const Icon(
                      Icons.keyboard,
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            )
          : Container(
              height: 0.001,
            ),
      floatingActionButton: showFAB
          ? AvatarGlow(
              animate: ecoute,
              glowColor: Colors.deepPurple,
              repeatPauseDuration: const Duration(milliseconds: 1),
              repeat: true,
              endRadius: 60,
              child: FloatingActionButton(
                backgroundColor: Colors.purple,
                onPressed: () {
                  func();
                },
                child:
                    Icon(ecoute ? Icons.mic_rounded : Icons.mic_none_rounded),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // MES FONCTIONS

  func() async {
    if (!ecoute) {
      try {
        textSpech.stop();
        bool available = await speech.initialize(
          onError: (val) {
            print("on error $val");
            if (val.errorMsg == "error_speech_timeout") {
              setState(() {
                motEntrer = "";
                resultatTraduction = "";
              });
              myDialog(
                "Delais passé",
                "Nous avons attendu aucun mots veillez réessayer",
              );
            }
            if (val.errorMsg == "error_server") {
              showCupertinoDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: const Text("Connection impossible"),
                    content: const Text(
                        "vous avez besoin de la connection internet pour cette fonctionnalité"),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text("Ok"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                },
              );
            }
            if (val.errorMsg == "error_no_match") {
              setState(() {
                textSpech.stop();
              });

              myDialog(
                "Incompris",
                "Nous avons pas compris ce que vous avez dit veillez réessayer",
              );
            }
            if (val.errorMsg == "error_network") {
              myDialog(
                "Aucune connexion",
                "Nous avons pas pus traduit ce que vous avez dit veillez réessayer",
              );
            }
          },
          onStatus: (val) {
            if (val == "done") {
              setState(() {
                ecoute = false;
              });

              if (motEntrer != "") {
                //traduction
                traductor(
                  phrase: motEntrer,
                  depart: langueDepart.abreger!,
                  arriver: langueArriver.abreger!,
                );
              }
            }

            print("on status $val");
          },
        );

        if (available) {
          setState(() {
            ecoute = true;
            toucher = true;
          });
          speech.listen(
            onResult: (resultat) {
              setState(() {
                motEntrer = resultat.recognizedWords;
              });
            },
          );
        }
      } on PlatformException catch (e) {
        print(e.toString());
      }
    } else {
      setState(() {
        ecoute = false;
      });
      speech.stop();
    }
  }

  showClavier() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.symmetric(vertical: 9),
            backgroundColor: mycolor4,
            title: Container(
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Container(
                    child: CircleAvatar(
                      backgroundImage: AssetImage(langueDepart.image!),
                    ),
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 15),
                  Text(
                    "${langueDepart.nom}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                height: 100,
                child: TextFormField(
                  onFieldSubmitted: (val) {
                    if (val.trim() != "") {
                      toucher = true; //pour enlever le text
                      setState(() {
                        motEntrer = val;
                        traductor(
                          phrase: motEntrer!,
                          depart: langueDepart.abreger,
                          arriver: langueArriver.abreger,
                        );
                      });
                    }
                    Navigator.pop(context);
                  },
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  maxLines: null,
                  cursorColor: Colors.white,
                  style: style.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w300,
                  ),
                  decoration: InputDecoration(
                    hintText: "Tapez une expression ou une phrase",
                    hintStyle: style.copyWith(
                      color: Colors.grey,
                      fontSize: 17,
                      fontWeight: FontWeight.w300,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              // CupertinoButton(
              //   child: Text("suivant"),
              //   onPressed: () {},
              // ),
            ],
          );
        });
  }

  myDialog(String title, String content) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              child: const Text("Réessayer"),
              onPressed: () {
                Navigator.pop(context);
                func();
              },
            )
          ],
        );
      },
    );
  }

  changeDepartLangue(bool first) {
    List<Langue> mesLangues = [
      Langue(nom: "francais", abreger: 'fr', image: "assets/france.png"),
      Langue(nom: "Anglais", abreger: 'en', image: "assets/angleterre.png"),
      Langue(nom: "russe", abreger: 'ru', image: "assets/russie.png"),
      Langue(nom: "arabe", abreger: 'ar', image: "assets/rabe.png"),
      Langue(nom: "espagne", abreger: 'es', image: "assets/espagne.png"),
      Langue(nom: "chinois", image: "assets/chine.png", abreger: "zh-cn"),
    ];
    for (var i = 0; i < mesLangues.length; i++) {
      if (mesLangues[i].abreger ==
          (first ? langueArriver.abreger : langueDepart.abreger)) {
        mesLangues.removeAt(i);
      }
    }

    showCustomModalBottomSheet(
        context: context,
        containerWidget: (context, animation, c) {
          return Container(
            child: c,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              color: mycolor4.withOpacity(0.9),
            ),
          );
        },
        builder: (context) {
          return Container(
            height: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 9, bottom: 20),
                  width: 45,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollBehavior(),
                    child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: mycolor4.withOpacity(0.9),
                      child: SizedBox(
                        height: 150,
                        child: CupertinoPicker(
                          itemExtent: 54,
                          onSelectedItemChanged: (select) {
                            setState(() {
                              if (first) {
                                langueDepart = mesLangues[select];
                                motEntrer = "";
                                resultatTraduction = "";
                              } else {
                                langueArriver = mesLangues[select];
                                motEntrer = "";
                                resultatTraduction = "";
                              }
                            });
                          },
                          children: List.generate(
                            mesLangues.length,
                            (index) => Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage(mesLangues[index].image!),
                                    ),
                                    width: 30,
                                    height: 30,
                                  ),
                                  Text(
                                    "${mesLangues[index].nom}",
                                    style: style,
                                  ),
                                  Icon(
                                    Icons.mic,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     child: Center(
                //       child: CupertinoButton(
                //           color: Colors.purple,
                //           child: Text("Selectionner"),
                //           onPressed: () {
                //             Navigator.pop(context);
                //           }),
                //     ),
                //   ),
                // )
              ],
            ),
          );
        });
  }
}
