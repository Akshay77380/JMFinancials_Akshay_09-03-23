import 'package:flutter/material.dart';
import '../style/theme.dart';

class DecimalText extends StatelessWidget {
  final String text;
  final TextStyle style;

  DecimalText(
    this.text, {
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    var temp = text.split('.');
    if (temp.length == 2)
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            '${temp[0]}.',
            style: style,
          ),
          Text(
            temp[1],
            style: style == null
                ? TextStyle(
                    fontSize: 10.5,
                  )
                : style.copyWith(
                    fontSize:
                        style.fontSize == null ? 10.5 : style.fontSize * 0.75,
                  ),
          ),
        ],
      );
    else
      return Text(
        text,
        style: style,
      );
  }
}

class DecimalBlinkText extends StatefulWidget {
  final double value;
  final String text;
  final Color color;
  final TextStyle style;

  DecimalBlinkText({
    @required this.value,
    @required this.text,
    @required this.color,
    this.style,
  });

  @override
  _DecimalBlinkTextState createState() => _DecimalBlinkTextState();
}

class _DecimalBlinkTextState extends State<DecimalBlinkText>
    with SingleTickerProviderStateMixin {
  double prevValue = 0;
  Animation<Color> upAnimation, downAnimation;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    prevValue = widget.value;
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.ease);
    upAnimation = ColorTween(begin: widget.color, end: ThemeConstants.buyColor)
        .animate(curve);
    downAnimation =
        ColorTween(begin: widget.color, end: ThemeConstants.sellColor)
            .animate(curve);
    upAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var temp = widget.text.split('.');
    var difference = widget.value - prevValue;
    if (difference != 0) controller.forward();

    if (temp.length == 2)
      return difference < 0
          ? AnimatedBuilder(
              animation: downAnimation,
              builder: (context, child) => Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    '${temp[0]}.',
                    style: widget.style == null
                        ? TextStyle(color: downAnimation.value)
                        : widget.style.copyWith(color: downAnimation.value),
                  ),
                  Text(
                    temp[1],
                    style: widget.style == null
                        ? TextStyle(
                            fontSize: 10.5,
                            color: downAnimation.value,
                          )
                        : widget.style.copyWith(
                            color: downAnimation.value,
                            fontSize: widget.style.fontSize == null
                                ? 10.5
                                : widget.style.fontSize * 0.75,
                          ),
                  ),
                ],
              ),
            )
          : difference > 0
              ? AnimatedBuilder(
                  animation: upAnimation,
                  builder: (context, child) => Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        '${temp[0]}.',
                        style: widget.style == null
                            ? TextStyle(color: upAnimation.value)
                            : widget.style.copyWith(color: downAnimation.value),
                      ),
                      Text(
                        temp[1],
                        style: widget.style == null
                            ? TextStyle(
                                fontSize: 10.5,
                                color: upAnimation.value,
                              )
                            : widget.style.copyWith(
                                color: upAnimation.value,
                                fontSize: widget.style.fontSize == null
                                    ? 10.5
                                    : widget.style.fontSize * 0.75,
                              ),
                      ),
                    ],
                  ),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      '${temp[0]}.',
                      style: widget.style,
                    ),
                    Text(
                      temp[1],
                      style: widget.style == null
                          ? TextStyle(
                              fontSize: 10.5,
                            )
                          : widget.style.copyWith(
                              fontSize: widget.style.fontSize == null
                                  ? 10.5
                                  : widget.style.fontSize * 0.75,
                            ),
                    ),
                  ],
                );
    else
      return Text(
        widget.text,
        style: widget.style,
      );
  }
}
