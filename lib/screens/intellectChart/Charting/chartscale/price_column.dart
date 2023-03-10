import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../theme/color_palette.dart';

class PriceColumn extends StatelessWidget {
  const PriceColumn({
    Key key,
    this.tileHeight,
    this.high,
    this.scaleIndex,
    this.width,
    this.height,
  }) : super(key: key);

  final double tileHeight;
  final double high;
  final int scaleIndex;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    List<double> scales = [
      0.001,
      0.002,
      0.005,
      0.01,
      0.02,
      0.05,
      0.1,
      0.2,
      0.5,
      1,
      2,
      5,
      10,
      20,
      50,
      100,
      200,
      500,
      1000,
      2000,
      5000,
      10000,
      20000,
      50000,
    ];

    return AnimatedPositioned(
      duration: Duration(milliseconds: 400),
      top: 20 - tileHeight / 2,
      child: Container(
        height: height,
        width: width,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: 100,
          itemBuilder: (context, index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 400),
              height: tileHeight,
              child: Center(
                child: Row(
                  children: [
                    Container(
                      width: width - 50,
                      height: 0.3,
                      color: ColorPalette.grayColor,
                    ),
                    Text(
                      "-${(high - scales[scaleIndex] * index).toInt()}",
                      style: TextStyle(
                        color: ColorPalette.grayColor,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
