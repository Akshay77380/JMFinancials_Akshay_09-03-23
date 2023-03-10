import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OrderPlacedAnimationScreenBigul extends StatefulWidget {
  final String text;

  OrderPlacedAnimationScreenBigul(this.text);

  @override
  _OrderPlacedAnimationScreenBigulState createState() =>
      _OrderPlacedAnimationScreenBigulState();
}

class _OrderPlacedAnimationScreenBigulState extends State<OrderPlacedAnimationScreenBigul>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pop({'result' : true});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.cardColor.withOpacity(0.7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/confirmation.json',
              repeat: false,
              onLoaded: (composition) {
                // Configure the AnimationController with the duration of the
                // Lottie file and start the animation.
                _controller
                  ..duration = composition.duration
                  ..forward();
              },
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
