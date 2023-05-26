import 'dart:typed_data';

import 'package:markets/Connection/structHelper/BaseStruct.dart';
import 'package:markets/Connection/structHelper/TypeConverter.dart';

class IntStruct extends BaseStruct {
  int _value;

  IntStruct(int value) {
    this._value = value;
    this.sizeInBytes = 4;
  }

  @override
  Uint8List toBytes() {
    return TypeConverter.intToByte(this._value);
  }

  int sizeOf() {
    return sizeInBytes;
  }

  void setValueAsBytes(Uint8List bArr) {
    this._value = TypeConverter.byteToInt(bArr);
  }

  void setValue(int value) {
    this._value = value;
  }

  int getValue() {
    return this._value;
  }
}
