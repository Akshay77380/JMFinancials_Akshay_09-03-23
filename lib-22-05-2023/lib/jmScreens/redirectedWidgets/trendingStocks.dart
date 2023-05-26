import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../controllers/MostActiveVolumeController.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../../widget/smallChart.dart';
import '../ScriptInfo/ScriptInfo.dart';
class TrendingStocksPage extends StatefulWidget {
  const TrendingStocksPage({Key key}) : super(key: key);

  @override
  State<TrendingStocksPage> createState() => _TrendingStocksPageState();
}

class _TrendingStocksPageState extends State<TrendingStocksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Trending Stocks", style: Utils.fonts(
              color: Utils.blackColor,
              size: 20.0
          ),)
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Obx(() {
                    return MostActiveVolumeController.getMostActiveVolumeListItems.length > 0
                        ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:MostActiveVolumeController.getMostActiveVolumeListItems.length ,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScriptInfo(CommonFunction.getScripDataModel(
                                            exch: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode) >= 500000 ? "B" : "N",
                                            exchCode: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode.toString())), false)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        MostActiveVolumeController.getMostActiveVolumeListItems[index].symbol.toString(),
                                        style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Observer(
                                        builder: (context) => CommonFunction.getScripDataModel(
                                            exchCode: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode),
                                            exch: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode) > 500000 ? "B" : "N"
                                        ).chartMinClose[15].length > 0 ?
                                        SmallSimpleLineChart(
                                          seriesList: CommonFunction.getScripDataModel(
                                              exchCode: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode),
                                              exch: int.parse(MostActiveVolumeController.getMostActiveVolumeListItems[index].scCode) > 500000 ? "B" : "N"
                                          ).dataPoint[15],
                                          prevClose: MostActiveVolumeController.getMostActiveVolumeListItems[index].closePrice,
                                          name: MostActiveVolumeController.getMostActiveVolumeListItems[index].symbol,
                                        ) : SizedBox.shrink()
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                MostActiveVolumeController.getMostActiveVolumeListItems[index].closePrice.toString(),
                                                style: Utils.fonts(size: 14.0, color: Utils.blackColor, fontWeight: FontWeight.w500),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: RotatedBox(
                                                        quarterTurns: MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg > 0 ? 4 : 2,
                                                        child: SvgPicture.asset("assets/appImages/inverted_rectangle.svg",
                                                            color: MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg > 0 ? Utils.lightGreenColor : Utils.lightRedColor)),
                                                  ),
                                                  Text(
                                                    "${MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg.toStringAsFixed(2)} %",
                                                    style: Utils.fonts(
                                                        size: 14.0,
                                                        color: MostActiveVolumeController.getMostActiveVolumeListItems[index].perchg > 0 ? Utils.lightGreenColor : Utils.lightRedColor,
                                                        fontWeight: FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            )
                          ],
                        );
                      },
                    )
                        : Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Data Available",
                            style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                          ),
                        ],
                      ),
                    );
                  })
                ],
              ),
            ),
            Container(
              height: 4.0,
              width: MediaQuery.of(context).size.width,
              color: Utils.greyColor.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}
