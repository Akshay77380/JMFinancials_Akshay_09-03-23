import 'dart:typed_data';

import 'package:markets/Connection/structHelper/BaseStruct.dart';
import 'package:markets/Connection/structHelper/TypeConverter.dart';

class UShortStruct extends BaseStruct {
  int _value;

  UShortStruct(int value) {
    this._value = value;
    this.sizeInBytes = 2;
    this.valueInBytes = toBytes();
  }

  @override
  Uint8List toBytes() {
    return TypeConverter.ushortToByte(this._value);
  }

  int sizeOf() {
    return sizeInBytes;
  }

  void setValueAsBytes(Uint8List bArr) {
    this._value = TypeConverter.byteToUShort(bArr);
  }

  void setValue(int val) {
    this._value = val;
  }

  int getValue() {
    return _value;
  }
}
