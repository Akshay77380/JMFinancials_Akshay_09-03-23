import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../model/existingOrderDetails.dart';
import '../model/jmModel/orderBook.dart';
import '../model/scrip_info_model.dart';
import '../util/BrokerInfo.dart';
import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';

class OrderBookController extends GetxController {
  static var isLoading = true.obs, isOrderBookSearch = false.obs;
  static var OrderBookList = OrderBookJson().obs;
  static List<orderDatum> pendingList = <orderDatum>[].obs;
  static List<orderDatum> executedList = <orderDatum>[].obs;
  static List<orderDatum> allList = <orderDatum>[].obs;
  static List<orderDatum> pendingFilteredList = <orderDatum>[];
  static List<orderDatum> executedFilteredList = <orderDatum>[];
  static var OrderBookLength = 0, pendingLength = 0.obs, executedLength = 0.obs;
  static List<String> expiryItems = ['All'].obs;
  static RxInt sortVal = 0.obs, sortPrevVal = 0.obs, cancelCount = 0.obs;
  static RxDouble todayPL = 0.00.obs;
  static String _orderBookSearchText = '';
  static RxList<Map<String, bool>> orderBookFilters = [
    {
      'All': true,
      'Equity': false,
      'Future': false,
      'Option': false,
      'Currency': false,
      'Commodity': false,
    },
    {
      'All': true,
      'CNC': false,
      'MIS': false,
      'NRML': false,
    },
    {
      'All': true,
      'Executed': false,
      'Rejected': false,
      'Cancelled': false,
    }
  ].obs;

  static RxList<Map<String, bool>> ScannersFilters = [
    {
      'All': true,
      'Equity': false,
      'Future': false,
      'Option': false,
      'Currency': false,
      'Commodity': false,
    }
  ].obs;

  @override
  void onInit() {
    // fetchOrderBook();
    super.onInit();
  }

  Future<void> fetchOrderBook() async {
    isLoading(true);
    var requestJson = {};

    http.Response response = await Dataconstants.itsClient.httpPostWithHeader(
        BrokerInfo.mainUrl + BrokerInfo.ApiVersion + "OrderBook",
        requestJson,
        Dataconstants.loginData.data.jwtToken);
    var responses = response.body.toString();
    //log("Order book data => $responses");
    try {
      var jsons = json.decode(responses);
      if (jsons['status'] == false) {
        if(jsons["emsg"].toString() != 'No Data')
        CommonFunction.showBasicToast(jsons["emsg"].toString());
      } else {
        OrderBookList.value = OrderBookFromJson(responses);
        executedList.clear();
        pendingList.clear();
        allList.clear();
        pendingFilteredList.clear();
        executedFilteredList.clear();
        for (var i = 0; i < OrderBookList.value.data.length; i++) {
          if (OrderBookList.value.data[i].status == "complete" || OrderBookList.value.data[i].status == "cancelled" || OrderBookList.value.data[i].status == "rejected") {
            if (OrderBookList.value.data[i].cancelsize != '0' && OrderBookList.value.data[i].filledshares != '0') OrderBookList.value.data[i].status = "partially executed";
            executedList.add(OrderBookList.value.data[i]);
            executedFilteredList.add(OrderBookList.value.data[i]);
            allList.add(OrderBookList.value.data[i]);
          } else {
            pendingList.add(OrderBookList.value.data[i]);
            pendingFilteredList.add(OrderBookList.value.data[i]);
            allList.add(OrderBookList.value.data[i]);
            if (OrderBookList.value.data[i].filledshares != '0') {
              executedList.add(OrderBookList.value.data[i]);
              executedFilteredList.add(OrderBookList.value.data[i]);
              allList.add(OrderBookList.value.data[i]);
            }
          }
        }
        OrderBookLength = OrderBookList.value.data.length;
        pendingLength.value = pendingList.length;
        executedLength.value = executedList.length;
        cancelCount.value = pendingList.where((element) => element.cancel == true).toList().length;
        Dataconstants.tradeBookData.fetchTradeBook();
        isLoading(false);
      }
    } catch (e) {
      var jsons = json.decode(responses);
      // CommonFunction.showBasicToast(jsons["message"].toString());
      isLoading(false);
    } finally {
      isLoading(false);
    }
    isLoading(false);
    return;
  }

  /* Getting Combined Traded Qty of that order */
  static int getCombinedTradedQty(ExistingNewOrderDetails order) {
    int tradedQty = 0;
    for (int i = 0; i < executedList.length; i++) {
      if (order.exchangeOrderId != executedList[i].exchorderid) continue;
      if (order.scripCode != executedList[i].symboltoken) continue;
      if (order.exch != executedList[i].model.exch) continue;
      tradedQty += int.tryParse(executedList[i].quantity);
    }
    return tradedQty;
  }

  void updateOrdersBySearch([String filterText = '']) {
    isLoading.value = true;
    if (filterText != '' && filterText.isNotEmpty) {
      pendingList = pendingFilteredList
          .where((element) => element.model.name
              .toLowerCase()
              .contains(filterText.toLowerCase()))
          .toList();
      executedList = executedFilteredList
          .where((element) => element.model.name
              .toLowerCase()
              .contains(filterText.toLowerCase()))
          .toList();
    } else {
      pendingList = pendingFilteredList;
      executedList = executedFilteredList;
    }
    isLoading.value = false;
  }

  List<Map<String, bool>> getOrderBookFilterMap() {
    List<Map<String, bool>> _appliedFilters = [
      {
        'All': true,
        'Equity': true,
        'Future': true,
        'Option': true,
        'Currency': true,
        'Commodity': true,
      },
      {
        'All': true,
        'CNC': true,
        'MIS': true,
        'NRML': true,
      },
      {
        'All': true,
        'Executed': true,
        'Rejected': true,
        'Cancelled': true,
      }
    ];
    return _appliedFilters;
  }

  void filterSortOrderBookOrders() {
    var filteredList1;
    var filteredList2;
    isLoading.value = true;
    pendingList = pendingFilteredList.where((element) {
      if (orderBookFilters[0]['All'] == true) return true;
      if (orderBookFilters[0]['Equity'] == true &&
          (element.model.exchCategory == ExchCategory.nseEquity ||
              element.model.exchCategory == ExchCategory.bseEquity))
        return true;
      if (orderBookFilters[0]['Future'] == true &&
          element.model.exchCategory == ExchCategory.nseFuture) return true;
      if (orderBookFilters[0]['Option'] == true &&
          element.model.exchCategory == ExchCategory.nseOptions) return true;
      if (orderBookFilters[0]['Currency'] == true &&
          element.model.exchCategory == ExchCategory.currenyFutures &&
          element.model.exchCategory == ExchCategory.currenyOptions)
        return true;
      if (orderBookFilters[0]['Commodity'] == true &&
          element.model.exchCategory == ExchCategory.mcxFutures &&
          element.model.exchCategory == ExchCategory.mcxOptions) return true;
      return false;
    }).toList();
    filteredList1 = pendingList;

    pendingList = filteredList1.where((element) {
      if (orderBookFilters[1]['All'] == true) return true;
      if (orderBookFilters[1]['CNC'] == true && element.producttype == 'CNC')
        return true;
      if (orderBookFilters[1]['MIS'] == true && element.producttype == 'MIS')
        return true;
      if (orderBookFilters[1]['NRML'] == true && element.producttype == 'NRML')
        return true;
      return false;
    }).toList();
    filteredList1 = [];

    executedList = executedFilteredList.where((element) {
      if (orderBookFilters[0]['All'] == true) return true;
      if (orderBookFilters[0]['Equity'] == true &&
          (element.model.exchCategory == ExchCategory.nseEquity ||
              element.model.exchCategory == ExchCategory.bseEquity))
        return true;
      if (orderBookFilters[0]['Future'] == true &&
          element.model.exchCategory == ExchCategory.nseFuture) return true;
      if (orderBookFilters[0]['Option'] == true &&
          element.model.exchCategory == ExchCategory.nseOptions) return true;
      if (orderBookFilters[0]['Currency'] == true &&
          element.model.exchCategory == ExchCategory.currenyFutures &&
          element.model.exchCategory == ExchCategory.currenyOptions)
        return true;
      if (orderBookFilters[0]['Commodity'] == true &&
          element.model.exchCategory == ExchCategory.mcxFutures &&
          element.model.exchCategory == ExchCategory.mcxOptions) return true;
      return false;
    }).toList();
    filteredList2 = executedList;

    executedList = filteredList2.where((element) {
      if (orderBookFilters[1]['All'] == true) return true;
      if (orderBookFilters[1]['CNC'] == true && element.producttype == 'CNC')
        return true;
      if (orderBookFilters[1]['MIS'] == true && element.producttype == 'MIS')
        return true;
      if (orderBookFilters[1]['NRML'] == true && element.producttype == 'NRML')
        return true;
      return false;
    }).toList();
    filteredList2 = [];
    filteredList2 = executedList;

    executedList = filteredList2.where((element) {
      if (orderBookFilters[2]['All'] == true) return true;
      if (orderBookFilters[2]['Executed'] == true &&
          element.status == 'complete') return true;
      if (orderBookFilters[2]['Rejected'] == true &&
          element.status == 'rejected') return true;
      if (orderBookFilters[2]['Cancelled'] == true &&
          element.status == 'cancelled') return true;
      return false;
    }).toList();
    filteredList2 = [];

    if (sortVal == 0) {
      pendingList.sort(
          (a, b) => a.model.marketWatchName.compareTo(b.model.marketWatchName));
      executedList.sort(
          (a, b) => a.model.marketWatchName.compareTo(b.model.marketWatchName));
    } else {
      pendingList.sort(
          (b, a) => a.model.marketWatchName.compareTo(b.model.marketWatchName));
      executedList.sort(
          (b, a) => a.model.marketWatchName.compareTo(b.model.marketWatchName));
    }

    isLoading.value = false;
  }
}
