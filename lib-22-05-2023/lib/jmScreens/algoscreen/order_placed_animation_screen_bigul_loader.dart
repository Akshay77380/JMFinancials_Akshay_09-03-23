
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../style/theme.dart';

class OrderPlacedAnimationScreenBigulLoader extends StatefulWidget {
  final String text;

  OrderPlacedAnimationScreenBigulLoader(this.text);

  @override
  _OrderPlacedAnimationScreenBigulState createState() =>
      _OrderPlacedAnimationScreenBigulState();
}

class _OrderPlacedAnimationScreenBigulState extends State<OrderPlacedAnimationScreenBigulLoader>
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
      backgroundColor:Colors.transparent,   // theme.cardColor.withOpacity(0.7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 200,
              padding: EdgeInsets.all(50),
              child: CircularProgressIndicator(strokeWidth: 10.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                    ThemeConstants.buyColor),
              ),
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
