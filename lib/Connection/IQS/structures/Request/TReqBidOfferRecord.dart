import 'package:markets/Connection/structHelper/ByteStruct.dart';
import 'package:markets/Connection/IQS/structures/Request/THeaderRecord.dart';
import 'package:markets/Connection/structHelper/BaseStruct.dart';
import 'package:markets/Connection/structHelper/CharStruct.dart';
import 'package:markets/Connection/structHelper/IntStruct.dart';
import 'package:markets/Connection/structHelper/ObjectStruct.dart';

class TReqBidOfferRecord extends ObjectStruct {
  THeaderRecord header;
  CharStruct exch;
  IntStruct code;
  ByteStruct addToList;

  TReqBidOfferRecord() {
    init();
  }

  void init() {
    header = THeaderRecord();
    exch = CharStruct(' '.codeUnitAt(0));
    code = IntStruct(0);
    addToList = ByteStruct(0);
    fields = List<BaseStruct>.from([
      header,
      exch,
      code,
      addToList,
    ]);
  }
}
