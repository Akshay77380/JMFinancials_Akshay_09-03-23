import 'dart:convert';

FundTransactionModel fundTransactionFromJson(String str) => FundTransactionModel.fromJson(json.decode(str));

String fundTransactionToJson(FundTransactionModel data) => json.encode(data.toJson());

class FundTransactionModel {
  FundTransactionModel({
    this.status,
    this.message,
    this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory FundTransactionModel.fromJson(Map<String, dynamic> json) => FundTransactionModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.clientCode,
    this.refNo,
    this.amount,
    this.transactionDate,
    this.status,
    this.bankName,
    this.approvedAmount,
    this.requestedAmount,
    this.approvedDate,
    this.reason,
    this.detail,
  });

  int id;
  String clientCode;
  String refNo;
  String amount;
  DateTime transactionDate;
  String status;
  String bankName;
  dynamic approvedAmount;
  String requestedAmount;
  dynamic approvedDate;
  dynamic reason;
  List<Detail> detail;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["Id"],
    clientCode: json["ClientCode"],
    refNo: json["RefNo"],
    amount: json["Amount"],
    transactionDate: DateTime.parse(json["TransactionDate"]),
    status: json["Status"],
    bankName: json["BankName"],
    approvedAmount: json["ApprovedAmount"],
    requestedAmount: json["RequestedAmount"],
    approvedDate: json["ApprovedDate"],
    reason: json["Reason"],
    detail: List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "ClientCode": clientCode,
    "RefNo": refNo,
    "Amount": amount,
    "TransactionDate": transactionDate.toIso8601String(),
    "Status": status,
    "BankName": bankName,
    "ApprovedAmount": approvedAmount,
    "RequestedAmount": requestedAmount,
    "ApprovedDate": approvedDate,
    "Reason": reason,
    "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
  };

  @override
  String toString() {
    return 'Datum{id: $id, clientCode: $clientCode, refNo: $refNo, amount: $amount, transactionDate: $transactionDate, status: $status, bankName: $bankName, approvedAmount: $approvedAmount, requestedAmount: $requestedAmount, approvedDate: $approvedDate, reason: $reason, detail: $detail}';
  }
}

class Detail {
  Detail({
    this.id,
    this.payOutId,
    this.clientCode,
    this.refNo,
    this.amount,
    this.status,
    this.bankname,
    this.transactionDate
  });

  int id;
  int payOutId;
  String clientCode = "";
  String refNo = "";
  String amount = "";
  String status = "";
  String bankname = "";
  DateTime transactionDate;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
      id: json["Id"],
      payOutId: json["PayOutId"],
      clientCode: json["ClientCode"] ?? "",
      refNo: json["RefNo"] ?? "",
      amount: json["Amount"] ?? "",
      status: json["Status"] ?? "",
      bankname: json["bankname"] ?? "",
      transactionDate: json["TransactionDate"]
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "PayOutId": payOutId,
    "ClientCode": clientCode,
    "RefNo": refNo,
    "Amount": amount,
    "Status": status,
    "bankname": bankname,
    "TransactionDate": transactionDate
  };

  @override
  String toString() {
    return 'Detail ddd{id: $id, payOutId: $payOutId, clientCode: $clientCode, refNo: $refNo, amount: $amount, status: $status, bankname: $bankname, transactionDate: $transactionDate}';
  }
}
