import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:markets/controllers/orderBookController.dart';
import '../../controllers/netPositionController.dart';
import '../../controllers/positionFilterController.dart';
import '../../controllers/todaysPostionController.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import '../mainScreen/MainScreen.dart';
import 'close_positions.dart';
import 'open_positions.dart';

class PositionsScreen extends StatefulWidget {
  @override
  State<PositionsScreen> createState() => _PositionsScreenState();
}

class _PositionsScreenState extends State<PositionsScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;
  // final NetPositionController netPositionController = Get.put(NetPositionController());

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        setState(() {
          _currentIndex = _tabController.index;
        });
      });
    _tabController.index = Dataconstants.positionIndex;
    Dataconstants.netPositionController.fetchNetPosition();
    // Dataconstants.positionFilterController = Get.put(PositionFilterController());
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        if (!(NetPositionController.NetPositionLength == 0))
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Obx(() {
                  return PositionFilterController.isPositionSearch.value
                      ? SizedBox.shrink()
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Utils.primaryColor.withOpacity(0.1),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    'Total Buy',
                                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.blackColor),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    NetPositionController.totalBuy.toStringAsFixed(2),
                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: Utils.blackColor),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Total Sell',
                                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.blackColor),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    NetPositionController.totalSell.toStringAsFixed(2),
                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: Utils.blackColor),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Net Value',
                                    style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.blackColor),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    NetPositionController.totalNet.toStringAsFixed(2),
                                    style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700, color: Utils.blackColor),
                                  )
                                ],
                              ),
                            ],
                          ),
                        );
                }),
                const SizedBox(
                  height: 15,
                ),
                Obx(() {
                  return NetPositionController.isLoading.value
                      ? SizedBox.shrink()
                      : Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TabBar(
                                isScrollable: true,
                                labelStyle: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500),
                                unselectedLabelStyle: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500),
                                unselectedLabelColor: Colors.grey[600],
                                labelColor: Utils.primaryColor,
                                indicatorPadding: EdgeInsets.zero,
                                labelPadding: EdgeInsets.zero,
                                indicatorSize: TabBarIndicatorSize.label,
                                indicatorWeight: 0,
                                indicator: BoxDecoration(),
                                controller: _tabController,
                                tabs: [
                                  Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                        ),
                                        border: Border.all(color: _currentIndex == 0 ? Utils.primaryColor : Utils.greyColor)),
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Tab(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'OPEN',
                                          ),
                                          const SizedBox(width: 8),
                                          Obx(() {
                                            return NetPositionController.isLoading.value
                                                ? SizedBox.shrink()
                                                : Visibility(
                                                    visible: NetPositionController.isLoading.value == true ? false : true,
                                                    child: CircleAvatar(
                                                      backgroundColor: _tabController.index == 0 ? theme.primaryColor : Colors.grey,
                                                      foregroundColor: Colors.white,
                                                      maxRadius: 11,
                                                      child: Text(
                                                        '${NetPositionController.OpenPositionLength}',
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  );
                                          })
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                        border: Border.all(color: _currentIndex == 1 ? Utils.primaryColor : Utils.greyColor)
                                        // border: Border(
                                        //     top: BorderSide(color: Utils.primaryColor, width: 1),
                                        //     bottom: BorderSide(color: Utils.primaryColor, width: 1),
                                        //     right: BorderSide(color: Utils.primaryColor, width: 1),
                                        //     left: BorderSide(color: Utils.greyColor, width: 1))
                                        ),
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Tab(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'CLOSE',
                                          ),
                                          const SizedBox(width: 8),
                                          Obx(() {
                                            return NetPositionController.isLoading.value
                                                ? SizedBox.shrink()
                                                : Visibility(
                                                    visible: NetPositionController.isLoading.value == true ? false : true,
                                                    child: CircleAvatar(
                                                      backgroundColor: _tabController.index == 1 ? theme.primaryColor : Colors.grey,
                                                      foregroundColor: Colors.white,
                                                      maxRadius: 11,
                                                      child: Text(
                                                        '${NetPositionController.ClosePositionLength}',
                                                        style: const TextStyle(fontSize: 12),
                                                      ),
                                                    ),
                                                  );
                                          })
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                                onTap: (value) {
                                  setState(() {
                                    Dataconstants.positionIndex = value;
                                  });
                                },
                              ),
                            ),
                            Spacer(),
                            _currentIndex == 0
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('UNREALISED P/L',
                                          style: Utils.fonts(
                                            size: 12.0,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Observer(builder: (context) {
                                        double totalUnrealisedPL = 0.0;
                                        double pl = 0.0;
                                        for (int i = 0; i < NetPositionController.openPositionList.length; i++) {
                                          if (int.parse(NetPositionController.openPositionList[i].netqty) == 0)
                                            pl = 0.00;
                                          else if (int.parse(NetPositionController.openPositionList[i].netqty) < 0)
                                            pl = (NetPositionController.openPositionList[i].model.close - double.tryParse(NetPositionController.openPositionList[i].sellavgprice.replaceAll(',', ''))) *
                                                int.parse(NetPositionController.openPositionList[i].netqty).abs();
                                          else
                                            pl = (NetPositionController.openPositionList[i].model.close - double.parse(NetPositionController.openPositionList[i].buyavgprice.replaceAll(',', ''))) *
                                                int.parse(NetPositionController.openPositionList[i].netqty).abs();
                                          if (NetPositionController.openPositionList[i].model.exch == 'M' && NetPositionController.openPositionList[i].model.exchType == 'D')
                                            pl = NetPositionController.openPositionList[i].pl *
                                                NetPositionController.openPositionList[i].model.factor *
                                                NetPositionController.openPositionList[i].model.minimumLotQty;
                                          totalUnrealisedPL += pl;
                                        }
                                        return Text(totalUnrealisedPL.toStringAsFixed(2),
                                            style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700, color: totalUnrealisedPL > 0 ? Utils.mediumGreenColor : Utils.mediumRedColor));
                                      })
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('REALISED P/L',
                                          style: Utils.fonts(
                                            size: 12.0,
                                            fontWeight: FontWeight.w500,
                                          )),
                                      Text(NetPositionController.totalRealisedPL.toStringAsFixed(2),
                                          style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w700, color: NetPositionController.totalRealisedPL > 0 ? Utils.mediumGreenColor : Utils.mediumRedColor))
                                    ],
                                  )
                          ],
                        );
                }),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        Divider(
          thickness: 2,
        ),
        Obx(() {
          return (NetPositionController.isLoading.value && NetPositionController.isLoading.value)
              ? CircularProgressIndicator()
              : !(NetPositionController.NetPositionLength == 0)
                  ? Expanded(
                      child: TabBarView(
                        physics: CustomTabBarScrollPhysics(),
                        controller: _tabController,
                        children: [
                          OpenPositions(),
                          ClosePositions(),
                        ],
                      ),
                    )
                  : Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/appImages/noPositions.svg'),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "You have no Positions today",
                            style: Utils.fonts(size: 15.0, fontWeight: FontWeight.w400, color: Colors.grey[600]),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(
                                  color: theme.primaryColor,
                                ),
                              ),
                              color: theme.primaryColor,
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: Text(
                                'PLACE ORDER',
                                style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                              onPressed: () {
                                InAppSelection.mainScreenIndex = 1;
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (_) => MainScreen(
                                          toChangeTab: false,
                                        )));
                              })
                        ],
                      ),
                    );
        }),
      ],
    );
  }
}
