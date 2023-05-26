import 'dart:typed_data';

import 'package:markets/Connection/structHelper/CharStruct.dart';
import 'package:markets/Connection/structHelper/IntStruct.dart';

import '../../../structHelper/BaseStruct.dart';
import '../../../structHelper/ByteStruct.dart'; // ignore: import_duplicated_library_named
import '../../../structHelper/CharArrStruct.dart'; // ignore: import_duplicated_library_named
import '../../../structHelper/ObjectStruct.dart'; // ignore: import_duplicated_library_named
import '../../../structHelper/UShortStruct.dart'; // ignore: import_duplicated_library_named

class TEODRequestHeaderRecord extends ObjectStruct {
  ByteStruct replyType;
  ByteStruct accountType;
  CharStruct chatUserType;
  UShortStruct errorCode;
  UShortStruct replyRecSize;
  UShortStruct replyCount;
  IntStruct replyLen;

  CharArrStruct connID;
  ByteStruct feUserIDLength;
  CharArrStruct feUserID;
  CharArrStruct errorString;
  ByteStruct errorStringLength;
  CharStruct exch;
  IntStruct scripCode;
  ByteStruct compressed;
  TEODRequestHeaderRecord() {
    init();
  }

  void init() {
    this.replyType = new ByteStruct(0);
    this.accountType = new ByteStruct(0);
    this.chatUserType = new CharStruct(0);
    this.errorCode = new UShortStruct(0);
    this.replyRecSize = new UShortStruct(0);
    this.replyCount = new UShortStruct(0);
    this.replyLen = new IntStruct(0);
    this.connID = new CharArrStruct(Uint8List(20));
    this.feUserIDLength = new ByteStruct(0);
    this.feUserID = new CharArrStruct(Uint8List(15));
    this.errorString = new CharArrStruct(Uint8List(20));
    this.errorStringLength = new ByteStruct(0);
    this.exch = new CharStruct(0);
    this.scripCode = new IntStruct(0);
    this.compressed = new ByteStruct(0);
    this.fields = new List<BaseStruct>.from([
      this.replyType,
      this.accountType,
      this.chatUserType,
      this.errorCode,
      this.replyRecSize,
      this.replyCount,
      this.replyLen,
      this.connID,
      this.feUserIDLength,
      this.feUserID,
      this.errorString,
      this.errorStringLength,
      this.exch,
      this.scripCode,
      this.compressed,
    ]);
  }
}
