import 'dart:typed_data';

import 'package:markets/Connection/structHelper/BaseStruct.dart';
import 'package:markets/Connection/structHelper/BooleanStruct.dart';
import 'package:markets/Connection/structHelper/ByteArrStruct.dart';
import 'package:markets/Connection/structHelper/ByteStruct.dart';
import 'package:markets/Connection/structHelper/DoubleStruct.dart';
import 'package:markets/Connection/structHelper/FloatStruct.dart';
import 'package:markets/Connection/structHelper/LongStruct.dart';
import 'package:markets/Connection/structHelper/ShortStruct.dart';
import 'package:markets/Connection/structHelper/CharArrStruct.dart';
import 'package:markets/Connection/structHelper/CharStruct.dart';
import 'package:markets/Connection/structHelper/StringStruct.dart';
import 'package:markets/Connection/structHelper/IntStruct.dart';
import 'package:markets/Connection/structHelper/UShortStruct.dart';

class ObjectStruct {
  List<BaseStruct> fields;
  String className;

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
            len += source.length;
          } else if (this.fields[count] is ByteArrStruct) {
            ByteArrStruct cas = this.fields[count];
            Uint8List source = cas.toBytes();
            output.setRange(len, len + source.length, source, 0);
            len += cas.sizeOf();
          } else {
            Uint8List source = this.fields[count].toBytes();
            output.setRange(len, len + source.length, source, 0);
            len += this.fields[count].sizeInBytes;
          }
//          Logit.e("ObjectStruct",
//              "object done at index " + count.toString() + " "+" with total len "+len.toString());
        } else {
          // //print("object is null at index " + count.toString());
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
            } else if (this.fields[count] is BooleanStruct) {
              BooleanStruct cs = this.fields[count];
              Uint8List output = new Uint8List(cs.sizeInBytes);
              output.setRange(0, output.length, input, len);
              cs.setValueAsBytes(output);
              this.fields[count] = cs;
              len += cs.sizeInBytes;
            } else if (this.fields[count] is CharStruct) {
              CharStruct cs = this.fields[count];
              cs.setValue(input[len]);
              this.fields[count] = cs;
              len++;
            } else if (this.fields[count] is CharArrStruct) {
              CharArrStruct cs = this.fields[count];
              Uint8List output = new Uint8List(cs.sizeInBytes);
              output.setRange(0, output.length, input, len);
              cs.setValueAsBytes(output);
              this.fields[count] = cs;
              len += cs.sizeInBytes;
            } else if (this.fields[count] is IntStruct) {
              IntStruct cs = this.fields[count];
              Uint8List output = new Uint8List(cs.sizeInBytes);
              output.setRange(0, output.length, input, len);
              cs.setValueAsBytes(output);
              this.fields[count] = cs;
              len += cs.sizeInBytes;
            } else if (this.fields[count] is FloatStruct) {
              FloatStruct cs = this.fields[count];
              Uint8List output = new Uint8List(cs.sizeInBytes);
              output.setRange(0, output.length, input, len);
              cs.setValueAsBytes(output);
              this.fields[count] = cs;
              len += cs.sizeInBytes;
            } else if (this.fields[count] is DoubleStruct) {
              DoubleStruct cs = this.fields[count];
              Uint8List output = new Uint8List(cs.sizeInBytes);
              output.setRange(0, output.length, input, len);
              cs.setValueAsBytes(output);
              this.fields[count] = cs;
              len += cs.sizeInBytes;
            } else if (this.fields[count] is ShortStruct) {
              ShortStruct cs = this.fields[count];
              Uint8List output = new Uint8List(cs.sizeInBytes);
              output.setRange(0, output.length, input, len);
              cs.setValueAsBytes(output);
              this.fields[count] = cs;
              len += cs.sizeInBytes;
            } else if (this.fields[count] is LongStruct) {
              LongStruct cs = this.fields[count];
              Uint8List output = new Uint8List(cs.sizeInBytes);
              output.setRange(0, output.length, input, len);
              cs.setValueAsBytes(output);
              this.fields[count] = cs;
              len += cs.sizeInBytes;
            } else if (this.fields[count] is UShortStruct) {
              UShortStruct cs = this.fields[count];
              Uint8List output = new Uint8List(cs.sizeInBytes);
              output.setRange(0, output.length, input, len);
              cs.setValueAsBytes(output);
              this.fields[count] = cs;
              len += cs.sizeInBytes;
            } else if (this.fields[count] is StringStruct) {
              StringStruct structString = this.fields[count];
              Uint8List bArr2 = new Uint8List(structString.getLength());
              bArr2.setRange(0, bArr2.length, input, len);
              len += bArr2.length;
              try {
                structString.setValueAsBytes(bArr2);
                this.fields[count] = structString;
              } on Exception {}
            } else {
              Uint8List output = new Uint8List(this.fields[count].sizeInBytes);
              output.setRange(0, output.length, input, len);
              this.fields[count].setValueAsBytes(output);
              len += this.fields[count].sizeInBytes;
            }
          } else {
            // //print("Struct is null");
          }
          count++;
        }
      }
    } on Exception catch (e) {
      ////print(e.toString());
    }
  }
}
