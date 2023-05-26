
import 'package:meta/meta.dart';
import 'dart:convert';

class ApiResponse {
  ApiResponse(
      {@required this.status,
        @required this.error,
        this.equitySuccess,
        this.fnoSuccess,
        this.commSucess,
        this.currSuccess,
        this.algoSuccess,
        this.basketSuccess});

  final int status;
  final String error;
  final EquitySuccess equitySuccess;
  final FnoSuccess fnoSuccess;
  final CommSucess commSucess;
  final CurrSuccess currSuccess;
  final AlgoSuccess algoSuccess;
  final List<BasketSuccess> basketSuccess;

  factory ApiResponse.fromEquityRawJson(String str) =>
      ApiResponse.fromEquityJson(json.decode(str));

  factory ApiResponse.fromFnoRawJson(String str) =>
      ApiResponse.fromFnoJson(json.decode(str));

  factory ApiResponse.fromCommRawJson(String str) =>
      ApiResponse.fromCommJson(json.decode(str));

  factory ApiResponse.fromCurrRawJson(String str) =>
      ApiResponse.fromCurrJson(json.decode(str));

  factory ApiResponse.fromAlgoRawJson(String str) =>
      ApiResponse.fromAlgoJson(json.decode(str));

  factory ApiResponse.fromBasketRawJson(String str) =>
      ApiResponse.fromBasketJson(json.decode(str));

  factory ApiResponse.fromEquityJson(Map<String, dynamic> json) => ApiResponse(
    status: json['Status'],
    error: json['Error'],
    equitySuccess: EquitySuccess.fromJson(json['Success']),
  );

  factory ApiResponse.fromFnoJson(Map<String, dynamic> json) => ApiResponse(
    status: json['Status'],
    error: json['Error'],
    fnoSuccess: FnoSuccess.fromJson(json['Success']),
  );

  factory ApiResponse.fromCommJson(Map<String, dynamic> json) => ApiResponse(
    status: json['Status'],
    error: json['Error'],
    commSucess: CommSucess.fromJson(json['Success']),
  );

  factory ApiResponse.fromCurrJson(Map<String, dynamic> json) => ApiResponse(
    status: json['Status'],
    error: json['Error'],
    currSuccess: CurrSuccess.fromJson(json['Success']),
  );

  factory ApiResponse.fromAlgoJson(Map<String, dynamic> json) => ApiResponse(
      status: json['StatusCode'],
      error: json['Error'],
      algoSuccess: AlgoSuccess.fromJson(json["Data"]));

  factory ApiResponse.fromBasketJson(Map<String, dynamic> json) => ApiResponse(
    status: json['Status'],
    error: json['Error'],
    basketSuccess: json['Success'] == null ? null : List<BasketSuccess>.from(json["Success"].map((x) => BasketSuccess.fromJson(x))),
  );

  factory ApiResponse.equityErrorResponse() => ApiResponse(
    status: 500,
    error: 'Could not retrieve data',
    equitySuccess: EquitySuccess(
      message: 'Could not retrieve data',
      indicator: '-1',
      limits: 0.0,
      showPopup: false,
      showEdis: false,
      dpId: '',
      clientId: '',
      isin: '',
      mandateQty: '',
      mandateRef: '',
      tradeValue: 0.0,
    ),
  );

  factory ApiResponse.fnoErrorResponse() => ApiResponse(
    status: 500,
    error: 'Could not retrieve data',
    fnoSuccess: FnoSuccess(
      message: 'Could not retrieve data',
      orderReference: '-1',
      indicator: '-1',
      limits: 0.0,
      showPopup: false,
    ),
  );

  factory ApiResponse.commoErrorResponse() => ApiResponse(
    status: 500,
    error: 'Could not retrieve data',
    commSucess: CommSucess(
      message: 'Could not retrieve data',
      orderReference: '-1',
      indicator: '-1',
      limits: 0.0,
      showPopup: false,
    ),
  );

  factory ApiResponse.currErrorResponse() => ApiResponse(
    status: 500,
    error: 'Could not retrieve data',
    currSuccess: CurrSuccess(
      message: 'Could not retrieve data',
      orderReference: '-1',
      indicator: '-1',
      limits: 0.0,
      showPopup: false,
    ),
  );

  factory ApiResponse.algoErrorResponse() => ApiResponse(
    status: 500,
    error: 'Could not retrieve data',
    algoSuccess: AlgoSuccess(),
  );

  factory ApiResponse.basketErrorResponse() => ApiResponse(
    status: 500,
    error: 'Could not retrieve data',
    basketSuccess: null,
  );

}

// To parse this JSON data, do
//
//     final algoSuccess = algoSuccessFromJson(jsonString);

// AlgoSuccess algoSuccessFromJson(String str) =>
//     AlgoSuccess.fromJson(json.decode(str));
//
// String algoSuccessToJson(AlgoSuccess data) => json.encode(data.toJson());

class AlgoSuccess {
  AlgoSuccess({this.instId, this.message, this.indicator});

  int instId;
  String message;
  final String indicator;

  factory AlgoSuccess.fromJson(Map<String, dynamic> json) => AlgoSuccess(
      instId: json["InstID"], message: json["Message"], indicator: "0");

  Map<String, dynamic> toJson() => {
    "InstID": instId,
    "Message": message,
  };
}

class Data {
  Data({
    this.instId,
    this.message,
  });

  int instId;
  String message;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    instId: json["InstID"],
    message: json["Message"],
  );

  Map<String, dynamic> toJson() => {
    "InstID": instId,
    "Message": message,
  };
}

class EquitySuccess {
  EquitySuccess({
    @required this.message,
    @required this.indicator,
    @required this.tradeValue,
    @required this.limits,
    @required this.showPopup,
    @required this.showEdis,
    @required this.dpId,
    @required this.clientId,
    @required this.isin,
    @required this.mandateQty,
    @required this.mandateRef,
  });

  final String message;
  final String indicator;
  final double tradeValue;
  final double limits;
  final bool showEdis;
  final bool showPopup;
  final String dpId, clientId, isin, mandateQty, mandateRef;

  factory EquitySuccess.fromRawJson(String str) =>
      EquitySuccess.fromJson(json.decode(str));

  factory EquitySuccess.fromJson(Map<String, dynamic> json) {
    if (json == null)
      return EquitySuccess(
        message: '',
        indicator: '',
        tradeValue: 0.0,
        limits: 0.0,
        showPopup: false,
        showEdis: false,
        dpId: '',
        clientId: '',
        isin: '',
        mandateQty: '',
        mandateRef: '',
      );
    else
      return EquitySuccess(
        message: json['Message'] ?? '',
        indicator: json['Indicator'] ?? '',
        tradeValue: double.tryParse(json['TradeValue'] ?? '') ?? 0.0,
        limits: double.tryParse(json['Limits'] ?? '') ?? 0.0,
        showPopup: (json['Popupflg'] ?? '') == 'Y' ? true : false,
        showEdis: (json['edis_flg'] ?? '') == 'Y' ? true : false,
        dpId: json['DPID'] ?? '',
        clientId: json['ClientID'] ?? '',
        isin: json['ISIN_Number'] ?? '',
        mandateQty: json['mandate_qty'] ?? '',
        mandateRef: json['mandate_refrence'] ?? '',
      );
  }
}

class FnoSuccess {
  FnoSuccess({
    @required this.orderReference,
    @required this.message,
    @required this.limits,
    @required this.showPopup,
    @required this.indicator,
  });

  final String message;
  final String orderReference;
  final String indicator;
  final double limits;
  final bool showPopup;

  factory FnoSuccess.fromRawJson(String str) =>
      FnoSuccess.fromJson(json.decode(str));

  factory FnoSuccess.fromJson(Map<String, dynamic> json) {
    if (json == null)
      return FnoSuccess(
        message: '',
        orderReference: '',
        indicator: '-1',
        limits: 0.0,
        showPopup: false,
      );
    else
      return FnoSuccess(
        message: json['message'] ?? '',
        orderReference: json['order_reference'] ?? '',
        limits: double.tryParse(json['Limits'] ?? '') ?? 0.0,
        showPopup: (json['Popupflg'] ?? '') == 'Y' ? true : false,
        indicator: json['Indicator'] ?? '',
      );
  }
}

class CommSucess {
  CommSucess({
    @required this.orderReference,
    @required this.message,
    @required this.limits,
    @required this.showPopup,
    @required this.indicator,
  });

  final String message;
  final String orderReference;
  final String indicator;
  final double limits;
  final bool showPopup;

  factory CommSucess.fromRawJson(String str) =>
      CommSucess.fromJson(json.decode(str));

  factory CommSucess.fromJson(Map<String, dynamic> json) {
    if (json == null)
      return CommSucess(
        message: '',
        orderReference: '',
        indicator: '-1',
        limits: 0.0,
        showPopup: false,
      );
    else
      return CommSucess(
        message: json['message'] ?? '',
        orderReference: json['order_reference'] ?? '',
        limits: double.tryParse(json['Limits'] ?? '') ?? 0.0,
        showPopup: (json['Popupflg'] ?? '') == 'Y' ? true : false,
        indicator: json['Indicator'] ?? '',
      );
  }
}

class CurrSuccess {
  CurrSuccess({
    @required this.orderReference,
    @required this.message,
    @required this.limits,
    @required this.showPopup,
    @required this.indicator,
    @required this.baseOrdervalue,
    @required this.rate,
  });

  final String message;
  final String orderReference;
  final String indicator;
  final double limits;
  final bool showPopup;
  final double baseOrdervalue;
  final double rate;

  factory CurrSuccess.fromRawJson(String str) =>
      CurrSuccess.fromJson(json.decode(str));

  factory CurrSuccess.fromJson(Map<String, dynamic> json) {
    if (json == null)
      return CurrSuccess(
          message: '',
          orderReference: '',
          indicator: '-1',
          limits: 0.0,
          showPopup: false,
          baseOrdervalue: 0.0,
          rate: 0.0);
    else
      return CurrSuccess(
          message: json['msg'] ?? '',
          orderReference: json['ordr_rfrnc'] ?? '',
          limits: double.tryParse(json['Limits'] ?? '') ?? 0.0,
          showPopup: (json['dlvry_allwd'] ?? '') == 'Y' ? true : false,
          indicator: json['action_id'] ?? '',
          baseOrdervalue : double.tryParse(json['base_ord_val'] ?? '') ?? 0.0,
          rate : double.tryParse(json['rate'] ?? '') ?? 0.0
      );
  }
}

class BasketSuccess {
  BasketSuccess({
    this.errMessage,
    this.remarks,
    this.basketOrdOrdrRfrnc,
    this.indicator,
    this.showPopup,
  });

  String errMessage;
  dynamic remarks;
  String basketOrdOrdrRfrnc;
  String indicator;
  bool showPopup;

  factory BasketSuccess.fromJson(Map<String, dynamic> json) {
    if (json == null)
      return BasketSuccess(
        errMessage: '',
        remarks: '',
        basketOrdOrdrRfrnc: '',
        indicator: '0',
        showPopup: false,
      );
    else
      return BasketSuccess(
        errMessage: json["ErrMessage"],
        remarks: json["Remarks"] == null ? null : json["Remarks"],
        basketOrdOrdrRfrnc: json["Basket_ORD_ORDR_RFRNC"],
        indicator: '0',
        showPopup: false,
      );
  }
}
