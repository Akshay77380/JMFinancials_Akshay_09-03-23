import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../util/Utils.dart';

class NumberField extends StatefulWidget
{
  final TextEditingController numberController;
  final int maxLength;
  final double minValue;
  final double maxValue;
  final bool isInteger;
  final int defaultValue;
  final double doubleDefaultValue;
  final String hint;
  final int decimalPosition;
  final int increment;
  final double doubleIncrement;
  final bool isCurr;
  final bool isBuy;
  final bool isRupeeLogo;
  final bool isDisable;
  final bool setDefault;


  NumberField(
      {
        Key key,
        @required this.numberController,
        @required this.maxLength,
        this.minValue = 0,
        this.maxValue = 10000000,
        this.isInteger = false,
        this.defaultValue = 1,
        this.doubleDefaultValue = 1.0,
        this.hint = '',
        this.decimalPosition = 2,
        this.increment = 1,
        this.doubleIncrement = 1.0,
        this.isCurr = false,
        this.isBuy = false,
        this.isRupeeLogo = false,
        this.isDisable = false,
        this.setDefault = false,
      }) : super(key: key);

  @override
  _NumberFieldState createState() => _NumberFieldState();
}

class _NumberFieldState extends State<NumberField>
{

  bool _isPressed = false;
  int _springDelay = 500;
  bool isBorder = false;
  TextStyle style = TextStyle(fontSize: 25.0);

  @override
  void initState()
  {
    super.initState();

    // if (widget.setDefault == true) if (widget.numberController.text.isEmpty)
    //   widget.numberController.text = widget.isInteger ? widget.defaultValue.toInt().toString() : widget.doubleDefaultValue.toStringAsFixed(widget.decimalPosition);

    if (widget.setDefault && widget.numberController.text.isEmpty) {
      widget.numberController.text = widget.isInteger
          ? widget.defaultValue.toInt().toString()
          : widget.doubleDefaultValue.toStringAsFixed(widget.decimalPosition);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 55,
          decoration: BoxDecoration(
            color: widget.isBuy ? Utils.brightGreenColor.withOpacity(0.1) : Utils.brightRedColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: isBorder
                ? Border.all(
              color: widget.isBuy ? Utils.brightGreenColor : Utils.brightRedColor,
              width: 2,
            )
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                width: 5,
              ),
              if (widget.isRupeeLogo)
                const SizedBox(
                  width: 5,
                ),
              if (widget.isRupeeLogo)
                Center(
                  child: Text('₹', style: Utils.fonts(size: 22.0, fontWeight: FontWeight.w700, color: Utils.blackColor)),
                ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      // scrollPadding: EdgeInsets.only(
                      //     bottom: MediaQuery.of(context).viewInsets.top + 20*4),
                      textAlign: TextAlign.left,
                      style: Utils.fonts(size: 22.0, fontWeight: FontWeight.w700, color: Utils.blackColor),
                      onTap: () {
                        // setState(()  {
                        //   isBorder = true;
                        //   //await Future.delayed(Duration(milliseconds: 500));
                        // });
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          isBorder = false;
                        });
                      },
                      controller: widget.numberController,
                      inputFormatters:
                      // widget.maxLength != null
                      //     ? [LengthLimitingTextInputFormatter(widget.maxLength)]
                      //     :
                      widget.isInteger
                          ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(widget.maxLength)]
                          : [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,' + widget.decimalPosition.toString() + '}'),
                        ),
                      ],
                      keyboardType: TextInputType.numberWithOptions(signed: true),
                      textInputAction: TextInputAction.done,
                      maxLength: widget.maxLength,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 5),
                        isDense: true,
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(top: 7, bottom: 7, right: 5),
                  decoration: BoxDecoration(color: widget.isBuy ? Utils.brightGreenColor.withOpacity(0.4) : Utils.brightRedColor.withOpacity(0.4), borderRadius: BorderRadius.circular(5)),
                  child: GestureDetector(
                    child: InkWell(
                      child: widget.isBuy
                          ? SvgPicture.asset(
                        'assets/appImages/-.svg',
                        fit: BoxFit.scaleDown,
                      )
                          : SvgPicture.asset('assets/appImages/--1.svg', fit: BoxFit.scaleDown),
                      // child: Icon(
                      //   Icons.remove,
                      //   color: widget.isBuy ? ThemeConstants.buyColor : ThemeConstants.sellColor,
                      // ),
                      onTap: () {
                        widget.isDisable ? null : decrement();
                      },
                    ),
                    onLongPressStart: (_) async {
                      if (widget.isDisable) return;
                      HapticFeedback.vibrate();
                      _springDelay = 500;
                      _isPressed = true;
                      do {
                        if (widget.numberController.text != '1') decrement();
                        if (_springDelay > 100) _springDelay -= 100;
                        await Future.delayed(Duration(milliseconds: _springDelay));
                      } while (_isPressed);
                    },
                    onLongPressEnd: (_) => setState(() => _isPressed = false),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  margin: EdgeInsets.only(top: 7, bottom: 7, right: 5),
                  decoration: BoxDecoration(color: widget.isBuy ? Utils.brightGreenColor.withOpacity(0.4) : Utils.brightRedColor.withOpacity(0.4), borderRadius: BorderRadius.circular(5)),
                  child: GestureDetector(
                    child: InkWell(
                      child: widget.isBuy
                          ? SvgPicture.asset(
                        'assets/appImages/+.svg',
                        fit: BoxFit.scaleDown,
                      )
                          : SvgPicture.asset('assets/appImages/+-1.svg', fit: BoxFit.scaleDown),
                      // child: Icon(Icons.add, color: widget.isBuy ? ThemeConstants.buyColor : ThemeConstants.sellColor,),
                      onTap: widget.isDisable ? null : increment,
                    ),
                    onLongPressStart: (_) async {
                      if (widget.isDisable) return;
                      _isPressed = true;
                      _springDelay = 500;
                      HapticFeedback.vibrate();
                      do {
                        increment();
                        if (_springDelay > 100) _springDelay -= 100;
                        await Future.delayed(Duration(milliseconds: _springDelay));
                      } while (_isPressed);
                    },
                    onLongPressEnd: (_) => setState(() => _isPressed = false),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.isDisable)
          Container(
            height: 55,
            decoration: BoxDecoration(
              color: Utils.whiteColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
      ],
    );
  }

  void increment() {
    FocusScope.of(context).unfocus();
    if (widget.isInteger) {
      var value = int.tryParse(widget.numberController.text) ?? 0;

      if (value >= widget.maxValue) return;
      setState(() {
        value += widget.increment;
        widget.numberController.text = value.toString();
      });
    } else {
      var value = double.tryParse(widget.numberController.text) ?? 0.0;
      if (value >= widget.maxValue) return;
      setState(() {
        value += widget.doubleIncrement;
        widget.numberController.text = value.toStringAsFixed(widget.decimalPosition);
      });
    }
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);   return ((value * mod).round().toDouble() / mod);
  }

  void decrement() {
    FocusScope.of(context).unfocus();
    if (widget.isInteger) {
      var value = int.tryParse(widget.numberController.text) ?? 0;

      if (value <= widget.minValue) return;
      setState(() {
        value -= widget.increment;
        if (value < 0) value = 0;
        widget.numberController.text = value.toString();
      });
    } else {
      var value = double.tryParse(widget.numberController.text) ?? 0;
      if (value <= widget.minValue) return;
      setState(() {
        value -= widget.doubleIncrement;
        if (value < 0) value = 0;
        widget.numberController.text = value.toStringAsFixed(widget.decimalPosition);
      });
    }
  }
}
