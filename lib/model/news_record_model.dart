import '../Connection/News/structures/Reply/LiveSquakNewsRecord.dart';
import '../model/scripStaticModel.dart';
import '../util/Dataconstants.dart';
import '../util/DateUtil.dart';

class NewsRecordModel {
  final String category, companyName, description;
  final int nseCode, bseCode, date;
  ScripStaticModel staticModel;

  NewsRecordModel.init(
    this.category,
    this.companyName,
    this.description,
    this.nseCode,
    this.bseCode,
    this.date,
    this.staticModel,
  );

  factory NewsRecordModel(LiveSquakNewsRecord record) {
    ScripStaticModel model;
    if (record.nseCode.getValue() > 0)
      model =
          Dataconstants.exchData[0].getStaticModel(record.nseCode.getValue());
    else if (record.bseCode.getValue() > 0)
      model =
          Dataconstants.exchData[2].getStaticModel(record.bseCode.getValue());
    return NewsRecordModel.init(
      record.category
          .getValue()
          .padRight(record.categoryLength.getValue())
          .substring(0, record.categoryLength.getValue())
          .trim(),
      record.companyName
          .getValue()
          .padRight(record.companyNameLength.getValue())
          .substring(0, record.companyNameLength.getValue())
          .trim(),
      record.desc
          .getValue()
          .padRight(record.descLength.getValue())
          .substring(0, record.descLength.getValue())
          .trim(),
      record.nseCode.getValue(),
      record.bseCode.getValue(),
      record.date.getValue(),
      model,
    );
  }

  String get stockNewsTime {
    DateTime dt = Dataconstants.exchStartDate.add(Duration(seconds: date));
    return DateUtil.getAnyFormattedDate(dt, 'dd MMM yyyy hh:mm a');
  }

  String get newsTime {
    DateTime dt = Dataconstants.exchStartDate.add(Duration(seconds: date));
    return DateUtil.getAnyFormattedDate(dt, 'hh:mm:ss a');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is NewsRecordModel &&
        other.description == description &&
        other.category == category &&
        other.nseCode == nseCode &&
        other.date == date;
  }
}
