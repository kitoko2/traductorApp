import "package:flutter/material.dart";
import 'couleur.dart';

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
        topLeft: Radius.circular(10),
        bottomLeft: Radius.circular(10),
      ),
      child: Drawer(
        child: Container(
          color: mycolor1,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: const [
              UserAccountsDrawerHeader(
                accountName: Text("accountName"),
                accountEmail: Text("accountEmail"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
