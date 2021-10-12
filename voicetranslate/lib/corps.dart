// ignore_for_file: avoid_print, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_constructors, curly_braces_in_flow_control_structures, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'dart:ui';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voicetranslate/constante/couleur.dart';
import "package:avatar_glow/avatar_glow.dart";
import "package:speech_to_text/speech_to_text.dart" as stt;
import "package:flutter_tts/flutter_tts.dart" as tts;
import "package:translator/translator.dart";
import 'package:voicetranslate/constante/enddrawer.dart';
import 'package:voicetranslate/database/translateDatabase.dart';
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
  bool isCamera = true;

  Langue langueDepart =
      Langue(nom: "francais", abreger: 'fr', image: "assets/france.png");
  Langue langueArriver =
      Langue(nom: "Anglais", abreger: 'en', image: "assets/angleterre.png");

  InputImage? inputImage;
  TextDetector textDetector = GoogleMlKit.vision.textDetector();

  bool verif = false;
  bool showFAB = true;
  bool copied = false;
  ScrollController scrollController = ScrollController();

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

        copied = false;
        DatabaseTraduction.instance.insert(
          TraduitResult(
            id: 1,
            motEntrer: motEntrer,
            resultatTraduction: resultatTraduction,
            langueDepart: depart,
            langueArriver: arriver,
          ),
        );
        load = false; //fin de la traduction
        ScaffoldMessenger.of(context)
            .removeCurrentMaterialBanner(); // a la fin de latraduction on enleve la banner
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

  getTextOnImage() async {
    setState(() {
      verif =
          true; // au debut pour get l'image verif devient true et xa charge a la fin de la fonction il redevient false pour laisser apparaitre l'aplli
    });
    var resultat = "";
    ImagePicker picker = ImagePicker();
    ImageSource source = isCamera ? ImageSource.camera : ImageSource.gallery;
    final image = await picker.pickImage(source: source);

    if (image != null) {
      File? cropImage = await ImageCropper.cropImage(
        sourcePath: image.path,
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
        androidUiSettings: AndroidUiSettings(
          activeControlsWidgetColor: Colors.purple,
          toolbarTitle: "Choississez le text à traduire",
          toolbarWidgetColor: Colors.white,
          toolbarColor: mycolor1,
          lockAspectRatio: false, //pour pouvoir bien rogner
        ),
      );
      if (cropImage != null) {
        inputImage = InputImage.fromFile(File(cropImage.path));
        RecognisedText recognisedText =
            await textDetector.processImage(inputImage!);

        for (var block in recognisedText.blocks) {
          for (var l in block.lines) {
            setState(() {
              resultat += l.text + " ";
            });
          }
        }
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
    setState(() {
      verif = false;
    });
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
    if (verif)
      return Scaffold(
        backgroundColor: mycolor1,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mycolor1,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mycolor3,
        title: Text(ecoute ? "Veillez parler..." : "Voice Translate"),
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
      body: SingleChildScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      changeLangue(true);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
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
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 15),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: motEntrer != "" ? mycolor4 : Colors.transparent,
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
                    textSpech.stop(); // stoper pour eviter les melanges de voix
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
                  InkWell(
                    onTap: () {
                      changeLangue(false);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, right: 10, bottom: 10),
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Container(
                            child: CircleAvatar(
                              backgroundImage: AssetImage(langueArriver.image!),
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
                                margin: EdgeInsets.symmetric(horizontal: 10),
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
                          if (resultatTraduction != "" && !ecoute && !copied)
                            IconButton(
                              onPressed: () {
                                FlutterClipboard.copy(resultatTraduction!)
                                    .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 1),
                                      content: Text("Text copié"),
                                    ),
                                  );
                                  setState(() {
                                    copied = true;
                                  });
                                });
                              },
                              icon: Icon(
                                Icons.copy,
                                color: Colors.grey,
                              ),
                            ),
                        ],
                      ),
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
                                ? Border.all(color: Colors.white54, width: 0.5)
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
                  InkWell(
                    onLongPress: () {
                      setState(() {
                        isCamera = !isCamera;
                      });
                    },
                    child: IconButton(
                      splashRadius: 30,
                      onPressed: () {
                        getTextOnImage();
                      },
                      icon: Icon(
                        isCamera ? Icons.camera_alt_outlined : Icons.photo,
                        color: Colors.grey,
                      ),
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
                heroTag: "FAB",
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
    print("-----------------------");
    print(
        load); //load dois etre false si c'est true c'est que traduction en cours
    if (load) {
      ScaffoldMessenger.of(context)
        ..removeCurrentMaterialBanner()
        ..showMaterialBanner(
          MaterialBanner(
            backgroundColor: mycolor4,
            content: Text(
              "Traduction déja en cours ...",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).removeCurrentMaterialBanner();
                  },
                  child: Text("ok")),
            ],
          ),
        );
    } else {
      setState(() {
        motEntrer = "";
        resultatTraduction = "";
      }); // pour gerer la repetition de l'ancien resultatTraduction quand il ya une erreur
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
                  "Réessayer",
                );
              } else if (val.errorMsg == "error_client") {
                setState(() {
                  motEntrer = "";
                  resultatTraduction = "";
                });
                myDialog(
                  "Impossible de vous ecoutez",
                  "veillez activer Google dans les paramètres pour utiliser cette fonctionalité",
                  "Ok",
                );
              } else if (val.errorMsg == "error_server") {
                myDialog(
                  "Connection impossible",
                  "vous avez besoin de la connection internet pour cette fonctionnalité",
                  "Ok",
                );
              } else if (val.errorMsg == "error_no_match") {
                setState(() {
                  textSpech.stop();
                });

                myDialog(
                  "Incompris",
                  "Nous avons pas compris ce que vous avez dit veillez réessayer",
                  "Réessayer",
                );
              } else if (val.errorMsg == "error_network") {
                myDialog(
                  "Aucune connexion",
                  "Nous avons pas pus traduit ce que vous avez dit veillez réessayer",
                  "Réessayer",
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
              onResult: (resultat) async {
                setState(() {
                  motEntrer = resultat.recognizedWords;
                });
              },
            );
          } else {
            // pas disponible veillez activer les autorisatios

            showCupertinoDialog(
                context: context,
                barrierDismissible: true,
                builder: (contex) {
                  return CupertinoAlertDialog(
                    title: Text("Non disponible"),
                    content: Text(
                        "veillez activer l'acces au microphone dans les paramètres"),
                    actions: [
                      CupertinoDialogAction(
                        child: Text("Paramètre"),
                        onPressed: () {
                          AppSettings.openAppSettings();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                });
          }
        } on PlatformException catch (e) {
          print(e.toString());
          if (e.code == "recognizerNotAvailable") {
            myDialog(
              "Non disponible",
              "veillez activer Google dans les paramètres pour utiliser cette fonctionalité",
              "Ok",
            );
          }
        }
      } else {
        setState(() {
          ecoute = false;
        });
        speech.stop();
      }
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

  myDialog(String title, String content, String action) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              child: Text(action),
              onPressed: () {
                Navigator.pop(context);
                if (action != "Ok") func();
              },
            )
          ],
        );
      },
    );
  }

  changeLangue(bool first) {
    // si first==true changeDepartLangue sinon changeArriverlangue
    List<Langue> mesLangues = [
      Langue(nom: "francais", abreger: 'fr', image: "assets/france.png"),
      Langue(nom: "anglais", abreger: 'en', image: "assets/angleterre.png"),
      Langue(nom: "Allemand", abreger: "de", image: "assets/allemand.png"),
      Langue(nom: "russe", abreger: 'ru', image: "assets/russie.png"),
      Langue(nom: "arabe", abreger: 'ar', image: "assets/rabe.png"),
      Langue(nom: "espagnol", abreger: 'es', image: "assets/espagne.png"),
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
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: c,
              ),
            ),
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
                  width: 40,
                  height: 5,
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
                      child: Container(
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
              ],
            ),
          );
        });
  }
}
