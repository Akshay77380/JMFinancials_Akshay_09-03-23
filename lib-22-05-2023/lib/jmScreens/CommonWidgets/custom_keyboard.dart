import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';

class NumPad extends StatefulWidget {
  final TextEditingController controller;
  final Function delete;
  final Function onSubmit;
  final bool isInt;
  final bool isCurrency;

  const NumPad({
    @required this.delete,
    @required this.onSubmit,
    @required this.controller,
    @required this.isInt,
    @required this.isCurrency,
  });

  @override
  State<NumPad> createState() => _NumPadState();
}

class _NumPadState extends State<NumPad> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Utils.greyColor.withOpacity(0.2),
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    NumberButton(
                      number: '1',
                      controller: widget.controller,
                      isInt: widget.isInt,
                      isCurrency: widget.isCurrency,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    NumberButton(
                      number: '2',
                      controller: widget.controller,
                      isInt: widget.isInt,
                      isCurrency: widget.isCurrency,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    NumberButton(
                      number: '3',
                      controller: widget.controller,
                      isInt: widget.isInt,
                      isCurrency: widget.isCurrency,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NumberButton(
                      number: '4',
                      controller: widget.controller,
                      isInt: widget.isInt,
                      isCurrency: widget.isCurrency,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    NumberButton(
                      number: '5',
                      controller: widget.controller,
                      isInt: widget.isInt,
                      isCurrency: widget.isCurrency,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    NumberButton(
                      number: '6',
                      controller: widget.controller,
                      isInt: widget.isInt,
                      isCurrency: widget.isCurrency,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    NumberButton(
                      number: '7',
                      controller: widget.controller,
                      isInt: widget.isInt,
                      isCurrency: widget.isCurrency,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    NumberButton(
                      number: '8',
                      controller: widget.controller,
                      isInt: widget.isInt,
                      isCurrency: widget.isCurrency,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    NumberButton(
                      number: '9',
                      controller: widget.controller,
                      isInt: widget.isInt,
                      isCurrency: widget.isCurrency,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () => widget.delete(),
                        child: Container(
                          height: 35,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Utils.whiteColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Icon(
                            Icons.backspace_outlined,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    NumberButton(
                      number: '0',
                      controller: widget.controller,
                      isInt: widget.isInt,
                      isCurrency: widget.isCurrency,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    NumberButton(
                      number: '.',
                      controller: widget.controller,
                      isInt: widget.isInt,
                      isCurrency: widget.isCurrency,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    InAppSelection.orderPlacementScreenIndex = 1;
                    Dataconstants.pageController.add(true);
                  },
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Utils.whiteColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/appImages/bidask.svg'),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'BID/ASK',
                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => widget.onSubmit(),
                  child: Container(
                    height: 80,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Utils.whiteColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 18,
                            child: Icon(
                              Icons.horizontal_rule,
                              size: 30,
                            )),
                        Icon(
                          Icons.arrow_downward,
                          size: 18,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'CLOSE',
                          style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NumberButton extends StatelessWidget {
  final String number;
  final TextEditingController controller;
  final bool isInt;
  final bool isCurrency;

  const NumberButton({
    @required this.number,
    @required this.controller,
    this.isInt,
    this.isCurrency,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isInt == true) {
            if (controller.text.length > 5) return;
          } else {
            var value = controller.text.split('.')[0];
            if (value.length > 5) return;
          }
          if (number == '.') {
            if (controller.text.contains('.') || isInt == true) return;
          }
          var cursorPos = controller.selection.base.offset;
          String suffixText = controller.text.substring(cursorPos);
          String prefixText = controller.text.substring(0, cursorPos);
          controller.text = prefixText + number + suffixText;
          controller.value = controller.value.copyWith(selection: TextSelection.fromPosition(TextPosition(offset: cursorPos + 1)));
          var text;
          if(controller.text.contains('.')) {
            if (isCurrency == true)
              text = controller.text.split('.')[0] + '.' + controller.text.split('.')[1].substring(0, 4);
            else
              text = controller.text.split('.')[0] + '.' + controller.text.split('.')[1].substring(0, 2);
          }
          controller.text = text;
          controller.value = controller.value.copyWith(selection: TextSelection.fromPosition(TextPosition(offset: cursorPos + 1)));
        },
        child: Container(
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Utils.whiteColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            number.toString(),
            style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
