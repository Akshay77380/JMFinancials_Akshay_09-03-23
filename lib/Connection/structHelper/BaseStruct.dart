import 'dart:typed_data';

class BaseStruct {
  int sizeInBytes;
  Uint8List valueInBytes;

  Uint8List toBytes() {
    return this.valueInBytes;
  }

  void setValueAsBytes(Uint8List value) {
    this.valueInBytes = value;
  }
}
