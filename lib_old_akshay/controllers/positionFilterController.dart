import 'package:get/get.dart';

import '../model/scrip_info_model.dart';
import 'netPositionController.dart';
// import 'todaysPostionController.dart';

class PositionFilterController extends GetxController {
  static var isLoading = false.obs,
      isPositionSearch = false.obs,
      isPositionFilter = false.obs;
  static RxInt sortVal = 0.obs, sortPrevVal = 0.obs;
  static RxList<Map<String, bool>> positionFilters = [
    {
      'All': true,
      'Equity': false,
      'Future': false,
      'Option': false,
      'Currency': false,
      'Commodity': false,
    }.obs,
    {
      'All': true,
      'CNC': false,
      'MIS': false,
      'NRML': false,
    }.obs,
    {
      'All': true,
      'Long': false,
      'Short': false,
    }.obs,
    {
      'All': true,
      'Daily': false,
      'Expiry': false,
    }.obs,
  ].obs;

  void updatePositionsBySearch([String filterText = '']) {
    isLoading.value = true;
    if (filterText != '' && filterText.isNotEmpty) {
      // TodaysPositionController.openPositionList = TodaysPositionController
      //     .openPositionFilteredList
      //     .where((element) => element.model.name
      //         .toLowerCase()
      //         .contains(filterText.toLowerCase()))
      //     .toList();
      NetPositionController.closePositionList = NetPositionController
          .closePositionFilteredList
          .where((element) => element.model.name
              .toLowerCase()
              .contains(filterText.toLowerCase()))
          .toList();
    } else {
      // TodaysPositionController.openPositionList =
      //     TodaysPositionController.openPositionFilteredList;
      NetPositionController.closePositionList =
          NetPositionController.closePositionFilteredList;
    }
    // filterSortOrderBookOrders();
    isLoading.value = false;
  }

  void filterSortPositionOrders() {
    var filteredList1;
    var filteredList2;
    isLoading.value = true;
    // updateOrdersBySearch(_orderBookSearchText);
    // TodaysPositionController.openPositionList =
    //     TodaysPositionController.openPositionFilteredList.where((element) {
    //   if (positionFilters[0]['All'] == true) return true;
    //   if (positionFilters[0]['Equity'] == true &&
    //       (element.model.exchCategory == ExchCategory.nseEquity ||
    //           element.model.exchCategory == ExchCategory.bseEquity))
    //     return true;
    //   if (positionFilters[0]['Future'] == true &&
    //       element.model.exchCategory == ExchCategory.nseFuture) return true;
    //   if (positionFilters[0]['Option'] == true &&
    //       element.model.exchCategory == ExchCategory.nseOptions) return true;
    //   if (positionFilters[0]['Currency'] == true &&
    //       element.model.exchCategory == ExchCategory.currenyFutures &&
    //       element.model.exchCategory == ExchCategory.currenyOptions)
    //     return true;
    //   if (positionFilters[0]['Commodity'] == true &&
    //       element.model.exchCategory == ExchCategory.mcxFutures &&
    //       element.model.exchCategory == ExchCategory.mcxOptions) return true;
    //   return false;
    // }).toList();
    // filteredList1 = TodaysPositionController.openPositionList;

    // TodaysPositionController.openPositionList = filteredList1.where((element) {
    //   if (positionFilters[1]['All'] == true) return true;
    //   if (positionFilters[1]['CNC'] == true && element.producttype == 'CNC')
    //     return true;
    //   if (positionFilters[1]['MIS'] == true && element.producttype == 'MIS')
    //     return true;
    //   if (positionFilters[1]['NRML'] == true && element.producttype == 'NRML')
    //     return true;
    //   return false;
    // }).toList();
    // filteredList1 = [];
    // filteredList1 = TodaysPositionController.openPositionList;

    // TodaysPositionController.openPositionList = filteredList1.where((element) {
    //   if (positionFilters[2]['All'] == true) return true;
    //   if (positionFilters[2]['Long'] == true &&
    //       int.tryParse(element.buyqty) > 0) return true;
    //   if (positionFilters[2]['Short'] == true &&
    //       int.tryParse(element.sellqty) > 0) return true;
    //   return false;
    // }).toList();
    // filteredList1 = [];

    NetPositionController.closePositionList =
        NetPositionController.closePositionFilteredList.where((element) {
      if (positionFilters[0]['All'] == true) return true;
      if (positionFilters[0]['Equity'] == true &&
          (element.model.exchCategory == ExchCategory.nseEquity ||
              element.model.exchCategory == ExchCategory.bseEquity))
        return true;
      if (positionFilters[0]['Future'] == true &&
          element.model.exchCategory == ExchCategory.nseFuture) return true;
      if (positionFilters[0]['Option'] == true &&
          element.model.exchCategory == ExchCategory.nseOptions) return true;
      if (positionFilters[0]['Currency'] == true &&
          element.model.exchCategory == ExchCategory.currenyFutures &&
          element.model.exchCategory == ExchCategory.currenyOptions)
        return true;
      if (positionFilters[0]['Commodity'] == true &&
          element.model.exchCategory == ExchCategory.mcxFutures &&
          element.model.exchCategory == ExchCategory.mcxOptions) return true;
      return false;
    }).toList();
    filteredList2 = NetPositionController.closePositionList;

    NetPositionController.closePositionList = filteredList2.where((element) {
      if (positionFilters[1]['All'] == true) return true;
      if (positionFilters[1]['CNC'] == true && element.producttype == 'CNC')
        return true;
      if (positionFilters[1]['MIS'] == true && element.producttype == 'MIS')
        return true;
      if (positionFilters[1]['NRML'] == true && element.producttype == 'NRML')
        return true;
      return false;
    }).toList();
    filteredList2 = [];
    filteredList2 = NetPositionController.closePositionList;

    NetPositionController.closePositionList = filteredList2.where((element) {
      if (positionFilters[2]['All'] == true) return true;
      if (positionFilters[2]['Long'] == true && element.buyqty != 0)
        return true;
      if (positionFilters[2]['Short'] == true && element.sellqty != 0)
        return true;
      return false;
    }).toList();
    filteredList2 = [];

    // executedList = executedFilteredList.where((element) {
    //   if(orderBookStatusFilters['All'] == true) return true;
    //   if(orderBookStatusFilters['Executed'] == true && element.status == 'complete') return true;
    //   if(orderBookStatusFilters['Rejected'] == true && element.status == 'rejected') return true;
    //   if(orderBookStatusFilters['Cancelled'] == true && element.status == 'cancelled') return true;
    //   return false;
    // }).toList();

    if (sortVal == 0) {
      // TodaysPositionController.openPositionList.sort(
      //     (a, b) => a.model.marketWatchName.compareTo(b.model.marketWatchName));
      NetPositionController.closePositionList.sort(
          (a, b) => a.model.marketWatchName.compareTo(b.model.marketWatchName));
    } else if (sortVal == 1) {
      // TodaysPositionController.openPositionList.sort(
      //     (b, a) => a.model.marketWatchName.compareTo(b.model.marketWatchName));
      NetPositionController.closePositionList.sort(
          (b, a) => a.model.marketWatchName.compareTo(b.model.marketWatchName));
    } else if (sortVal == 2) {
      // TodaysPositionController.openPositionList
      //     .sort((a, b) => a.model.prevDayClose.compareTo(b.model.prevDayClose));
      NetPositionController.closePositionList
          .sort((a, b) => a.model.prevDayClose.compareTo(b.model.prevDayClose));
    } else if (sortVal == 3) {
      // TodaysPositionController.openPositionList
      //     .sort((b, a) => a.model.prevDayClose.compareTo(b.model.prevDayClose));
      NetPositionController.closePositionList
          .sort((b, a) => a.model.prevDayClose.compareTo(b.model.prevDayClose));
    }
    isLoading.value = false;
  }

  List<Map<String, bool>> getPositionFilterMap() {
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
        'Long': true,
        'Short': true,
      },
      {
        'All': true,
        'Daily': true,
        'Expiry': true,
      },
    ];
    return _appliedFilters;
  }
}
