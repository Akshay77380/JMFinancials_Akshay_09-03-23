import 'dart:typed_data';

import 'package:markets/Connection/structHelper/BaseStruct.dart';
import 'package:markets/Connection/structHelper/TypeConverter.dart';

class CharStruct extends BaseStruct {
  int value;

  CharStruct(int value) {
    this.value = value;
    this.sizeInBytes = 1;
    this.valueInBytes = toBytes();
  }

  Uint8List toBytes() {
    return TypeConverter.charToByte(value);
  }

  int toByte() {
    return value;
  }

  int sizeOf() {
    return sizeInBytes;
  }

  void setValueChar(String b) {
    this.value = b.codeUnitAt(0);
  }

  void setValue(int b) {
    this.value = b;
  }

  int getValue() {
    return this.value;
  }

  String getValueChar() {
    return String.fromCharCode(this.value);
  }
}
