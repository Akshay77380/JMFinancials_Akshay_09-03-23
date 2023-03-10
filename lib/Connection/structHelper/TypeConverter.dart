import 'dart:typed_data';

class TypeConverter {
  static double byteToDouble(Uint8List bArr) {
    return bArr.buffer.asByteData().getFloat64(0, Endian.little);
  }

  static double byteToFloat(Uint8List bArr) {
    return bArr.buffer.asByteData().getFloat32(0, Endian.little);
  }

  static int byteToInt(Uint8List bArr) {
    return bArr.buffer.asByteData().getInt32(0, Endian.little);
  }

  static int byteToLong(Uint8List bArr) {
    return bArr.buffer.asByteData().getInt64(0, Endian.little);
  }

  static int byteToShort(Uint8List bArr) {
    return bArr.buffer.asByteData().getInt16(0, Endian.little);
  }

  static int byteToUShort(Uint8List bArr) {
    return bArr.buffer.asByteData().getUint16(0, Endian.little);
  }

  static Uint8List doubleToByte(double d) {
    ByteData bd = ByteData(8);
    bd.setFloat64(0, d, Endian.little);
    return bd.buffer.asUint8List();
  }

  static Uint8List floatToByte(double f) {
    ByteData bd = ByteData(4);
    bd.setFloat32(0, f, Endian.little);
    return bd.buffer.asUint8List();
  }

  static Uint8List intToByte(int i) {
    ByteData bd = ByteData(4);
    bd.setInt32(0, i, Endian.little);
    return bd.buffer.asUint8List();
  }

  static Uint8List longToByte(int j) {
    ByteData bd = ByteData(8);
    bd.setInt64(0, j, Endian.little);
    return bd.buffer.asUint8List();
  }

  static Uint8List shortToByte(int s) {
    ByteData bd = ByteData(2);
    bd.setInt16(0, s, Endian.little);
    return bd.buffer.asUint8List();
  }

  static Uint8List ushortToByte(int s) {
    ByteData bd = ByteData(2);
    bd.setUint16(0, s, Endian.little);
    return bd.buffer.asUint8List();
  }

  static Uint8List charToByte(int s) {
    ByteData bd = ByteData(1);
    bd.setInt8(0, s);
    return bd.buffer.asUint8List();
  }

  /*static Uint8List intToLong(int j) {
    ByteData bd = ByteData(4);
    bd.setInt64(0, j, Endian.little);
    return bd.buffer.asUint8List();
  }*/
}
