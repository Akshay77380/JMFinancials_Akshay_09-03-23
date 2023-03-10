import 'dart:typed_data';

import 'package:markets/Connection/structHelper/BaseStruct.dart';
import 'package:markets/Connection/structHelper/TypeConverter.dart'; // ignore: import_duplicated_library_named

class LongStruct extends BaseStruct {
  int _value;

  LongStruct(int value) {
    this._value = value.toUnsigned(64);
    this.sizeInBytes = 8;
  }

  Uint8List toBytes() {
    return TypeConverter.longToByte(_value);
  }

  int sizeOf() {
    return sizeInBytes;
  }

  void setValue(int val) {
    this._value = val;
  }

  void setValueAsBytes(Uint8List bArr) {
    this._value = TypeConverter.byteToLong(bArr);
  }

  int getValue() {
    return this._value;
  }
}
