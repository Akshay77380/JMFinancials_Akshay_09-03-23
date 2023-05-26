import 'dart:typed_data';
import 'package:markets/Connection/structHelper/BaseStruct.dart';

class ByteArrStruct extends BaseStruct {
  List<int> _value;
  ByteArrStruct(int length) {
    this._value = [];
    this._value.length = length;
    this.sizeInBytes = _value.length;
  }

  Uint8List toBytes() {
    ByteData bd = ByteData(_value.length);
    for (int j = 0; j < _value.length; j++) {
      bd.setUint8(j, _value[j]);
    }
    return bd.buffer.asUint8List();
  }

  int sizeOf() {
    return sizeInBytes;
  }

  void setValueAsBytes(Uint8List bArr) {
    this._value = bArr;
  }

  List<int> getValue() {
    return this._value;
  }
}
