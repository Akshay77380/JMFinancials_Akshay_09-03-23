import 'dart:typed_data';

import '../../../structHelper/CharStruct.dart';
import '../../../structHelper/IntStruct.dart';
import '../../../structHelper/BaseStruct.dart';
import '../../../structHelper/ByteStruct.dart'; // ignore: import_duplicated_library_named
import '../../../structHelper/CharArrStruct.dart'; // ignore: import_duplicated_library_named
import '../../../structHelper/ObjectStruct.dart'; // ignore: import_duplicated_library_named
import '../../../structHelper/UShortStruct.dart'; // ignore: import_duplicated_library_named

class TEODReplyHeaderRecord extends ObjectStruct {
  static TEODReplyHeaderRecord instance;
  ByteStruct idLength;
  CharArrStruct clientID;
  ByteStruct replyType;
  IntStruct replyLen;
  UShortStruct replyRecSize;
  UShortStruct replyCnt;
  CharStruct exch;
  IntStruct scripCode;
  ByteStruct compressed;

  TEODReplyHeaderRecord() {
    init();
  }

  void init() {
    this.idLength = new ByteStruct(0);
    this.clientID = new CharArrStruct(Uint8List(15));
    this.replyType = new ByteStruct(0);
    this.replyLen = new IntStruct(0);
    this.replyRecSize = new UShortStruct(0);
    this.replyCnt = new UShortStruct(0);
    this.exch = new CharStruct(' '.codeUnitAt(0));
    this.scripCode = new IntStruct(0);
    this.compressed = new ByteStruct(0);
    this.fields = new List<BaseStruct>.from([
      this.idLength,
      this.clientID,
      this.replyType,
      this.replyLen,
      this.replyRecSize,
      this.replyCnt,
      this.exch,
      this.scripCode,
      this.compressed,
    ]);
  }

  static TEODReplyHeaderRecord getInstance() {
    if (instance == null) {
      instance = new TEODReplyHeaderRecord();
    }
    return instance;
  }

  static void resetInstance() {
    if (instance != null) {
      instance = null;
    }
  }
}
