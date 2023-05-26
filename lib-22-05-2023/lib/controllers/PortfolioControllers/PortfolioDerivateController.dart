import 'dart:convert';
import 'package:get/get.dart';
import '../../Connection/ISecITS/ITSClient.dart';
import '../../model/PortfolioDerivateModel.dart';
import '../../util/Dataconstants.dart';
class PortfolioDerivateController extends GetxController
{


  static var detail = PortfolioDerivateModel().obs;
  static List<TrPositionsDerivativesFifoCostDetailGetDataResult> getDetailResultListItems = <TrPositionsDerivativesFifoCostDetailGetDataResult>[].obs;
  static List<TrPositionsDerivativesFifoCostDetailGetDataResult> getDetailResultListItems1 = <TrPositionsDerivativesFifoCostDetailGetDataResult>[].obs;
  static List<TrPositionsDerivativesFifoCostDetailGetDataResult> getDetailResultListItems2 = <TrPositionsDerivativesFifoCostDetailGetDataResult>[].obs;
  static List<TrPositionsDerivativesFifoCostDetailGetDataResult> getDetailResultListItems3 = <TrPositionsDerivativesFifoCostDetailGetDataResult>[].obs;
  static var isLoading = true.obs;
  double derv_costPriceSum = 0,
      derv_longValueSum = 0,
      comm_costPriceSum = 0,
      comm_longValueSum = 0,
      curr_costPriceSum = 0;

  int dervlongQtySum = 0,comm_longQtySum = 0,curr_ShortQtySum, curr_ShortValueSum;


  // static List<TrPositionsDerivativesFifoCostDetailGetDataResult> getDetailResultListItems2 =
  //     <TrPositionsDerivativesFifoCostDetailGetDataResult>[].obs;
  //
  // static List<TrPositionsDerivativesFifoCostDetailGetDataResult> getDetailResultListItems3 =
  //     <TrPositionsDerivativesFifoCostDetailGetDataResult>[].obs;
  @override
  void onInit() {
    // getIpoRecentListing();
    super.onInit();
  }
  Future<void> getDetailResult() async {

    //   var res1;
    //   isLoading(true);
    //   String rawData = "${Dataconstants.feUserID}:${Dataconstants.authKey}";
    //   String bs64 = base64.encode(rawData.codeUnits);
    //
    //
    //   res1 = await ITSClient.httpGetDpHoldings(
    //       "https://mobilepms.jmfonline.in/TrPositionsCMDetail.svc/TrPositionsCMDetailGetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}}",
    //       bs64);
    //
    //   try {
    //
    //     detail.value = detailFromJson(res1);
    //     getDetailResultListItems.clear();
    //     getYears.clear();
    //
    //     for (var i = 0; i < detail.value.trPositionsCmDetailGetDataResult.length; i++) {
    //       getDetailResultListItems.add(detail.value.trPositionsCmDetailGetDataResult[i]);
    //       getYears.add(detail.value.trPositionsCmDetailGetDataResult[i].tradeDate.substring(0,4));
    //     }
    //
    //   } catch (e, s) {
    //     //print(e);
    //   } finally {
    //     isLoading(false);
    //   }
    //   return;
    // }
    isLoading(true);
    String rawData = "${Dataconstants.feUserID}:${Dataconstants.authKey}";
    String bs64 = base64.encode(rawData.codeUnits);

    var res1 = await ITSClient.httpGetDpHoldings(
        "https://mobilepms.jmfonline.in/TrPositionsDerivativesFIFOCostDetail.svc/TrPositionsDerivativesFIFOCostDetailGetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}",
        bs64
    );

    try {
      detail.value = portfolioDerivateModelFromJson(res1);
      // print("CommidityData list ----------->$CommidityData");
      // print("CurrencyData list ----------->$CurrencyData");
      //
      getDetailResultListItems.clear();

      for (var i = 0; i < detail.value.trPositionsDerivativesFifoCostDetailGetDataResult.length; i++)
      {
        getDetailResultListItems.add(detail.value.trPositionsDerivativesFifoCostDetailGetDataResult[i]);
      }

      List<TrPositionsDerivativesFifoCostDetailGetDataResult> derivData = detail.value.trPositionsDerivativesFifoCostDetailGetDataResult.where((element) => element.exchange == "NSE DER").toList();
      getDetailResultListItems1 = derivData;

      for (var element in getDetailResultListItems1) {
        derv_costPriceSum += element.costPrice;
        dervlongQtySum += element.longQty;
        derv_longValueSum += element.longValue;
      }
      double deriv_Margin_Used = derv_costPriceSum * dervlongQtySum;
      double deriv_MTM_PL = derv_longValueSum;
      Dataconstants.deriv_Margin_Used = deriv_Margin_Used;
      Dataconstants.deriv_MTM_PL = deriv_MTM_PL;
      print("Derivative APi Data : ${Dataconstants.deriv_MTM_PL}, and ${Dataconstants.deriv_Margin_Used}");


      List<TrPositionsDerivativesFifoCostDetailGetDataResult> CommidityData = detail.value.trPositionsDerivativesFifoCostDetailGetDataResult.where((element) => element.exchange == "MCX").toList();
      getDetailResultListItems2 = CommidityData;
      for (var element in getDetailResultListItems2) {
        comm_costPriceSum += element.costPrice;
        comm_longQtySum += element.longQty;
        comm_longValueSum += element.longValue;
      }

      double comm_MarginUsed = comm_costPriceSum * comm_longQtySum;
      double comm_MTM_PL = comm_longValueSum;
      Dataconstants.cdx_Margin_Used = comm_MarginUsed;
      Dataconstants.cdx_MTM_PL= comm_MTM_PL;
      print("Commodity APi Data : ${Dataconstants.cdx_MTM_PL}, and ${Dataconstants.cdx_Margin_Used}");

      List<TrPositionsDerivativesFifoCostDetailGetDataResult> CurrencyData = detail.value.trPositionsDerivativesFifoCostDetailGetDataResult.where((element) => element.exchange == "NSE CDX").toList();
      getDetailResultListItems3 = CurrencyData;

      for (var element in getDetailResultListItems3) {
        curr_costPriceSum += element.costPrice;
        curr_ShortQtySum += element.shortQty;
        curr_ShortValueSum += element.shortValue;
      }

      double curr_MarginUsed = curr_costPriceSum * curr_ShortQtySum;
      int curr_MTM_PL = curr_ShortValueSum;
      Dataconstants.cur_Margin_Used = curr_MarginUsed;
      Dataconstants.cur_MTM_PL = curr_MTM_PL;
      print("Currency APi Data : ${Dataconstants.cur_MTM_PL}, and ${Dataconstants.cur_Margin_Used}");

    }
    catch (e, s)
    {
      print(e);
    }
    finally
    {
      isLoading(false);
    }
  }
  // Future<void> getDetailResult2() async {
  //
  //   //   var res1;
  //   //   isLoading(true);
  //   //   String rawData = "${Dataconstants.feUserID}:${Dataconstants.authKey}";
  //   //   String bs64 = base64.encode(rawData.codeUnits);
  //   //
  //   //
  //   //   res1 = await ITSClient.httpGetDpHoldings(
  //   //       "https://mobilepms.jmfonline.in/TrPositionsCMDetail.svc/TrPositionsCMDetailGetData?EncryptedParameters=${Dataconstants.feUserID}~~*~~*~~*~~*~~1.0.0.0~~*~~${Dataconstants.feUserID}}",
  //   //       bs64);
  //   //
  //   //   try {
  //   //
  //   //     detail.value = detailFromJson(res1);
  //   //     getDetailResultListItems.clear();
  //   //     getYears.clear();
  //   //
  //   //     for (var i = 0; i < detail.value.trPositionsCmDetailGetDataResult.length; i++) {
  //   //       getDetailResultListItems.add(detail.value.trPositionsCmDetailGetDataResult[i]);
  //   //       getYears.add(detail.value.trPositionsCmDetailGetDataResult[i].tradeDate.substring(0,4));
  //   //     }
  //   //
  //   //   } catch (e, s) {
  //   //     //print(e);
  //   //   } finally {
  //   //     isLoading(false);
  //   //   }
  //   //   return;
  //   // }
  //   isLoading(true);
  //   String rawData = "14610051:${Dataconstants.authKey}";
  //   String bs64 = base64.encode(rawData.codeUnits);
  //
  //   var res1 = await ITSClient.httpGetDpHoldings(
  //       "https://mobilepms.jmfonline.in/TrPositionsDerivativesFIFOCostDetail.svc/TrPositionsDerivativesFIFOCostDetailGetData?EncryptedParameters=14610051~~*~~*~~*~~*~~1.0.0.0~~*~~14610051",
  //       bs64
  //   );
  //   try {
  //     detail2.value = PortfolioDerivateModel.fromJson(res1);
  //     // getDetailResultListItems.clear();
  //
  //     for (var i = 0; i < detail2.value.trPositionsDerivativesFifoCostDetailGetDataResult.length; i++)
  //     {
  //       getDetailResultListItems.add(detail.value.trPositionsDerivativesFifoCostDetailGetDataResult[i]);
  //       getYears.add(detail.value.trPositionsDerivativesFifoCostDetailGetDataResult[i].tradeDate.substring(0,4));
  //
  //     }
  //   } catch (e, s) {
  //     //print(e);
  //   } finally {
  //     isLoading(false);
  //   }
  //   return;
  // }
}
