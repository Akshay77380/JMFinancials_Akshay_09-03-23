import 'dart:typed_data';
import 'dart:math';

import 'package:markets/Connection/structHelper/BaseStruct.dart';

class CharArrStruct extends BaseStruct {
  Uint8List _value;

  CharArrStruct(Uint8List value) {
    this._value = value;
    this.sizeInBytes = (value.length * 1);
    this.valueInBytes = toBytes();
  }

  void setValue(String s, int length) {
    String temp = s.trim().padRight(length, ' ');
    int finalLength = min(temp.length, length);
    this._value = Uint8List(length);
    for (int i = 0; i < finalLength; i++) {
      this._value[i] = temp.codeUnitAt(i);
    }
    this.sizeInBytes = (this._value.length * 1);
  }

  String getValue() {
    return String.fromCharCodes(this._value.toList());
  }

  @override
  Uint8List toBytes() {
    return _value;
  }

  void setValueAsBytes(Uint8List b) {
    String s = String.fromCharCodes(b.toList()).trim();
    setValue(s, sizeInBytes);
  }

  void setValueAsString(String s) {
    setValue(s, s.length);
  }

  int sizeOf() {
    this.sizeInBytes = (this._value.length * 1);
    return this.sizeInBytes;
  }

  String toString() {
    return getValue();
  }
}
