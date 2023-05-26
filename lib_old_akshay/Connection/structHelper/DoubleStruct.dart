import 'dart:typed_data';

import 'package:markets/Connection/structHelper/BaseStruct.dart';
import 'package:markets/Connection/structHelper/TypeConverter.dart'; // ignore: import_duplicated_library_named

class DoubleStruct extends BaseStruct {
  double value;

  DoubleStruct(double d) {
    this.value = d;
    this.sizeInBytes = 8;
  }

  double getValue() {
    return this.value;
  }

  void setValueAsDouble(double d) {
    this.value = d;
  }

  void setValueAsBytes(Uint8List bArr) {
    this.value = TypeConverter.byteToDouble(bArr);
  }

  Uint8List toBytes() {
    return TypeConverter.doubleToByte(this.value);
  }

  int sizeOf() {
    return sizeInBytes;
  }

  String toString() {
    return this.value.toString();
  }

  String getFormattedValue(String exch) {
    try {
      if (exch == "C") {
        return this.value.toStringAsFixed(4);
      }
      return this.value.toStringAsFixed(2);
    } on Exception {}
    return this.value.toString();
  }
}
