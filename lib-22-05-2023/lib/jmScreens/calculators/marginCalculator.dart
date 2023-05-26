import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../screens/search_bar_screen.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';

class MarginCalculator extends StatefulWidget {
  const MarginCalculator({Key key}) : super(key: key);

  @override
  State<MarginCalculator> createState() => _MarginCalculatorState();
}

class _MarginCalculatorState extends State<MarginCalculator>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _marginSearchController;
  TextEditingController _optionSearchController;

  int _currentIndex = 0;
  bool isSegmentFirstClicked = true,
      isProductFutureClicked = true,
      isProductOptionClicked = false,
      isActionBuyClicked = true,
      isActionSellClicked = false,
      isCall = true;
  bool isSegementSecondClickded = false;
  TextEditingController _qtyContoller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _marginSearchController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _marginSearchController.text = Dataconstants.searchModel == null
        ? 'Search Scrip / Expiry Date'
        : Dataconstants.searchModel.marketWatchName;
    _tabController = TabController(vsync: this, length: 2)
      ..addListener(() {
        setState(() {
          _currentIndex = _tabController.index;
        });
      });
    _qtyContoller = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    _qtyContoller.text = Dataconstants.searchModel != null
        ? Dataconstants.searchModel.minimumLotQty
        : '0';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Focus.of(context).unfocus();
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey[200],
                offset: Offset(0, 2.0),
                blurRadius: 4.0,
              )
            ]),
            child: AppBar(
              elevation: 0.0,
              centerTitle: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Calculators',
                    style: Utils.fonts(
                        size: 18.0,
                        color: Utils.blackColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  SvgPicture.asset('assets/appImages/tranding.svg')
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: Container(
                  width: width,
                  margin: EdgeInsets.only(left: 20),
                  padding: const EdgeInsets.only(
                    bottom: 20,
                  ),
                  child: TabBar(
                    physics: CustomTabBarScrollPhysics(),
                    isScrollable: true,
                    labelStyle:
                        Utils.fonts(size: 12.0, fontWeight: FontWeight.bold),
                    unselectedLabelStyle:
                        Utils.fonts(size: 12.0, fontWeight: FontWeight.w500),
                    unselectedLabelColor: Colors.grey[600],
                    labelColor: Utils.primaryColor,
                    indicatorPadding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 0,
                    indicator: BoxDecoration(),
                    controller: _tabController,
                    onTap: (value) {
                      InAppSelection.orderReportScreenTabIndex = value;
                    },
                    tabs: [
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                            color: _currentIndex == 0
                                ? theme.primaryColor.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25),
                            ),
                            border: Border.all(
                                color: _currentIndex == 0
                                    ? Utils.primaryColor.withOpacity(0.1)
                                    : Utils.whiteColor)),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Margin',
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 35,
                        decoration: BoxDecoration(
                            color: _currentIndex == 1
                                ? theme.primaryColor.withOpacity(0.1)
                                : Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            border: Border.all(
                                color: _currentIndex == 1
                                    ? Utils.primaryColor.withOpacity(0.1)
                                    : Utils.whiteColor)),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Option',
                                style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Column(
              children: [
                Container(
                  child: Expanded(
                    child: TabBarView(
                      physics: CustomTabBarScrollPhysics(),
                      controller: _tabController,
                      children: [MarginBlock(theme), OptionBlock(theme)],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget MarginBlock(theme) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'SEGMENT',
                style: Utils.fonts(
                    fontWeight: FontWeight.w500,
                    size: 12.0,
                    color: Utils.greyColor),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSegmentFirstClicked = true;
                    isSegementSecondClickded = false;
                  });
                },
                child: Container(
                  // color: Colors.grey[500],
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      border: Border(
                        left: isSegmentFirstClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        top: isSegmentFirstClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        bottom: isSegmentFirstClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        right: isSegmentFirstClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                      )),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'NFO',
                      style: Utils.fonts(
                          fontWeight: FontWeight.w600,
                          size: 12.0,
                          color: isSegmentFirstClicked
                              ? theme.primaryColor
                              : Utils.greyColor.withOpacity(1)),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSegementSecondClickded = true;
                    isSegmentFirstClicked = false;
                  });
                },
                child: Container(
                  // color: Colors.grey[500],
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      border: Border(
                        left: isSegementSecondClickded
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        top: isSegementSecondClickded
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        bottom: isSegementSecondClickded
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        right: isSegementSecondClickded
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                      )),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'CDS',
                      style: Utils.fonts(
                          fontWeight: FontWeight.w600,
                          size: 12.0,
                          color: isSegementSecondClickded
                              ? theme.primaryColor
                              : Utils.greyColor.withOpacity(1)),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'PRODUCT',
                style: Utils.fonts(
                    fontWeight: FontWeight.w500,
                    size: 12.0,
                    color: Utils.greyColor),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isProductFutureClicked = true;
                    isProductOptionClicked = false;
                  });
                },
                child: Container(
                  // color: Colors.grey[500],
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      border: Border(
                        left: isProductFutureClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        top: isProductFutureClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        bottom: isProductFutureClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        right: isProductFutureClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                      )),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'FUTURE',
                      style: Utils.fonts(
                          fontWeight: FontWeight.w600,
                          size: 12.0,
                          color: isProductFutureClicked
                              ? theme.primaryColor
                              : Utils.greyColor.withOpacity(1)),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isProductOptionClicked = true;
                    isProductFutureClicked = false;
                  });
                },
                child: Container(
                  // color: Colors.grey[500],
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      border: Border(
                        left: isProductOptionClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        top: isProductOptionClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        bottom: isProductOptionClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        right: isProductOptionClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                      )),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'OPTION',
                      style: Utils.fonts(
                          fontWeight: FontWeight.w600,
                          size: 12.0,
                          color: isProductOptionClicked
                              ? theme.primaryColor
                              : Utils.greyColor.withOpacity(1)),
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          if (isProductOptionClicked)
            Row(
              children: [
                Text(
                  'OPTION TYPE',
                  style: Utils.fonts(
                      fontWeight: FontWeight.w500,
                      size: 12.0,
                      color: Utils.greyColor),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCall = true;
                    });
                  },
                  child: Container(
                    // color: Colors.grey[500],
                    height: 45,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                        border: Border(
                          left: isCall
                              ? BorderSide(
                                  color: theme.primaryColor.withOpacity(1.0))
                              : BorderSide(
                                  color: Utils.greyColor.withOpacity(0.5)),
                          top: isCall
                              ? BorderSide(
                                  color: theme.primaryColor.withOpacity(1.0))
                              : BorderSide(
                                  color: Utils.greyColor.withOpacity(0.5)),
                          bottom: isCall
                              ? BorderSide(
                                  color: theme.primaryColor.withOpacity(1.0))
                              : BorderSide(
                                  color: Utils.greyColor.withOpacity(0.5)),
                          right: isCall
                              ? BorderSide(
                                  color: theme.primaryColor.withOpacity(1.0))
                              : BorderSide(
                                  color: Utils.greyColor.withOpacity(0.5)),
                        )),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'CALL',
                        style: Utils.fonts(
                            fontWeight: FontWeight.w600,
                            size: 12.0,
                            color: isCall
                                ? theme.primaryColor
                                : Utils.greyColor.withOpacity(1)),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isCall = false;
                    });
                  },
                  child: Container(
                    // color: Colors.grey[500],
                    height: 45,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        border: Border(
                          left: isCall == false
                              ? BorderSide(
                                  color: theme.primaryColor.withOpacity(1.0))
                              : BorderSide(
                                  color: Utils.greyColor.withOpacity(0.5)),
                          top: isCall == false
                              ? BorderSide(
                                  color: theme.primaryColor.withOpacity(1.0))
                              : BorderSide(
                                  color: Utils.greyColor.withOpacity(0.5)),
                          bottom: isCall == false
                              ? BorderSide(
                                  color: theme.primaryColor.withOpacity(1.0))
                              : BorderSide(
                                  color: Utils.greyColor.withOpacity(0.5)),
                          right: isCall == false
                              ? BorderSide(
                                  color: theme.primaryColor.withOpacity(1.0))
                              : BorderSide(
                                  color: Utils.greyColor.withOpacity(0.5)),
                        )),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'OPTION',
                        style: Utils.fonts(
                            fontWeight: FontWeight.w600,
                            size: 12.0,
                            color: isCall == false
                                ? theme.primaryColor
                                : Utils.greyColor.withOpacity(1)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          if (isProductOptionClicked)
            SizedBox(
              height: 20,
            ),
          Row(
            children: [
              Text(
                'ACTION',
                style: Utils.fonts(
                    fontWeight: FontWeight.w500,
                    size: 12.0,
                    color: Utils.greyColor),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isActionBuyClicked = true;
                    isActionSellClicked = false;
                  });
                },
                child: Container(
                  // color: Colors.grey[500],
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      border: Border(
                        left: isActionBuyClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        top: isActionBuyClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        bottom: isActionBuyClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        right: isActionBuyClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                      )),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'BUY',
                      style: Utils.fonts(
                          fontWeight: FontWeight.w600,
                          size: 12.0,
                          color: isActionBuyClicked
                              ? theme.primaryColor
                              : Utils.greyColor.withOpacity(1)),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isActionSellClicked = true;
                    isActionBuyClicked = false;
                  });
                },
                child: Container(
                  // color: Colors.grey[500],
                  height: 45,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      border: Border(
                        left: isActionSellClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        top: isActionSellClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        bottom: isActionSellClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                        right: isActionSellClicked
                            ? BorderSide(
                                color: theme.primaryColor.withOpacity(1.0))
                            : BorderSide(
                                color: Utils.greyColor.withOpacity(0.5)),
                      )),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'SELL',
                      style: Utils.fonts(
                          fontWeight: FontWeight.w600,
                          size: 12.0,
                          color: isActionSellClicked
                              ? theme.primaryColor
                              : Utils.greyColor.withOpacity(1)),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            showCursor: true,
            readOnly: true,
            onSubmitted: (_) {},
            onTap: () {
              Dataconstants.isComingFromMarginCalculator = true;
              showSearch(
                context: context,
                delegate: SearchBarScreen(InAppSelection.marketWatchID),
              ).then((value) => setState(() {
                    _marginSearchController.text =
                        Dataconstants.searchModel.marketWatchName;
                    _qtyContoller.text =
                        Dataconstants.searchModel.minimumLotQty.toString();
                    Dataconstants.isComingFromMarginCalculator = false;
                  }));
            },
            controller: _marginSearchController,
            decoration: InputDecoration(
              hintText:
                  '${Dataconstants.searchModel != null ? Dataconstants.searchModel.marketWatchName : 'Search Scrip / Expiry Date'}',
              fillColor: Utils.greyColor.withOpacity(0.1),
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: SvgPicture.asset(
                  'assets/appImages/searchSmall.svg',
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.center,
                ),
              ),
              suffixIcon: SvgPicture.asset(
                'assets/appImages/voiceSearchGrey.svg',
              ),
              labelStyle: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600),
              hintStyle: Utils.fonts(
                  size: 14.0,
                  fontWeight: FontWeight.w600,
                  color: Utils.greyColor),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: theme.primaryColor)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey.shade100)),
              errorBorder: InputBorder.none,
              disabledBorder:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'QUANTITY ${Dataconstants.searchModel == null ? "" : "(LOT SIZE: ${Dataconstants.searchModel.minimumLotQty})"}',
              style: Utils.fonts(
                  size: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Utils.greyColor),
            ),
          ),
          const SizedBox(height: 10),

          //commented

          // NumberField(
          //   maxLength: 10,
          //   numberController: _qtyContoller,
          //   hint: '',
          //   isInteger: true,
          //   isFromCalculator: true,
          //   isBuy: true,
          //   // isRupeeLogo: false,
          //   // isDisable: false,
          //   // readOnly: false,
          // ),
          const SizedBox(height: 180),
          Center(
            child: Text(
              'What is Margin Calculator?',
              style: Utils.fonts(
                  size: 12.0,
                  textDecoration: TextDecoration.underline,
                  fontWeight: FontWeight.w400,
                  color: theme.primaryColor),
              // style: TextStyle(
              //     fontSize: 12.0,
              //     fontStyle: ,
              //     decoration: TextDecoration.underline,
              //     fontWeight: FontWeight.w400,
              //     color: theme.primaryColor.withOpacity(1.0)),
            ),
          ),
          const SizedBox(height: 20),
          CommonFunction.saveAndCancelButton(
              cancelText: 'Reset', SaveText: 'Calculate'),
        ],
      ),
    );
  }

  Widget OptionBlock(theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  "RELIANCE",
                  style: Utils.fonts(color: Utils.blackColor),
                ),
              ),
              Text(
                "31 MAR 2200 ",
                style: Utils.fonts(
                    color: Utils.greyColor.withOpacity(0.5), size: 12.0),
              ),
              Text(
                "PE",
                style: Utils.fonts(color: Utils.mediumRedColor),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Stack( children: [
              Positioned(
                child: Container(
                    height: 58,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey))),
              ),
              Positioned(
                  top: -7,
                  left: 5,
                  right: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Utils.whiteColor,
                        child: Text(
                          "Spot",
                          style:
                              Utils.fonts(color: Utils.blackColor, size: 11.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )),
              Positioned(
                top: 1,
                bottom: 1,
                left: 1,
                right: 1,
                child: Center(
                  child: Text("2410",
                      style: Utils.fonts(color: Utils.blackColor, size: 14.0)),
                ),
              )
            ]),
            Stack( children: [
              Positioned(
                child: Container(
                    height: 58,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey))),
              ),
              Positioned(
                  top: -7,
                  left: 5,
                  right: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Utils.whiteColor,
                        child: Text(
                          "Strike",
                          style:
                              Utils.fonts(color: Utils.blackColor, size: 11.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )),
              Positioned(
                top: 1,
                bottom: 1,
                left: 1,
                right: 1,
                child: Center(
                  child: Text("2200",
                      style: Utils.fonts(color: Utils.blackColor, size: 14.0)),
                ),
              )
            ]),
            Stack( children: [
              Positioned(
                child: Container(
                    height: 58,
                    width: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey))),
              ),
              Positioned(
                  top: -7,
                  left: 5,
                  right: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: Utils.whiteColor,
                        child: Text(
                          "Maturity (Days)",
                          style: Utils.fonts(
                              color: Utils.greyColor.withOpacity(0.8),
                              size: 11.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  )),
              Positioned(
                top: 1,
                bottom: 1,
                left: 1,
                right: 1,
                child: Center(
                  child: Text("15",
                      style: Utils.fonts(color: Utils.blackColor, size: 14.0)),
                ),
              )
            ]),
          ]),
          SizedBox(
            height: 10,
          ),
          Column(
            children: [
              Row(
                children: [
                  Text("Volatility",
                      style: Utils.fonts(color: Utils.greyColor, size: 14.0)),
                  Expanded(
                    child: Slider(
                        value: 13.33,
                        min: 1.0,
                        max: 20.0,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.grey,
                        onChanged: (double newValue) {
                          setState(() {});
                        },
                        semanticFormatterCallback: (double newValue) {
                          return '${newValue.round()} dollars';
                        }),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(
                              color: Utils.greyColor.withOpacity(0.5),
                              width: 1.0)),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20.0),
                          child: Text("18%",
                              style: Utils.fonts(
                                  color: Utils.blackColor, size: 12.0))))
                ],
              ),
              Row(
                children: [
                  Text("Interest",
                      style: Utils.fonts(
                        color: Utils.greyColor,
                      )),
                  Expanded(
                    child: Slider(
                        value: 89.33,
                        min: 1.0,
                        max: 100,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.grey,
                        onChanged: (double newValue) {
                          setState(() {});
                        },
                        semanticFormatterCallback: (double newValue) {
                          return '${newValue.round()} dollars';
                        }),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(
                              color: Utils.greyColor.withOpacity(0.5),
                              width: 1.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                        child: Text("18%",
                            style: Utils.fonts(
                                color: Utils.blackColor, size: 12.0)),
                      ))
                ],
              ),
              Row(
                children: [
                  Text(
                    "Dividend",
                    style: Utils.fonts(
                      color: Utils.greyColor,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                        value: 13.33,
                        min: 1.0,
                        max: 100,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.grey,
                        onChanged: (double newValue) {
                          setState(() {});
                        },
                        semanticFormatterCallback: (double newValue) {
                          return '${newValue.round()} dollars';
                        }),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(
                              color: Utils.greyColor.withOpacity(0.5),
                              width: 1.0)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                        child: Text("18%",
                            style: Utils.fonts(
                                color: Utils.blackColor, size: 12.0)),
                      ))
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 40,
                width: 156,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Utils.greyColor)),
                child: Center(
                  child: Text("Reset",
                      style: Utils.fonts(
                        color: Utils.greyColor,
                      )),
                ),
              ),
              Container(
                height: 40,
                width: 156,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.blueAccent),
                child: Center(
                  child: Text("Calculate",
                      style: Utils.fonts(
                        color: Utils.whiteColor,
                      )),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Text("Calculated Input",
                  style: Utils.fonts(color: Utils.blackColor, size: 16.0)),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Option Premium",
                      style: Utils.fonts(
                          color: Utils.greyColor.withOpacity(0.5), size: 14.0)),
                  Text("1553.67",
                      style: Utils.fonts(color: Utils.blackColor, size: 14.0)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Delta",
                      style: Utils.fonts(
                          color: Utils.greyColor.withOpacity(0.5), size: 14.0)),
                  Text("1553.67",
                      style: Utils.fonts(color: Utils.blackColor, size: 14.0)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Gamma",
                      style: Utils.fonts(
                          color: Utils.greyColor.withOpacity(0.5), size: 14.0)),
                  Text("1553.67",
                      style: Utils.fonts(color: Utils.blackColor, size: 14.0)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Theta",
                      style: Utils.fonts(
                          color: Utils.greyColor.withOpacity(0.5), size: 14.0)),
                  Text("1553.67",
                      style: Utils.fonts(color: Utils.blackColor, size: 14.0)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Rho",
                      style: Utils.fonts(
                          color: Utils.greyColor.withOpacity(0.5), size: 14.0)),
                  Text("432.32",
                      style: Utils.fonts(color: Utils.blackColor, size: 14.0)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Option Vega",
                      style: Utils.fonts(
                          color: Utils.greyColor.withOpacity(0.5), size: 14.0)),
                  Text("0.08",
                      style: Utils.fonts(color: Utils.blackColor, size: 14.0)),
                ],
              )
            ],
          )
        ],
      ),
    );

    // return Column(
    //   children: [
    //     SizedBox(
    //       height: 20,
    //     ),
    //     TextField(
    //       onSubmitted: (_) {},
    //       onTap: (){
    //         DataConstants.isComingFromOptionCalculator = true;
    //         showSearch(
    //           context: context,
    //           delegate: SearchBarScreen(InAppSelection.marketWatchID),
    //         ).then((value) => setState(() {
    //           _optionSearchController.text =
    //               DataConstants.searchModel.marketWatchName;
    //           _qtyContoller.text =
    //               DataConstants.searchModel.minimumLotQty.toString();
    //           DataConstants.isComingFromOptionCalculator = false;
    //         }));
    //       },
    //       controller: _optionSearchController,
    //       decoration: InputDecoration(
    //         hintText: 'Search Scrip / Expiry Date',
    //         fillColor: Utils.greyColor.withOpacity(0.1),
    //         filled: true,
    //         prefixIcon: Padding(
    //           padding: const EdgeInsets.only(bottom: 5),
    //           child: SvgPicture.asset(
    //             'assets/appImages/searchSmall.svg',
    //             fit: BoxFit.scaleDown,
    //             alignment: Alignment.center,
    //           ),
    //         ),
    //         suffixIcon: SvgPicture.asset(
    //           'assets/appImages/voiceSearchGrey.svg',
    //         ),
    //         labelStyle: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600),
    //         hintStyle: Utils.fonts(
    //             size: 14.0,
    //             fontWeight: FontWeight.w600,
    //             color: Utils.greyColor),
    //         focusedBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(10.0),
    //             borderSide: BorderSide(color: theme.primaryColor)),
    //         enabledBorder: OutlineInputBorder(
    //             borderRadius: BorderRadius.circular(10),
    //             borderSide: BorderSide(color: Colors.grey.shade100)),
    //         errorBorder: InputBorder.none,
    //         disabledBorder:
    //             OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
    //       ),
    //     ),
    //     Spacer(),
    //     Center(
    //       child: Text(
    //         'What is Option Calculator?',
    //         style: Utils.fonts(
    //             size: 12.0,
    //             textDecoration: TextDecoration.underline,
    //             fontWeight: FontWeight.w400,
    //             color: theme.primaryColor),
    //         // style: TextStyle(
    //         //     fontSize: 12.0,
    //         //     fontStyle: ,
    //         //     decoration: TextDecoration.underline,
    //         //     fontWeight: FontWeight.w400,
    //         //     color: theme.primaryColor.withOpacity(1.0)),
    //       ),
    //     ),
    //     SizedBox(
    //       height: 100,
    //     ),
    //   ],
    // );
  }
}

// Widget OptionBlock(){
//
// }
