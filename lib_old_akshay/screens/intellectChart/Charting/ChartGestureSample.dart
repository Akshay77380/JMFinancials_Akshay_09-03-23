import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: MyHomePage(),
    ));

class MyHomePage extends StatelessWidget {
  Widget build(BuildContext context) => Scaffold(
        body: Listener(
          onPointerDown: (e) {
            double x = e.position.dx.round().toDouble();
            double y = (e.position.dy).round().toDouble();
            //print(e.buttons.toString());
            //print(
            //     'result.put("onDown  ",  ${e.timeStamp.inMilliseconds}, ${e.pointer}, new Point<double>($x, $y}));');
          },
          onPointerMove: (e) {
            double x = e.position.dx.round().toDouble();
            double y = (e.position.dy).round().toDouble();
            // //print(
            //     'result.put("onMove  ",  ${e.timeStamp.inMilliseconds}, ${e.pointer}, new Point<double>($x, $y}));');
          },
          onPointerUp: (e) {
            double x = e.position.dx.round().toDouble();
            double y = (e.position.dy).round().toDouble();
            // //print(
            //     'result.put("onUp    ",  ${e.timeStamp.inMilliseconds}, ${e.pointer}, new Point<double>($x, $y}));');
          },
          onPointerCancel: (e) {
            double x = e.position.dx.round().toDouble();
            double y = (e.position.dy).round().toDouble();
            // //print(
            //     'result.put("onCancel",  ${e.timeStamp.inMilliseconds}, ${e.pointer}, new Point<double>($x, $y}));');
          },
          child: CustomPaint(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white70,
                gradient:
                    LinearGradient(colors: [Colors.lightBlue, Colors.white30]),
                border: Border.all(
                  color: Colors.blueGrey,
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
      );
}
