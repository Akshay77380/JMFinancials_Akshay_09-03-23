import 'dart:typed_data';

import 'package:markets/Connection/structHelper/BaseStruct.dart';

class StringStruct extends BaseStruct {
  int _length;
  String _value;

  StringStruct(String str, int i) {
    this._value = str;
    this._length = i;
    this.valueInBytes = toBytes();
  }

  int getLength() {
    return this._length;
  }

  String getValue() {
    String str = "";
    if (this._value != null) {
      str = this._value;
    }
    return str.trim();
  }

  String padRight(String str, int i) {
    return str.trim().padRight(i, ' ');
  }

  void setLength(int i) {
    this._length = i;
  }

  void setValuePad(String str, int length) {
    String temp = str.trim().padRight(length, ' ');
    this._value = temp;
  }

  void setValue(String str) {
    this._value = str;
  }

  void setValueAsBytes(Uint8List bArr) {
    String s = String.fromCharCodes(bArr.toList());
    setValue(s);
  }

  @override
  Uint8List toBytes() {
    String s = padRight(this._value, this._length);
    Uint8List output = new Uint8List(s.length);
    int len = 0;
    for (int i = 0; i < s.length; i++) {
      output[len] = s.codeUnitAt(i);
      len++;
    }
    return output;
  }

  String toString() {
    return getValue();
  }
}
