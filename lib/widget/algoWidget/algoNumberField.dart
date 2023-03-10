import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AlgoNumberField extends StatefulWidget {
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
  final bool isDisabled;
  var onChangedValue;
  var changedIndex;

  AlgoNumberField(
      {@required this.numberController,
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
        this.isDisabled = false,
        this.onChangedValue,
        this.changedIndex});

  @override
  _AlgoNumberFieldState createState() => _AlgoNumberFieldState();
}

class _AlgoNumberFieldState extends State<AlgoNumberField> {
  bool _isPressed = false;
  int _springDelay = 500;

  var callBack;

  @override
  void initState() {
    super.initState();

    callBack = widget.onChangedValue;

    if (widget.numberController.text.isEmpty)
      widget.numberController.text = widget.isInteger
          ? widget.defaultValue.toInt().toString()
          : widget.doubleDefaultValue.toStringAsFixed(widget.decimalPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: InkWell(
                child: Icon(
                  Icons.remove,
                  color: widget.isDisabled ? Colors.grey : null,
                ),
                onTap: widget.isDisabled ? null : decrement,
              ),
              onLongPressStart: (_) async {
                if (widget.isDisabled) return;
                HapticFeedback.vibrate();
                _springDelay = 500;
                _isPressed = true;
                do {
                  decrement();
                  if (_springDelay > 100) _springDelay -= 100;
                  await Future.delayed(Duration(milliseconds: _springDelay));
                } while (_isPressed);
              },
              onLongPressEnd: (_) {
                if (widget.isDisabled) return;
                setState(() => _isPressed = false);
              },
            ),
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onChanged: (value) {
                    callBack(value,widget.changedIndex);
                  },
                  onTap: () {
                    selectAll();
                    // FocusScope.of(context).unfocus();
                    // new TextEditingController().clear();
                  },
                  // selectAll,
                  enabled: !widget.isDisabled,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: widget.isDisabled ? Colors.grey : null,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  controller: widget.numberController,
                  inputFormatters: widget.isInteger
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,' +
                          widget.decimalPosition.toString() +
                          '}'),
                    ),
                  ],
                  keyboardType: Platform.isAndroid
                      ? TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true
                  )
                      : TextInputType.numberWithOptions(signed: true,decimal: true),
                  maxLength: widget.maxLength,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    isDense: true,
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
                Text(
                  widget.hint,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: InkWell(
                child: Icon(
                  Icons.add,
                  color: widget.isDisabled ? Colors.grey : null,
                ),
                onTap: widget.isDisabled ? null : increment,
              ),
              onLongPressStart: (_) async {
                if (widget.isDisabled) return;
                _isPressed = true;
                _springDelay = 500;
                HapticFeedback.vibrate();
                do {
                  increment();
                  if (_springDelay > 100) _springDelay -= 100;
                  await Future.delayed(Duration(milliseconds: _springDelay));
                } while (_isPressed);
              },
              onLongPressEnd: (_) {
                if (widget.isDisabled) return;
                setState(() => _isPressed = false);
              },
            ),
          ),
        ],
      ),
    );
  }

  void selectAll() {
    if (widget.numberController.text == null ||
        widget.numberController.text.isEmpty) return;
    widget.numberController.selection = TextSelection(
        baseOffset: 0, extentOffset: widget.numberController.text.length);
  }

  void increment() {
    FocusScope.of(context).unfocus();
    if (widget.isInteger) {
      var value = int.tryParse(widget.numberController.text) ?? 0;

      if (value >= widget.maxValue) return;
      setState(() {
        value += widget.increment;
        widget.numberController.text = value.toString();
        callBack(widget.numberController.text,widget.changedIndex);
      });
    } else {
      var value = double.tryParse(widget.numberController.text) ?? 0.0;
      if (value >= widget.maxValue) return;
      setState(() {
        value += widget.doubleIncrement;
        widget.numberController.text =
            value.toStringAsFixed(widget.decimalPosition);
        callBack(widget.numberController.text,widget.changedIndex);
      });
    }
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
        callBack(widget.numberController.text,widget.changedIndex);
      });
    } else {
      var value = double.tryParse(widget.numberController.text) ?? 0;
      if (value <= widget.minValue) return;
      setState(() {
        value -= widget.doubleIncrement;
        if (value < 0) value = 0;
        widget.numberController.text =
            value.toStringAsFixed(widget.decimalPosition);
        callBack(widget.numberController.text,widget.changedIndex);
      });
    }
  }
}

class TriggerAlgoNumberField extends StatefulWidget {
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
  final Function triggerFunction;

  TriggerAlgoNumberField({
    @required this.numberController,
    @required this.maxLength,
    @required this.triggerFunction,
    this.minValue = 0,
    this.maxValue = 10000000,
    this.isInteger = false,
    this.defaultValue = 1,
    this.doubleDefaultValue = 1.0,
    this.hint = '',
    this.decimalPosition = 2,
    this.increment = 1,
    this.doubleIncrement = 1.0,
  });
  @override
  _TriggerAlgoNumberFieldState createState() => _TriggerAlgoNumberFieldState();
}

class _TriggerAlgoNumberFieldState extends State<TriggerAlgoNumberField> {
  bool _isPressed = false;
  int _springDelay = 500;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    if (widget.numberController.text.isEmpty)
      widget.numberController.text = widget.isInteger
          ? widget.defaultValue.toInt().toString()
          : widget.doubleDefaultValue.toStringAsFixed(widget.decimalPosition);
    widget.numberController.addListener(resetTimer);
  }

  void resetTimer() {
    if (_timer != null) {
      _timer.cancel();
    }
    _timer = Timer(const Duration(seconds: 1), () {
      widget.triggerFunction();
    });
  }

  @override
  void dispose() {
    widget.numberController.removeListener(resetTimer);
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: InkWell(
                child: Icon(
                  Icons.remove,
                ),
                onTap: decrement,
              ),
              onLongPressStart: (_) async {
                HapticFeedback.vibrate();
                _springDelay = 500;
                _isPressed = true;
                do {
                  decrement();
                  if (_springDelay > 100) _springDelay -= 100;
                  await Future.delayed(Duration(milliseconds: _springDelay));
                } while (_isPressed);
              },
              onLongPressEnd: (_) => setState(() => _isPressed = false),
            ),
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  onTap: selectAll,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true,
                      decimal: true
                  ),
                  controller: widget.numberController,
                  inputFormatters: widget.isInteger
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,' +
                          widget.decimalPosition.toString() +
                          '}'),
                    ),
                  ],
                  maxLength: widget.maxLength,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0.0),
                    isDense: true,
                    border: InputBorder.none,
                    counterText: '',
                  ),
                ),
                Text(
                  widget.hint,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: InkWell(
                child: Icon(Icons.add),
                onTap: increment,
              ),
              onLongPressStart: (_) async {
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
        ],
      ),
    );
  }

  void selectAll() {
    if (widget.numberController.text == null ||
        widget.numberController.text.isEmpty) return;
    widget.numberController.selection = TextSelection(
        baseOffset: 0, extentOffset: widget.numberController.text.length);
  }

  void increment() {
    FocusScope.of(context).unfocus();
    resetTimer();
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
        widget.numberController.text =
            value.toStringAsFixed(widget.decimalPosition);
      });
    }
  }

  void decrement() {
    FocusScope.of(context).unfocus();
    resetTimer();
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
        widget.numberController.text =
            value.toStringAsFixed(widget.decimalPosition);
      });
    }
  }
}
