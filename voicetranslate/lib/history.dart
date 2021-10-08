// ignore_for_file: prefer_const_constructors, unnecessary_new, avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voicetranslate/constante/couleur.dart';
import 'package:voicetranslate/database/translateDatabase.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: mycolor1,
      appBar: new AppBar(
        backgroundColor: mycolor3.withOpacity(0.8),
        title: Text("Historique"),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10, top: 7, bottom: 7),
            child: const Icon(
              Icons.cancel_sharp,
              size: 20,
            ),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: mycolor4,
              shape: BoxShape.circle,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                DatabaseTraduction.instance.delete();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: Icon(
                Icons.delete,
                size: 20,
              ),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: mycolor4,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(13),
        child: FutureBuilder<List<TraduitResult>>(
            future: DatabaseTraduction.instance.mesResultats(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final r = snapshot.data;
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: r!.length,
                  itemBuilder: (context, i) {
                    return Container(
                      decoration: BoxDecoration(
                        color: mycolor4,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${r[i].motEntrer}",
                            style: TextStyle(
                              color: Colors.white24,
                              fontWeight: FontWeight.w700,
                              fontSize: 23,
                            ),
                          ),
                          Text(
                            "${r[i].resultatTraduction}",
                            style: TextStyle(
                              color: Colors.white54,
                              fontWeight: FontWeight.w700,
                              fontSize: 23,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return CircularProgressIndicator();
            }),
      ),
    );
  }
}
