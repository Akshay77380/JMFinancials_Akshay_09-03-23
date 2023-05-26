// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import,camel_case_types

mixin CandleEntity {
  double open;
  double high;
  double low;
  double close;
  int datetime;

  List<double> maValueList;
  List<double> tempMAValueList;

  List<double> up;

  List<double> mb;

  List<double> dn;

  double BOLLMA;

  List<double> swing;
  List<double> supertrend;
  List<double> vwap;
  List<double> priceTyp;
  List<double> dcUp;
  List<double> dcMd;
  List<double> dcLw;
}
