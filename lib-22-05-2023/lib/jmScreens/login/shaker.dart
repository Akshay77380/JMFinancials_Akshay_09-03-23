import 'dart:math';

import 'package:flutter/cupertino.dart';

class Shaker extends StatefulWidget {
  final child;
  const Shaker({Key key,this.child}) : super(key: key);

  @override
  State<Shaker> createState() => ShakerState();
}

class ShakerState extends State<Shaker>   with SingleTickerProviderStateMixin {
   AnimationController animationController;
   Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800), // how long the shake happens
    )..addListener(() => setState(() {}));

    animation = Tween<double>(
      begin: 00.0,
      end: 120.0,
    ).animate(animationController);
  }

   _shake() {
    double progress = animationController.value;
    double offset = sin(progress * pi * 10.0);  // change 10 to make it vibrate faster
    return offset;  // change 25 to make it vibrate wider
  }

  shake() {
    animationController.forward(from:0);
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translation(_shake()),
      child: widget.child,
    );
  }
}

