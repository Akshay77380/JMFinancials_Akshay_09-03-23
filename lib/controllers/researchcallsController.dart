import 'dart:convert';
import 'dart:developer';

import 'package:mobx/mobx.dart';
import '../model/jmModel/researchCalls.dart';
import '../util/CommonFunctions.dart';
import '../util/Dataconstants.dart';
import '../util/DateUtil.dart';

part 'researchcallsController.g.dart';

class ResearchCallsModel = _ResearchCallsModelBase with _$ResearchCallsModel;

abstract class _ResearchCallsModelBase with Store {
  @observable
  ResearchCalls researchCalls = ResearchCalls();

  @observable
  String _searchText = '';

  @observable
  bool fetchingData = false;

  int lastTradingSort, lastFutureOptionSort, lastCurrencySort, lastCommoditySort, lastInvestSort = 2; //0 1-Name,2 3-Recent
  @observable
  int investmentSelectedChip = 0, tradingSelectedChip = 0, fnoSelectedChip = 0;

  @observable
  List<ResearchCallsDatum> intradayList = ObservableList<ResearchCallsDatum>(),
      intradayListBackup = ObservableList<ResearchCallsDatum>(),
      momentumList = ObservableList<ResearchCallsDatum>(),
      momentumListBackup = ObservableList<ResearchCallsDatum>(),
      largeCapList = ObservableList<ResearchCallsDatum>(),
      largeCapListBackup = ObservableList<ResearchCallsDatum>(),
      midCapList = ObservableList<ResearchCallsDatum>(),
      midCapListBackup = ObservableList<ResearchCallsDatum>(),
      smallCapList = ObservableList<ResearchCallsDatum>(),
      smallCapListBackup = ObservableList<ResearchCallsDatum>(),
      futureList = ObservableList<ResearchCallsDatum>(),
      futureListBackup = ObservableList<ResearchCallsDatum>(),
      optionList = ObservableList<ResearchCallsDatum>(),
      optionListBackup = ObservableList<ResearchCallsDatum>(),
      currencyList = ObservableList<ResearchCallsDatum>(),
      currencyListBackup = ObservableList<ResearchCallsDatum>(),
      commodityList = ObservableList<ResearchCallsDatum>(),
      commodityListBackup = ObservableList<ResearchCallsDatum>(),
      searchResearch = ObservableList<ResearchCallsDatum>(),
      filterResearch = ObservableList<ResearchCallsDatum>(),
      searchIClickToGain = ObservableList<ResearchCallsDatum>(),
      researchSearchList = ObservableList<ResearchCallsDatum>();

  @action
  void updateFetchingData(bool value) {
    fetchingData = value;
  }

  @action
  void getResearchData(var response) {
    var jsons = jsonDecode(response.body);
    if (jsons['status'] == true) {
      //log("research data ${response.body.toString()}");
      updateResearchCallsModel(jsons);
    } else if (jsons["emsg"].toString() != 'No Data') CommonFunction.showBasicToast(jsons["emsg"].toString());
  }

  @action
  void updateResearchCallsModel(Map<String, dynamic> researchData) {
    researchCalls = ResearchCalls.fromJson(researchData);

    intradayList = [];
    intradayListBackup = [];
    momentumList = [];
    momentumListBackup = [];
    largeCapList = [];
    largeCapListBackup = [];
    midCapList = [];
    midCapListBackup = [];
    smallCapList = [];
    smallCapListBackup = [];
    futureList = [];
    futureListBackup = [];
    optionList = [];
    optionListBackup = [];
    currencyList = [];
    currencyListBackup = [];
    commodityList = [];
    commodityListBackup = [];

    researchCalls.data.forEach((element) {
      /*
      * category id == 1 - Investment
      * category id == 2 - Trading
      *
      * sub category id == 3 - Intraday
      * sub category id == 4 - Momentum
      * sub category id == 4 - Large Cap
      * sub category id == 4 - Mid Cap
      * sub category id == 4 - Small Cap
      * */
      /* Trading - Intraday List */
      if (element.categoryid == '2' && element.subcategoryid == '3' && element.exchsegment.toUpperCase() == 'EQUITY') {
        /* Calculating Profit potential - logic given by Kajal*/
        element.buysell.toUpperCase() == "BUY"
            ? element.profitPotential = ((double.parse(element.targetprice) - element.model.close) / element.model.close) * 100
            : element.profitPotential = ((element.model.close - double.parse(element.targetprice)) / element.model.close) * 100;
        intradayList.add(element);
        intradayListBackup.add(element);
      }
      /* Trading - Momentum List */
      if (element.categoryid == '2' && element.subcategoryid == '4' && element.exchsegment.toUpperCase() == 'EQUITY') {
        /* Calculating Profit potential */
        element.buysell.toUpperCase() == "BUY"
            ? element.profitPotential = ((double.parse(element.targetprice) - element.model.close) / element.model.close) * 100
            : element.profitPotential = ((element.model.close - double.parse(element.targetprice)) / element.model.close) * 100;
        momentumList.add(element);
        momentumListBackup.add(element);
      }
      /* Investment - Large Cap List */
      if (element.categoryid == '1' && element.subcategoryid == '5' && element.exchsegment.toUpperCase() == 'EQUITY') {
        /* Calculating Profit potential */
        element.buysell.toUpperCase() == "BUY"
            ? element.profitPotential = ((double.parse(element.targetprice) - element.model.close) / element.model.close) * 100
            : element.profitPotential = ((element.model.close - double.parse(element.targetprice)) / element.model.close) * 100;
        largeCapList.add(element);
        largeCapListBackup.add(element);
      }
      /* Investment - Mid Cap List */
      if (element.categoryid == '1' && element.subcategoryid == '6' && element.exchsegment.toUpperCase() == 'EQUITY') {
        /* Calculating Profit potential */
        element.buysell.toUpperCase() == "BUY"
            ? element.profitPotential = ((double.parse(element.targetprice) - element.model.close) / element.model.close) * 100
            : element.profitPotential = ((element.model.close - double.parse(element.targetprice)) / element.model.close) * 100;
        midCapList.add(element);
        midCapListBackup.add(element);
      }
      /* Investment - Small Cap List */
      if (element.categoryid == '1' && element.subcategoryid == '7' && element.exchsegment.toUpperCase() == 'EQUITY') {
        /* Calculating Profit potential */
        element.buysell.toUpperCase() == "BUY"
            ? element.profitPotential = ((double.parse(element.targetprice) - element.model.close) / element.model.close) * 100
            : element.profitPotential = ((element.model.close - double.parse(element.targetprice)) / element.model.close) * 100;
        smallCapList.add(element);
        smallCapListBackup.add(element);
      }
      /* Future & Options - Future List */
      if (element.exchsegment.toUpperCase() == 'FUTIDX' || element.exchsegment.toUpperCase() == 'FUTSTK') {
        /* Calculating Profit potential */
        element.buysell.toUpperCase() == "BUY"
            ? element.profitPotential = ((double.parse(element.targetprice) - element.model.close) * element.model.minimumLotQty)
            : element.profitPotential = ((element.model.close - double.parse(element.targetprice)) * element.model.minimumLotQty);
        futureList.add(element);
        futureListBackup.add(element);
      }
      /* Future & Options - Options List */
      if (element.exchsegment.toUpperCase() == 'OPIDX' || element.exchsegment.toUpperCase() == 'OPTSTK') {
        /* Calculating Profit potential */
        element.buysell.toUpperCase() == "BUY"
            ? element.profitPotential = ((double.parse(element.targetprice) - element.model.close) * element.model.minimumLotQty)
            : element.profitPotential = ((element.model.close - double.parse(element.targetprice)) * element.model.minimumLotQty);
        optionList.add(element);
        optionListBackup.add(element);
      }
      /* Currency - Currency Future & Option List */
      if (element.exchsegment.toUpperCase() == 'FUTCUR') {
        /* Calculating Profit potential */
        element.buysell.toUpperCase() == "BUY"
            ? element.profitPotential = ((double.parse(element.targetprice) - element.model.close) * element.model.minimumLotQty * 1000)
            : element.profitPotential = ((element.model.close - double.parse(element.targetprice)) * element.model.minimumLotQty * 1000);
        currencyList.add(element);
        currencyListBackup.add(element);
      }
      /* Commodity - Commodity Future & Option List */
      if (element.exchsegment.toUpperCase() == 'FUTCOMM') {
        /* Calculating Profit potential */
        element.buysell.toUpperCase() == "BUY"
            ? element.profitPotential = ((double.parse(element.targetprice) - element.model.close) * element.model.minimumLotQty)
            : element.profitPotential = ((element.model.close - double.parse(element.targetprice)) * element.model.minimumLotQty);
        commodityList.add(element);
        commodityListBackup.add(element);
      }
    });
    filterResearchTrading(Dataconstants.lastTradingFilter);
    filterResearchInvestment(Dataconstants.lastInvestFilter);
    filterResearchFutureOption(Dataconstants.lastFnoFilter);
    filterResearchCurrency(Dataconstants.lastCurrencyFilter);
    filterResearchCommodity(Dataconstants.lastCommodityFilter);
    if (lastTradingSort == 1) sortTradingByProfitPotential(false);
    if (lastInvestSort == 1) sortInvestmentByProfitPotential(false);
    if (lastFutureOptionSort == 1) sortFutureOptionByProfitPotential(false);
    if (lastCurrencySort == 1) sortCurrencyByProfitPotential(false);
    if (lastCommoditySort == 1) sortCommodityByProfitPotential(false);
  }

  /* Searching */

  @action
  void searchResearchTrading([String filterText = '']) {
    _searchText = filterText;

    if (filterText.isNotEmpty) {
      searchResearch =
          ObservableList.of(intradayListBackup.where((value) => value.header.toLowerCase().contains(filterText.toLowerCase()) || value.model.desc.toLowerCase().contains(filterText.toLowerCase())));
      intradayList = searchResearch;

      searchResearch =
          ObservableList.of(momentumListBackup.where((value) => value.header.toLowerCase().contains(filterText.toLowerCase()) || value.model.desc.toLowerCase().contains(filterText.toLowerCase())));
      momentumList = searchResearch;

      /* Checking if intraday tab contains data else switch to momentum tab if it contains searched data and vise versa */
      if (intradayList.isEmpty && momentumList.isEmpty)
        return;
      else if (intradayList.isEmpty && tradingSelectedChip == 0) {
        if (momentumList.isNotEmpty)
          tradingSelectedChip = 1;
        else
          return;
      }
      if (momentumList.isEmpty && tradingSelectedChip == 1) {
        if (intradayList.isNotEmpty)
          tradingSelectedChip = 0;
        else
          return;
      } else
        return;
    } else {
      searchIClickToGain = ObservableList.of(researchSearchList);
      searchResearch = intradayListBackup;
      intradayList = searchResearch;

      searchIClickToGain = ObservableList.of(researchSearchList);
      searchResearch = momentumListBackup;
      momentumList = searchResearch;
    }
  }

  @action
  void searchResearchInvest([String filterText = '']) {
    _searchText = filterText;
    if (filterText.isNotEmpty) {
      searchResearch =
          ObservableList.of(largeCapListBackup.where((value) => value.header.toLowerCase().contains(filterText.toLowerCase()) || value.model.desc.toLowerCase().contains(filterText.toLowerCase())));
      largeCapList = searchResearch;
      searchResearch =
          ObservableList.of(midCapListBackup.where((value) => value.header.toLowerCase().contains(filterText.toLowerCase()) || value.model.desc.toLowerCase().contains(filterText.toLowerCase())));
      midCapList = searchResearch;
      searchResearch =
          ObservableList.of(smallCapListBackup.where((value) => value.header.toLowerCase().contains(filterText.toLowerCase()) || value.model.desc.toLowerCase().contains(filterText.toLowerCase())));
      smallCapList = searchResearch;

      if (largeCapList.isEmpty && midCapList.isEmpty && smallCapList.isEmpty)
        return;
      else if (largeCapList.isEmpty && investmentSelectedChip == 0) {
        if (midCapList.isNotEmpty)
          investmentSelectedChip = 1;
        else if (smallCapList.isNotEmpty)
          investmentSelectedChip = 2;
        else
          return;
      } else if (midCapList.isEmpty && investmentSelectedChip == 1) {
        if (largeCapList.isNotEmpty)
          investmentSelectedChip = 0;
        else if (smallCapList.isNotEmpty)
          investmentSelectedChip = 2;
        else
          return;
      } else if (smallCapList.isEmpty && investmentSelectedChip == 2) {
        if (largeCapList.isNotEmpty)
          investmentSelectedChip = 0;
        else if (midCapList.isNotEmpty)
          investmentSelectedChip = 1;
        else
          return;
      } else
        return;
    } else {
      searchIClickToGain = ObservableList.of(researchSearchList);
      searchResearch = largeCapListBackup;
      largeCapList = searchResearch;

      searchIClickToGain = ObservableList.of(researchSearchList);
      searchResearch = midCapListBackup;
      midCapList = searchResearch;

      searchIClickToGain = ObservableList.of(researchSearchList);
      searchResearch = smallCapListBackup;
      smallCapList = searchResearch;
    }
  }

  @action
  void searchResearchFnO([String filterText = '']) {
    _searchText = filterText;

    if (filterText.isNotEmpty) {
      searchResearch =
          ObservableList.of(futureListBackup.where((value) => value.header.toLowerCase().contains(filterText.toLowerCase()) || value.model.desc.toLowerCase().contains(filterText.toLowerCase())));
      futureList = searchResearch;

      searchResearch =
          ObservableList.of(optionListBackup.where((value) => value.header.toLowerCase().contains(filterText.toLowerCase()) || value.model.desc.toLowerCase().contains(filterText.toLowerCase())));
      optionList = searchResearch;

      /* Checking if futures tab contains data else switch to options tab if it contains searched data and vise versa */
      if (futureList.isEmpty && optionList.isEmpty)
        return;
      else if (futureList.isEmpty && fnoSelectedChip == 0) {
        if (optionList.isNotEmpty)
          fnoSelectedChip = 1;
        else
          return;
      }
      if (optionList.isEmpty && fnoSelectedChip == 1) {
        if (futureList.isNotEmpty)
          fnoSelectedChip = 0;
        else
          return;
      } else
        return;
    } else {
      searchIClickToGain = ObservableList.of(researchSearchList);
      searchResearch = futureListBackup;
      futureList = searchResearch;

      searchIClickToGain = ObservableList.of(researchSearchList);
      searchResearch = optionListBackup;
      optionList = searchResearch;
    }
  }

  @action
  void searchResearchCurrency([String filterText = '']) {
    _searchText = filterText;

    if (filterText.isNotEmpty) {
      searchResearch =
          ObservableList.of(currencyListBackup.where((value) => value.header.toLowerCase().contains(filterText.toLowerCase()) || value.model.desc.toLowerCase().contains(filterText.toLowerCase())));
      currencyList = searchResearch;
    } else {
      searchResearch = currencyListBackup;
      currencyList = searchResearch;
      searchIClickToGain = ObservableList.of(researchSearchList);
    }
  }

  @action
  void searchResearchCommodity([String filterText = '']) {
    _searchText = filterText;

    if (filterText.isNotEmpty) {
      searchResearch =
          ObservableList.of(commodityListBackup.where((value) => value.header.toLowerCase().contains(filterText.toLowerCase()) || value.model.desc.toLowerCase().contains(filterText.toLowerCase())));
      commodityList = searchResearch;
    } else {
      searchResearch = commodityListBackup;
      commodityList = searchResearch;
      searchIClickToGain = ObservableList.of(researchSearchList);
    }
  }

  /* Filtering */

  @action
  filterResearchTrading([String filterText = '']) {
    switch (filterText) {
      case 'All':
        intradayList = intradayListBackup;
        momentumList = momentumListBackup;
        break;
      case 'Watchlist':
        filterResearch = ObservableList.of(intradayListBackup.where((value) {
          return Dataconstants.marketWatchListeners[0].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[1].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[2].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[3].watchList.any((element) => element.exchCode == value.model.exchCode);
        }));
        intradayList = filterResearch;
        filterResearch = ObservableList.of(momentumListBackup.where((value) {
          return Dataconstants.marketWatchListeners[0].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[1].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[2].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[3].watchList.any((element) => element.exchCode == value.model.exchCode);
        }));
        momentumList = filterResearch;
        break;
      // TODO : Portfolio filtering
      // case 'Portfolio':
      //   filterResearch = ObservableList.of(intradayListBackup.where((value) {
      //     return Dataconstants.dematReport.filteredDematHoldings.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.positionReport.filteredOpenPositions.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioEquityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioFnoReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCommodityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCurrencyReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc);
      //   }));
      //   intradayList = filterResearch;
      //   filterResearch = ObservableList.of(momentumListBackup.where((value) {
      //     return Dataconstants.dematReport.filteredDematHoldings.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.positionReport.filteredOpenPositions.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioEquityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioFnoReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCommodityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc);
      //   }));
      //   momentumList = filterResearch;
      //   break;
      case 'Nifty':
        Dataconstants.predefinedMarketWatchListener
            .addToPredefinedWatchListBulk(
          values: CommonFunction.getMembers(
            "P",
            "NFTY",
          ),
          grType: "P",
          grCode: "NFTY",
          grName: "Nifty 50",
        )
            .then((value) {
          filterResearch = ObservableList.of(intradayListBackup.where((value) => Dataconstants.indexNifty50.any((element) => element.exchCode == value.model.exchCode)));
          intradayList = filterResearch;
          filterResearch = ObservableList.of(momentumListBackup.where((value) => Dataconstants.indexNifty50.any((element) => element.exchCode == value.model.exchCode)));
          momentumList = filterResearch;
        });
        break;
      case 'Bank Nifty':
        Dataconstants.predefinedMarketWatchListener
            .addToPredefinedWatchListBulk(
          values: CommonFunction.getMembers(
            "P",
            "P0007",
          ),
          grType: "P",
          grCode: "P0007",
          grName: "Bank Nifty",
        )
            .then((value) {
          filterResearch = ObservableList.of(intradayListBackup.where((value) => Dataconstants.indexBankNifty.any((element) => element.exchCode == value.model.exchCode)));
          intradayList = filterResearch;
          filterResearch = ObservableList.of(momentumListBackup.where((value) => Dataconstants.indexBankNifty.any((element) => element.exchCode == value.model.exchCode)));
          momentumList = filterResearch;
        });
        break;
    }
  }

  @action
  filterResearchInvestment([String filterText = '']) {
    switch (filterText) {
      case 'All':
        largeCapList = largeCapListBackup;
        midCapList = midCapListBackup;
        smallCapList = smallCapListBackup;
        break;
      case 'Watchlist':
        filterResearch = ObservableList.of(largeCapListBackup.where((value) {
          return Dataconstants.marketWatchListeners[0].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[1].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[2].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[3].watchList.any((element) => element.exchCode == value.model.exchCode);
        }));
        largeCapList = filterResearch;
        filterResearch = ObservableList.of(midCapListBackup.where((value) {
          return Dataconstants.marketWatchListeners[0].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[1].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[2].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[3].watchList.any((element) => element.exchCode == value.model.exchCode);
        }));
        midCapList = filterResearch;
        filterResearch = ObservableList.of(smallCapListBackup.where((value) {
          return Dataconstants.marketWatchListeners[0].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[1].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[2].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[3].watchList.any((element) => element.exchCode == value.model.exchCode);
        }));
        smallCapList = filterResearch;
        break;
    // TODO : Portfolio filtering
      // case 'Portfolio':
      //   filterResearch = ObservableList.of(oneClickInvestLargeListBackup.where((value) {
      //     return Dataconstants.dematReport.filteredDematHoldings.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.positionReport.filteredOpenPositions.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioEquityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioFnoReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCommodityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCurrencyReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc);
      //   }));
      //   oneClickInvestLargeList = filterResearch;
      //   filterResearch = ObservableList.of(oneClickInvestMildListBackup.where((value) {
      //     return Dataconstants.dematReport.filteredDematHoldings.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.positionReport.filteredOpenPositions.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioEquityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioFnoReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCommodityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc);
      //   }));
      //   oneClickInvestMildList = filterResearch;
      //   filterResearch = ObservableList.of(oneClickInvestSmallListBackup.where((value) {
      //     return Dataconstants.dematReport.filteredDematHoldings.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.positionReport.filteredOpenPositions.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioEquityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioFnoReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCommodityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc);
      //   }));
      //   oneClickInvestSmallList = filterResearch;
      //   break;
      case 'Nifty':
        Dataconstants.predefinedMarketWatchListener
            .addToPredefinedWatchListBulk(
          values: CommonFunction.getMembers(
            "P",
            "NFTY",
          ),
          grType: "P",
          grCode: "NFTY",
          grName: "Nifty 50",
        )
            .then((value) {
          filterResearch = ObservableList.of(largeCapListBackup.where((value) => Dataconstants.indexNifty50.any((element) => element.exchCode == value.model.exchCode)));
          largeCapList = filterResearch;
          filterResearch = ObservableList.of(midCapListBackup.where((value) => Dataconstants.indexNifty50.any((element) => element.exchCode == value.model.exchCode)));
          midCapList = filterResearch;
          filterResearch = ObservableList.of(smallCapListBackup.where((value) => Dataconstants.indexNifty50.any((element) => element.exchCode == value.model.exchCode)));
          smallCapList = filterResearch;
        });
        break;
      case 'Bank Nifty':
        Dataconstants.predefinedMarketWatchListener
            .addToPredefinedWatchListBulk(
          values: CommonFunction.getMembers(
            "P",
            "P0007",
          ),
          grType: "P",
          grCode: "P0007",
          grName: "Bank Nifty",
        )
            .then((value) {
          filterResearch = ObservableList.of(largeCapListBackup.where((value) => Dataconstants.indexBankNifty.any((element) => element.exchCode == value.model.exchCode)));
          largeCapList = filterResearch;
          filterResearch = ObservableList.of(midCapListBackup.where((value) => Dataconstants.indexBankNifty.any((element) => element.exchCode == value.model.exchCode)));
          midCapList = filterResearch;
          filterResearch = ObservableList.of(smallCapListBackup.where((value) => Dataconstants.indexBankNifty.any((element) => element.exchCode == value.model.exchCode)));
          smallCapList = filterResearch;
        });
        break;
    }
  }

  @action
  filterResearchFutureOption([String filterText = '']) {
    switch (filterText) {
      case 'All':
        futureList = futureListBackup;
        optionList = optionListBackup;
        break;
      case 'Watchlist':
        filterResearch = ObservableList.of(futureListBackup.where((value) {
          return Dataconstants.marketWatchListeners[0].watchList.any((element) => element.exchCode == value.model.exchCode ) ||
              Dataconstants.marketWatchListeners[1].watchList.any((element) => element.exchCode == value.model.exchCode ) ||
              Dataconstants.marketWatchListeners[2].watchList.any((element) => element.exchCode == value.model.exchCode ) ||
              Dataconstants.marketWatchListeners[3].watchList.any((element) => element.exchCode == value.model.exchCode );
        }));
        futureList = filterResearch;
        filterResearch = ObservableList.of(optionListBackup.where((value) {
          return Dataconstants.marketWatchListeners[0].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[1].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[2].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[3].watchList.any((element) => element.exchCode == value.model.exchCode);
        }));
        optionList = filterResearch;
        break;
    // TODO : Portfolio filtering
      // case 'Portfolio':
      //   filterResearch = ObservableList.of(futureListBackup.where((value) {
      //     return Dataconstants.dematReport.filteredDematHoldings.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.positionReport.filteredOpenPositions.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioEquityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioFnoReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCommodityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCurrencyReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc);
      //   }));
      //   futureList = filterResearch;
      //   filterResearch = ObservableList.of(optionListBackup.where((value) {
      //     return Dataconstants.dematReport.filteredDematHoldings.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.positionReport.filteredOpenPositions.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioEquityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioFnoReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCommodityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc);
      //   }));
      //   optionList = filterResearch;
      //   break;
      case 'Nifty':
        Dataconstants.predefinedMarketWatchListener
            .addToPredefinedWatchListBulk(
          values: CommonFunction.getMembers(
            "P",
            "NFTY",
          ),
          grType: "P",
          grCode: "NFTY",
          grName: "Nifty 50",
        )
            .then((value) {
          filterResearch = ObservableList.of(futureListBackup.where((value) => Dataconstants.indexNifty50.any((element) => element.exchCode == value.model.exchCode)));
          futureList = filterResearch;
          filterResearch = futureListBackup.where((element) => element.model.desc.contains("NIFTY")).toList();
          futureList.addAll(filterResearch);
          filterResearch = ObservableList.of(optionListBackup.where((value) => Dataconstants.indexNifty50.any((element) => element.exchCode == value.model.exchCode)));
          optionList = filterResearch;
          filterResearch = optionListBackup.where((element) => element.model.desc.contains("NIFTY")).toList();
          optionList.addAll(filterResearch);
        });
        break;
      case 'Bank Nifty':
        Dataconstants.predefinedMarketWatchListener
            .addToPredefinedWatchListBulk(
          values: CommonFunction.getMembers(
            "P",
            "P0007",
          ),
          grType: "P",
          grCode: "P0007",
          grName: "Bank Nifty",
        )
            .then((value) {
          filterResearch = ObservableList.of(futureListBackup.where((value) => Dataconstants.indexBankNifty.any((element) => element.exchCode == value.model.exchCode)));
          futureList = filterResearch;
          filterResearch = futureListBackup.where((element) => element.model.desc.contains("NIFTY BANK")).toList();
          futureList.addAll(filterResearch);
          filterResearch = ObservableList.of(optionListBackup.where((value) => Dataconstants.indexBankNifty.any((element) => element.exchCode == value.model.exchCode)));
          optionList = filterResearch;
          filterResearch = optionListBackup.where((element) => element.model.desc.contains("NIFTY BANK")).toList();
          optionList.addAll(filterResearch);
        });
        break;
    }
  }

  @action
  filterResearchCurrency([String filterText = '']) {
    switch (filterText) {
      case 'All':
        currencyList = currencyListBackup;
        break;
      case 'Watchlist':
        filterResearch = ObservableList.of(currencyListBackup.where((value) {
          return Dataconstants.marketWatchListeners[0].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[1].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[2].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[3].watchList.any((element) => element.exchCode == value.model.exchCode);
        }));
        currencyList = filterResearch;
        break;
    // TODO : Portfolio filtering
      // case 'Portfolio':
      //   filterResearch = ObservableList.of(currencyListBackup.where((value) {
      //     return Dataconstants.dematReport.filteredDematHoldings.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.positionReport.filteredOpenPositions.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioEquityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioFnoReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCommodityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCurrencyReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc);
      //   }));
      //   currencyList = filterResearch;
      //   break;
      case 'Nifty':
        Dataconstants.predefinedMarketWatchListener
            .addToPredefinedWatchListBulk(
          values: CommonFunction.getMembers(
            "P",
            "NFTY",
          ),
          grType: "P",
          grCode: "NFTY",
          grName: "Nifty 50",
        )
            .then((value) {
          filterResearch = ObservableList.of(currencyListBackup.where((value) => Dataconstants.indexNifty50.any((element) => element.exchCode == value.model.exchCode)));
          currencyList = filterResearch;
        });
        break;
      case 'Bank Nifty':
        Dataconstants.predefinedMarketWatchListener
            .addToPredefinedWatchListBulk(
          values: CommonFunction.getMembers(
            "P",
            "P0007",
          ),
          grType: "P",
          grCode: "P0007",
          grName: "Bank Nifty",
        )
            .then((value) {
          filterResearch = ObservableList.of(currencyListBackup.where((value) => Dataconstants.indexBankNifty.any((element) => element.exchCode == value.model.exchCode)));
          currencyList = filterResearch;
        });
        break;
    }
  }

  @action
  filterResearchCommodity([String filterText = '']) {
    switch (filterText) {
      case 'All':
        commodityList = commodityListBackup;
        break;
      case 'Watchlist':
        filterResearch = ObservableList.of(commodityListBackup.where((value) {
          return Dataconstants.marketWatchListeners[0].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[1].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[2].watchList.any((element) => element.exchCode == value.model.exchCode) ||
              Dataconstants.marketWatchListeners[3].watchList.any((element) => element.exchCode == value.model.exchCode);
        }));
        commodityList = filterResearch;
        break;
    // TODO : Portfolio filtering
      // case 'Portfolio':
      //   filterResearch = ObservableList.of(commodityListBackup.where((value) {
      //     return Dataconstants.dematReport.filteredDematHoldings.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.positionReport.filteredOpenPositions.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioEquityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioFnoReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCommodityReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc) ||
      //         Dataconstants.portfolioCurrencyReport.filteredPortfolios.any((element) => element.model.isecName == value.model.isecName && element.model.desc == value.model.desc);
      //   }));
      //   commodityList = filterResearch;
      //   break;
      case 'Nifty':
        Dataconstants.predefinedMarketWatchListener
            .addToPredefinedWatchListBulk(
          values: CommonFunction.getMembers(
            "P",
            "NFTY",
          ),
          grType: "P",
          grCode: "NFTY",
          grName: "Nifty 50",
        )
            .then((value) {
          filterResearch = ObservableList.of(commodityListBackup.where((value) => Dataconstants.indexNifty50.any((element) => element.exchCode == value.model.exchCode)));
          commodityList = filterResearch;
        });
        break;
      case 'Bank Nifty':
        Dataconstants.predefinedMarketWatchListener
            .addToPredefinedWatchListBulk(
          values: CommonFunction.getMembers(
            "P",
            "P0007",
          ),
          grType: "P",
          grCode: "P0007",
          grName: "Bank Nifty",
        )
            .then((value) {
          filterResearch = ObservableList.of(commodityListBackup.where((value) => Dataconstants.indexBankNifty.any((element) => element.exchCode == value.model.exchCode)));
          commodityList = filterResearch;
        });
        break;
    }
  }

  /* Sorting */

  @action
  void sortTradingByProfitPotential(bool isDescending) {
    // if (isDescending) {
    lastTradingSort = 1;
    intradayList.sort((b, a) => a.profitPotential.compareTo(b.profitPotential));
    momentumList.sort((b, a) => a.profitPotential.compareTo(b.profitPotential));
    // } else {
    //   lastTradingSort = 0;
    //   intradayList
    //       .sort((a, b) => a.profitPotential.compareTo(b.profitPotential));
    //   momentumList
    //       .sort((a, b) => a.profitPotential.compareTo(b.profitPotential));
    // }
  }

  @action
  void sortTradingByRecent() {
    lastTradingSort = 2;
    intradayList.sort((b, a) => DateUtil.getDateTimeFromString(a.insertiontime, 'dd/MM/yyyy hh:mm:ss a').compareTo(DateUtil.getDateTimeFromString(b.insertiontime, 'dd/MM/yyyy hh:mm:ss a')));
    momentumList.sort((b, a) => DateUtil.getDateTimeFromString(a.insertiontime, 'dd/MM/yyyy hh:mm:ss a').compareTo(DateUtil.getDateTimeFromString(b.insertiontime, 'dd/MM/yyyy hh:mm:ss a')));
  }

  @action
  void sortInvestmentByProfitPotential(bool isDescending) {
    // if (isDescending) {
    lastInvestSort = 1;
    largeCapList.sort((b, a) => a.profitPotential.compareTo(b.profitPotential));
    midCapList.sort((b, a) => a.profitPotential.compareTo(b.profitPotential));
    smallCapList.sort((b, a) => a.profitPotential.compareTo(b.profitPotential));
    // } else {
    //   lastInvestSort = 0;
    //   oneClickInvestLargeList
    //       .sort((a, b) => a.profitPotential.compareTo(b.profitPotential));
    //   oneClickInvestMildList
    //       .sort((a, b) => a.profitPotential.compareTo(b.profitPotential));
    //   oneClickInvestSmallList
    //       .sort((a, b) => a.profitPotential.compareTo(b.profitPotential));
    // }
  }

  @action
  void sortInvestmentByRecent() {
    lastInvestSort = 2;
    largeCapList.sort((b, a) => DateUtil.getDateTimeFromString(a.insertiontime, 'dd/MM/yyyy hh:mm:ss a').compareTo(DateUtil.getDateTimeFromString(b.insertiontime, 'dd/MM/yyyy hh:mm:ss a')));
    midCapList.sort((b, a) => DateUtil.getDateTimeFromString(a.insertiontime, 'dd/MM/yyyy hh:mm:ss a').compareTo(DateUtil.getDateTimeFromString(b.insertiontime, 'dd/MM/yyyy hh:mm:ss a')));
    smallCapList.sort((b, a) => DateUtil.getDateTimeFromString(a.insertiontime, 'dd/MM/yyyy hh:mm:ss a').compareTo(DateUtil.getDateTimeFromString(b.insertiontime, 'dd/MM/yyyy hh:mm:ss a')));
  }

  @action
  void sortFutureOptionByProfitPotential(bool isDescending) {
    // if (isDescending) {
    lastFutureOptionSort = 1;
    futureList.sort((b, a) => a.profitPotential.compareTo(b.profitPotential));
    optionList.sort((b, a) => a.profitPotential.compareTo(b.profitPotential));
    // } else {
    //   lastFutureOptionSort = 0;
    //   futureList
    //       .sort((a, b) => a.profitPotential.compareTo(b.profitPotential));
    //   optionList
    //       .sort((a, b) => a.profitPotential.compareTo(b.profitPotential));
    // }
  }

  @action
  void sortFutureOptionByRecent() {
    lastFutureOptionSort = 2;
    futureList.sort((b, a) => DateUtil.getDateTimeFromString(a.insertiontime, 'dd/MM/yyyy hh:mm:ss a').compareTo(DateUtil.getDateTimeFromString(b.insertiontime, 'dd/MM/yyyy hh:mm:ss a')));
    optionList.sort((b, a) => DateUtil.getDateTimeFromString(a.insertiontime, 'dd/MM/yyyy hh:mm:ss a').compareTo(DateUtil.getDateTimeFromString(b.insertiontime, 'dd/MM/yyyy hh:mm:ss a')));
  }

  @action
  void sortCurrencyByProfitPotential(bool isDescending) {
    // if (isDescending) {
    lastCurrencySort = 1;
    currencyList.sort((b, a) => a.profitPotential.compareTo(b.profitPotential));
    // } else {
    //   lastCurrencySort = 0;
    //   currencyList
    //       .sort((a, b) => a.profitPotential.compareTo(b.profitPotential));
    // }
  }

  @action
  void sortCurrencyByRecent() {
    lastCurrencySort = 2;
    currencyList.sort((b, a) => DateUtil.getDateTimeFromString(a.insertiontime, 'dd/MM/yyyy hh:mm:ss a').compareTo(DateUtil.getDateTimeFromString(b.insertiontime, 'dd/MM/yyyy hh:mm:ss a')));
  }

  @action
  void sortCommodityByProfitPotential(bool isDescending) {
    // if (isDescending) {
    lastCommoditySort = 1;
    commodityList.sort((b, a) => a.profitPotential.compareTo(b.profitPotential));
    // } else {
    //   lastCommoditySort = 0;
    //   commodityList
    //       .sort((a, b) => a.profitPotential.compareTo(b.profitPotential));
    // }
  }

  @action
  void sortCommodityByRecent() {
    lastCommoditySort = 2;
    commodityList.sort((b, a) => DateUtil.getDateTimeFromString(a.insertiontime, 'dd/MM/yyyy hh:mm:ss a').compareTo(DateUtil.getDateTimeFromString(b.insertiontime, 'dd/MM/yyyy hh:mm:ss a')));
  }
}
