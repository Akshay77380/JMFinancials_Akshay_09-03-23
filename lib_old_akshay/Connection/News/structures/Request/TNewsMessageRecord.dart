import 'dart:typed_data';

import 'package:markets/Connection/structHelper/CharStruct.dart';
import 'package:markets/Connection/structHelper/IntStruct.dart';

import '../../../structHelper/BaseStruct.dart';
import '../../../structHelper/ByteStruct.dart'; // ignore: import_duplicated_library_named
import '../../../structHelper/CharArrStruct.dart'; // ignore: import_duplicated_library_named
import '../../../structHelper/ObjectStruct.dart'; // ignore: import_duplicated_library_named

class TNewsMessageRecord extends ObjectStruct {
  CharStruct msgType;
  IntStruct replyLength;
  IntStruct replyCount;
  IntStruct nseCode;
  IntStruct bseCode;
  ByteStruct compression;
  ByteStruct connIDLength;
  CharArrStruct connID;
  IntStruct date;

  TNewsMessageRecord() {
    init();
  }

  void init() {
    msgType = CharStruct(' '.codeUnitAt(0));
    replyLength = IntStruct(0);
    replyCount = IntStruct(0);
    nseCode = IntStruct(0);
    bseCode = IntStruct(0);
    compression = ByteStruct(0);
    connIDLength = ByteStruct(0);
    connID = CharArrStruct(Uint8List(30));
    date = IntStruct(0);
    fields = List<BaseStruct>.from([
      msgType,
      replyLength,
      replyCount,
      nseCode,
      bseCode,
      compression,
      connIDLength,
      connID,
      date,
    ]);
  }
}
