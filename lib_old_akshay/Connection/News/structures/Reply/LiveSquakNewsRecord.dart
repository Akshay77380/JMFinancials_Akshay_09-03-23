import 'dart:typed_data';

import 'package:markets/Connection/structHelper/IntStruct.dart';

import '../../../structHelper/BaseStruct.dart';
import '../../../structHelper/ByteStruct.dart'; // ignore: import_duplicated_library_named
import '../../../structHelper/CharArrStruct.dart'; // ignore: import_duplicated_library_named
import '../../../structHelper/ObjectStruct.dart'; // ignore: import_duplicated_library_named

class LiveSquakNewsRecord extends ObjectStruct {
  ByteStruct categoryLength;
  CharArrStruct category;
  ByteStruct companyNameLength;
  CharArrStruct companyName;
  IntStruct descLength;
  CharArrStruct desc;
  IntStruct nseCode;
  IntStruct bseCode;
  IntStruct date;

  LiveSquakNewsRecord() {
    init();
  }

  void init() {
    categoryLength = ByteStruct(0);
    category = CharArrStruct(Uint8List(30));
    companyNameLength = ByteStruct(0);
    companyName = CharArrStruct(Uint8List(100));
    descLength = IntStruct(0);
    desc = CharArrStruct(Uint8List(1000));
    nseCode = IntStruct(0);
    bseCode = IntStruct(0);
    date = IntStruct(0);
    fields = List<BaseStruct>.from([
      categoryLength,
      category,
      companyNameLength,
      companyName,
      descLength,
      desc,
      nseCode,
      bseCode,
      date,
    ]);
  }
}
