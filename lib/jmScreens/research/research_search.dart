import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:markets/model/jmModel/researchCalls.dart';
import 'package:markets/style/theme.dart';
import 'package:markets/util/CommonFunctions.dart';
import 'package:markets/util/Dataconstants.dart';
import 'package:mobx/mobx.dart';

import '../../model/scrip_info_model.dart';
import 'research_cards.dart';

class ResearchSearch extends StatefulWidget {
  final ScripInfoModel model;

  const ResearchSearch({this.model});

  @override
  _ResearchSearchState createState() => _ResearchSearchState();
}

class _ResearchSearchState extends State<ResearchSearch> {
  @observable
  List<ResearchCallsDatum> researchScripList = ObservableList<ResearchCallsDatum>();

  Future<bool> getData() {
    researchScripList.clear();
    researchScripList.addAll(Dataconstants.researchCallsModel.intradayList.where((element) => element.model.exchCode == widget.model.exchCode).toList());
    researchScripList.addAll(Dataconstants.researchCallsModel.momentumList.where((element) => element.model.exchCode == widget.model.exchCode).toList());
    researchScripList.addAll(Dataconstants.researchCallsModel.largeCapList.where((element) => element.model.exchCode == widget.model.exchCode).toList());
    researchScripList.addAll(Dataconstants.researchCallsModel.midCapList.where((element) => element.model.exchCode == widget.model.exchCode).toList());
    researchScripList.addAll(Dataconstants.researchCallsModel.smallCapList.where((element) => element.model.exchCode == widget.model.exchCode).toList());
    researchScripList.addAll(Dataconstants.researchCallsModel.futureList.where((element) => element.model.exchCode == widget.model.exchCode).toList());
    researchScripList.addAll(Dataconstants.researchCallsModel.optionList.where((element) => element.model.exchCode == widget.model.exchCode).toList());
    researchScripList.addAll(Dataconstants.researchCallsModel.currencyList.where((element) => element.model.exchCode == widget.model.exchCode).toList());
    researchScripList.addAll(Dataconstants.researchCallsModel.commodityList.where((element) => element.model.exchCode == widget.model.exchCode).toList());
    return Future.value(true);
  }

  // Future fut() async {
  //   Future f1 = Dataconstants.itsClient.clickToGain();
  //   Future f2 = Dataconstants.itsClient.clickToInvest();
  //   Future f3 = Dataconstants.itsClient.researchReports(
  //     stockCode: widget.model.isecName,
  //     model: widget.model,
  //   );
  //   return await Future.wait(
  //     [f1, f2, f3],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          widget.model.series == 'EQ' ? '${widget.model.name}' : '${widget.model.desc}',
          style: TextStyle(fontSize: 22, color: theme.textTheme.bodyText1.color),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: getData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                getData();
                return Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    researchScripList.length > 0
                        ? Observer(builder: (BuildContext context) {
                            return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: researchScripList.length,
                                itemBuilder: (ctx, index) {
                                  if (researchScripList[index].categoryid == '2' && researchScripList[index].subcategoryid == '3' && researchScripList[index].exchsegment.toUpperCase() == 'EQUITY')
                                    return Column(
                                      children: [
                                        TradingCard(
                                          data: researchScripList[index],
                                          isScripDetailResearch: false,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  else if (researchScripList[index].categoryid == '2' &&
                                      researchScripList[index].subcategoryid == '4' &&
                                      researchScripList[index].exchsegment.toUpperCase() == 'EQUITY')
                                    return Column(
                                      children: [
                                        TradingCard(
                                          data: researchScripList[index],
                                          isScripDetailResearch: false,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  else if (researchScripList[index].categoryid == '1' &&
                                      researchScripList[index].subcategoryid == '5' &&
                                      researchScripList[index].exchsegment.toUpperCase() == 'EQUITY')
                                    return Column(
                                      children: [
                                        InvestmentCard(
                                          data: researchScripList[index],
                                          isScripDetailResearch: false,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  else if (researchScripList[index].categoryid == '1' &&
                                      researchScripList[index].subcategoryid == '6' &&
                                      researchScripList[index].exchsegment.toUpperCase() == 'EQUITY')
                                    return Column(
                                      children: [
                                        InvestmentCard(
                                          data: researchScripList[index],
                                          isScripDetailResearch: false,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  else if (researchScripList[index].categoryid == '1' &&
                                      researchScripList[index].subcategoryid == '7' &&
                                      researchScripList[index].exchsegment.toUpperCase() == 'EQUITY')
                                    return Column(
                                      children: [
                                        InvestmentCard(
                                          data: researchScripList[index],
                                          isScripDetailResearch: false,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  else if (researchScripList[index].exchsegment.toUpperCase() == 'FUTIDX' ||
                                      researchScripList[index].exchsegment.toUpperCase() == 'FUTSTK' ||
                                      researchScripList[index].exchsegment.toUpperCase() == 'OPIDX' ||
                                      researchScripList[index].exchsegment.toUpperCase() == 'OPTSTK')
                                    return Column(
                                      children: [
                                        FutureOptionsCard(
                                          data: researchScripList[index],
                                          isScripDetailResearch: false,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  else if (researchScripList[index].exchsegment.toUpperCase() == 'FUTCUR')
                                    return Column(
                                      children: [
                                        CurrencyCard(
                                          data: researchScripList[index],
                                          isScripDetailResearch: false,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  else if (researchScripList[index].exchsegment.toUpperCase() == 'FUTCOMM')
                                    return Column(
                                      children: [
                                        CommodityCard(
                                          data: researchScripList[index],
                                          isScripDetailResearch: false,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    );
                                  else
                                    return SizedBox.shrink();
                                });
                          })
                        : Center(
                          child: Text(
                              "No Research Information Available",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: ThemeConstants.themeMode.value == ThemeMode.light ? Color(0xff343434) : Color(0xffF1F1F1)),
                            ),
                        ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
                    ),
                  ),
                );
            }),
      ),
    );
  }

  Widget sectionHeading(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          '$title',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
