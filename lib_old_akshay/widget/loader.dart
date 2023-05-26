import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final String msg;

  Loader({this.msg});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Material(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(msg),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
