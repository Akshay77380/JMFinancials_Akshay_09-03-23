import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../util/Utils.dart';
import '../CommonWidgets/number_field.dart';

class buySip extends StatefulWidget {
  @override
  State<buySip> createState() => _buySipState();
}

class _buySipState extends State<buySip> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NumberField(
            numberController: _textEditingController,
            maxLength: 22,
            isBuy: true,
          ),
          SizedBox(height: 10),
          Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("AVAILABLE MARGIN",
                    style: Utils.fonts(
                        size: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey)),
                Text("REQUIRED MARGIN",
                    style: Utils.fonts(
                        size: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey)),
              ]),
              SizedBox(
                height: 5,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('\u{20B9}${" 2,22,222.22"}',
                    style: Utils.fonts(
                        fontWeight: FontWeight.w700, color: Utils.blackColor)),
                Text('\u{20B9}${" 7,22,12.212"}',
                    style: Utils.fonts(
                        fontWeight: FontWeight.w700, color: Colors.black)),
              ])
            ],
          ),
        ],
      ),
    );
  }
}
