import 'dart:typed_data';

import 'package:markets/Connection/structHelper/BaseStruct.dart';
import 'package:markets/Connection/structHelper/TypeConverter.dart'; // ignore: import_duplicated_library_named

class BooleanStruct extends BaseStruct {
  int value;

  BooleanStruct(bool z) {
    this.value = (z ? 1 : 0);
    this.sizeInBytes = 4;
  }

  Uint8List toBytes() {
    return TypeConverter.intToByte(this.value);
  }

  int sizeOf() {
    return this.sizeInBytes;
  }

  void setValueAsInt(int i) {
    this.value = i;
  }

  @override
  void setValueAsBytes(Uint8List value) {
    this.value = value[0];
  }

  bool getValue() {
    return this.value == 1;
  }
}
