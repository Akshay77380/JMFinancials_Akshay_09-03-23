import 'dart:typed_data';

import 'package:markets/Connection/structHelper/BaseStruct.dart';

class LongArrStruct extends BaseStruct {
  List<int> _value;
  LongArrStruct(int length) {
    _value = [];
    this._value.length = length;
    this.sizeInBytes = _value.length * 8;
  }

  Uint8List toBytes() {
    int count = 0;
    ByteData bd = ByteData(8 * _value.length);
    for (int j = 0; j < _value.length; j++) {
      bd.setInt64(count, _value[j], Endian.little);
      count += 8;
    }
    return bd.buffer.asUint8List();
  }

  int sizeOf() {
    return sizeInBytes;
  }

  void setValueAsBytes(Uint8List bArr) {
    List<int> temp = [];
    for (int j = 0; j < bArr.length; j += 8) {
      temp.add(bArr.buffer.asByteData().getInt64(j, Endian.little));
    }
    this._value = temp;
  }

  List<int> getValue() {
    return this._value;
  }
}
