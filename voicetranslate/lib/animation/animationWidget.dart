// ignore_for_file: avoid_print, prefer_const_constructors, file_names

import 'dart:async';

import "package:flutter/material.dart";

enum Depart {
  left,
  right,
  bottom,
  top,
}

class AnimationWidget extends StatefulWidget {
  final Widget? child;
  final int? second;
  final Depart depart;
  const AnimationWidget(
      {Key? key,
      required this.child,
      required this.second,
      required this.depart})
      : super(key: key);

  @override
  _AnimationWidgetState createState() => _AnimationWidgetState();
}

class _AnimationWidgetState extends State<AnimationWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  Tween<Offset>? position =
      Tween<Offset>(begin: Offset(0, 1), end: Offset.zero);
  func() {
    switch (widget.depart) {
      case Depart.bottom:
        setState(() {
          position = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero);
        });
        break;
      case Depart.top:
        setState(() {
          position = Tween<Offset>(begin: Offset(0, -1), end: Offset.zero);
        });
        break;
      case Depart.left:
        setState(() {
          position = Tween<Offset>(begin: Offset(-1, 0), end: Offset.zero);
        });
        break;
      case Depart.right:
        setState(() {
          position = Tween<Offset>(begin: Offset(1, 0), end: Offset.zero);
        });
        break;
      default:
        print("error");
    }
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    func();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    Timer(Duration(seconds: widget.second!), () {
      if (mounted) {
        animationController!.forward();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController!,
      child: SlideTransition(
        child: widget.child,
        position: position!.animate(animationController!),
      ),
    );
  }
}
