import 'dart:typed_data';

import 'package:markets/Connection/structHelper/BaseStruct.dart';

class ByteStruct extends BaseStruct {
  int _value;

  ByteStruct(int value) {
    this._value = value;
    this.sizeInBytes = 1;
    this.valueInBytes = toBytes();
  }

  @override
  Uint8List toBytes() {
    ByteData bd = ByteData(1);
    bd.setUint8(0, _value);
    return bd.buffer.asUint8List();
  }

  int toByte() {
    return this._value;
  }

  int sizeOf() {
    return this.sizeInBytes;
  }

  void setValue(int i) {
    _value = i;
  }

  int getValue() {
    return this._value;
  }
}
