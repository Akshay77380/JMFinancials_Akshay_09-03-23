import 'dart:typed_data';

import 'package:markets/Connection/structHelper/BaseStruct.dart';

class IntArrStruct extends BaseStruct {
  List<int> _value;
  IntArrStruct(int length) {
    _value = [];
    this._value.length = length;
    this.sizeInBytes = _value.length * 4;
  }

  Uint8List toBytes() {
    int count = 0;
    ByteData bd = ByteData(4 * _value.length);
    for (int j = 0; j < _value.length; j++) {
      bd.setInt32(count, _value[j], Endian.little);
      count += 4;
    }
    return bd.buffer.asUint8List();
  }

  int sizeOf() {
    return sizeInBytes;
  }

  void setValueAsBytes(Uint8List bArr) {
    List<int> temp = [];
    for (int j = 0; j < bArr.length; j += 4) {
      temp.add(bArr.buffer.asByteData().getInt32(j, Endian.little));
    }
    this._value = temp;
  }

  List<int> getValue() {
    return this._value;
  }
}
