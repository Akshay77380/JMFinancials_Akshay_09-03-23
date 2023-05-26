import 'dart:typed_data';

import 'package:markets/Connection/structHelper/BaseStruct.dart';
import 'package:markets/Connection/structHelper/TypeConverter.dart'; // ignore: import_duplicated_library_named

class FloatStruct extends BaseStruct {
  double value;

  FloatStruct(double d) {
    this.value = d;
    this.sizeInBytes = 4;
  }

  int sizeOf() {
    return sizeInBytes;
  }

  double getValue() {
    return this.value;
  }

  void setValueAsDouble(double d) {
    this.value = d;
  }

  void setValueAsBytes(Uint8List bArr) {
    this.value = TypeConverter.byteToFloat(bArr);
  }

  Uint8List toBytes() {
    return TypeConverter.floatToByte(this.value);
  }
}
