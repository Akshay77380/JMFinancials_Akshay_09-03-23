import 'package:markets/Connection/IQS/structures/Request/THeaderRecord.dart';
import 'package:markets/Connection/structHelper/CharStruct.dart';

import '../../../structHelper/BaseStruct.dart';
import '../../../structHelper/ObjectStruct.dart';
import '../../../structHelper/IntStruct.dart';

class TReqScripIntraDayHistoryVolRecord extends ObjectStruct {
  THeaderRecord header;
  CharStruct exch;
  IntStruct code;
  IntStruct uptoTime;

  TReqScripIntraDayHistoryVolRecord() {
    init();
  }

  void init() {
    this.header = new THeaderRecord();
    this.exch = new CharStruct(' '.codeUnitAt(0));
    this.code = new IntStruct(0);
    this.uptoTime = new IntStruct(0);
    this.fields = new List<BaseStruct>.from([
      this.header,
      this.exch,
      this.code,
      this.uptoTime,
    ]);
  }
}
