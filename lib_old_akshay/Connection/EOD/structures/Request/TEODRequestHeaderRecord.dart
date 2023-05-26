import 'dart:typed_data';

import '../../../structHelper/BaseStruct.dart';
import '../../../structHelper/ByteStruct.dart'; // ignore: import_duplicated_library_named
import '../../../structHelper/CharArrStruct.dart'; // ignore: import_duplicated_library_named
import '../../../structHelper/ObjectStruct.dart'; // ignore: import_duplicated_library_named
import '../../../structHelper/UShortStruct.dart'; // ignore: import_duplicated_library_named

class TEODRequestHeaderRecord extends ObjectStruct {
  ByteStruct idLength;
  CharArrStruct clientID;
  ByteStruct requestType;
  UShortStruct requestLen;

  TEODRequestHeaderRecord() {
    init();
  }

  void init() {
    this.idLength = new ByteStruct(0);
    this.clientID = new CharArrStruct(Uint8List(15));
    this.requestType = new ByteStruct(0);
    this.requestLen = new UShortStruct(0);
    this.fields = new List<BaseStruct>.from([
      this.idLength,
      this.clientID,
      this.requestType,
      this.requestLen,
    ]);
  }
}
