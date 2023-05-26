import 'dart:typed_data';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'package:markets/Connection/structHelper/BaseStruct.dart';
import 'package:markets/Connection/structHelper/ByteStruct.dart';
import 'package:markets/Connection/structHelper/CharArrStruct.dart';
import 'package:markets/Connection/structHelper/CharStruct.dart';
import 'package:markets/Connection/structHelper/ShortStruct.dart';
import 'package:markets/Connection/structHelper/StringStruct.dart';
import 'package:markets/Connection/structHelper/UShortStruct.dart';

class THeaderRecord extends BaseStruct {
  CharStruct msgType;
  UShortStruct msgLen;
  List<BaseStruct> fields;

  THeaderRecord() {
    init();
  }

  void init() {
    this.msgLen = new UShortStruct(0);
    this.msgType = new CharStruct(' '.codeUnitAt(0));
    this.fields = new List<BaseStruct>.from([this.msgType, this.msgLen]);
    this.sizeInBytes = sizeOf();
    this.valueInBytes = toBytes();
  }

  @override
  Uint8List toBytes() {
    return getBytes();
  }

  int sizeOf() {
    int size = 0;
    int count = 0;
    if (this.fields.length > 0) {
      while (count < this.fields.length) {
        if (this.fields[count] != null) {
          if (this.fields[count] is ByteStruct) {
            ByteStruct bs = this.fields[count];
            size += bs.sizeInBytes;
          } else if (this.fields[count] is CharArrStruct) {
            CharArrStruct cas = this.fields[count];
            size += cas.sizeInBytes;
          } else if (this.fields[count] is CharStruct) {
            CharStruct cas = this.fields[count];
            size += cas.sizeInBytes;
          } else if (this.fields[count] is ShortStruct) {
            ShortStruct cas = this.fields[count];
            size += cas.sizeInBytes;
          } else if (this.fields[count] is UShortStruct) {
            UShortStruct cas = this.fields[count];
            size += cas.sizeInBytes;
          } else if (this.fields[count] is StringStruct) {
            StringStruct ss = this.fields[count];
            size += ss.toBytes().length;
          } else {
            size += this.fields[count].sizeInBytes;
          }
        }
        count++;
      }
    }

    return size;
  }

  Uint8List getBytes() {
    Uint8List output = new Uint8List(sizeOf());
    int count = 0;
    if (this.fields != null && this.fields.length > 0) {
      int len = 0;
      while (count < this.fields.length) {
        if (this.fields[count] != null) {
          if (this.fields[count] is ByteStruct) {
            ByteStruct bs = this.fields[count];
            output[len] = bs.toByte();
            len++;
          } else if (this.fields[count] is CharStruct) {
            CharStruct cs = this.fields[count];
            output[len] = cs.toByte();
            len++;
          } else if (this.fields[count] is CharArrStruct) {
            CharArrStruct cas = this.fields[count];
            Uint8List source = cas.toBytes();
            output.setRange(len, len + source.length, source, 0);
            len += cas.sizeOf();
          } else if (this.fields[count] is StringStruct) {
            StringStruct ss = this.fields[count];
            Uint8List source = ss.toBytes();
            output.setRange(len, len + source.length, source, 0);
            len += ss.toBytes().length;
          } else if (this.fields[count] is ShortStruct) {
            ShortStruct ss = this.fields[count];
            Uint8List source = ss.toBytes();
            output.setRange(len, len + source.length, source, 0);
            len += ss.toBytes().length;
          } else if (this.fields[count] is UShortStruct) {
            UShortStruct ss = this.fields[count];
            Uint8List source = ss.toBytes();
            output.setRange(len, len + source.length, source, 0);
            len += ss.toBytes().length;
          } else {
            Uint8List source = this.fields[count].toBytes();
            output.setRange(len, len + source.length, source, 0);
            len += this.fields[count].sizeInBytes;
          }
        }
        count++;
      }
    }
    return output;
  }

  void setFields(Uint8List input) {
    int count = 0;
    try {
      if (this.fields != null && this.fields.length > 0) {
        int len = 0;
        while (count < this.fields.length) {
          if (this.fields[count] != null) {
            if (this.fields[count] is ByteStruct) {
              ByteStruct bs = this.fields[count];
              bs.setValue(input[len]);
              this.fields[count] = bs;
              len++;
            } else if (this.fields[count] is CharStruct) {
              CharStruct cs = this.fields[count];
              cs.setValue(input[len]);
              this.fields[count] = cs;
              len++;
            } else if (this.fields[count] is StringStruct) {
              StringStruct structString = this.fields[count];
              Uint8List bArr2 = new Uint8List(structString.getLength());
              bArr2.setRange(len, bArr2.length, input, 0);
              len += bArr2.length;
              try {
                structString.setValueAsBytes(bArr2);
                this.fields[count] = structString;
              } on Exception {}
            } else {
              Uint8List output = new Uint8List(this.fields[count].sizeInBytes);
              output.setRange(len, output.length, input, 0);
              this.fields[count].setValueAsBytes(output);
              if (this.fields[count] is CharArrStruct) {
                CharArrStruct cas = this.fields[count];
                len += cas.sizeInBytes;
                this.fields[count] = cas;
              } else if (this.fields[count] is ShortStruct) {
                ShortStruct ss = this.fields[count];
                len += ss.sizeInBytes;
                this.fields[count] = ss;
              } else if (this.fields[count] is UShortStruct) {
                UShortStruct ss = this.fields[count];
                len += ss.sizeInBytes;
                this.fields[count] = ss;
              } else {
                len += this.fields[count].sizeInBytes;
              }
            }
          }
          count++;
        }
      }
    } catch (e, s) {
      // FirebaseCrashlytics.instance.recordError(e, s);
    }
  }
}
