import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:markets/controllers/PortfolioControllers/PortfolioDerivateController.dart';
import 'package:markets/jmScreens/portfolio/zero_portfolio.dart';
import '../../controllers/PortfolioControllers/PortfolioEquityController.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';

class zeroPortfoliTabular extends StatefulWidget {
  @override
  State<zeroPortfoliTabular> createState() => _zeroPortfoliTabularState();
}

class _zeroPortfoliTabularState extends State<zeroPortfoliTabular> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Portfolio",
            style: Utils.fonts(),
          ),
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => zeroPortfolio()),
                  );
                },
                child: SvgPicture.asset(
                    "assets/appImages/portfolio/grid_view_icon.svg")),
            SizedBox(
              width: 10,
            ),
            InkWell(
                onTap: () {
                  CommonFunction.marketWatchBottomSheet(context);
                },
                child: SvgPicture.asset("assets/appImages/tranding.svg")),
            SizedBox(
              width: 10,
            )
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  // border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5.0),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff7ca6fa).withOpacity(0.2),
                      Color(0xff219305ff).withOpacity(0.2)
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Total Value",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0),
                                  ),
                                  Obx(() {
                                    return PortfolioEquityController
                                            .isLoading.value
                                        ? CircularProgressIndicator()
                                        : PortfolioEquityController
                                                .getPortfolioEquityListItems
                                                .isEmpty
                                            ? Text("0.00")
                                            : Text(
                                                PortfolioEquityController
                                                    .getPortfolioEquityListItems[
                                                        PortfolioEquityController
                                                                .getPortfolioEquityListItems
                                                                .length -
                                                            1]
                                                    .valuation
                                                    .toStringAsFixed(2),
                                                // " ",
                                                style: Utils.fonts(
                                                    fontWeight: FontWeight.w900,
                                                    size: 14.0),
                                              );
                                  })
                                ],
                              )
                            ],
                          ),
                          SvgPicture.asset(
                              'assets/appImages/portfolio/zero_wallet.svg')
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Invested",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 14.0,
                                    color: Colors.grey),
                              ),
                              Obx(() {
                                return PortfolioEquityController.isLoading.value
                                    ? CircularProgressIndicator()
                                    : PortfolioEquityController
                                            .getPortfolioEquityListItems.isEmpty
                                        ? Text("0.00")
                                        : Text(
                                            PortfolioEquityController
                                                .getPortfolioEquityListItems[
                                                    PortfolioEquityController
                                                            .getPortfolioEquityListItems
                                                            .length -
                                                        1]
                                                .netValue
                                                .toStringAsFixed(2),
                                            // " ",
                                            style: Utils.fonts(
                                                fontWeight: FontWeight.w900,
                                                size: 14.0),
                                          );
                              }),
                              Text(
                                "",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 14.0,
                                    color: Utils.brightGreenColor),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Day's P/L",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 14.0,
                                    color: Colors.grey),
                              ),
                              Text(
                                "-",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 14.0,
                                    color: Utils.brightGreenColor),
                              ),
                              Text(
                                "-",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 14.0,
                                    color: Utils.brightGreenColor),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Unrealised P/L",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 14.0,
                                    color: Colors.grey),
                              ),
                              Obx(() {
                                return PortfolioEquityController.isLoading.value
                                    ? CircularProgressIndicator()
                                    : PortfolioEquityController
                                            .getPortfolioEquityListItems.isEmpty
                                        ? Text("0.00")
                                        : Text(
                                            PortfolioEquityController
                                                .getPortfolioEquityListItems[
                                                    PortfolioEquityController
                                                            .getPortfolioEquityListItems
                                                            .length -
                                                        1]
                                                .unrealisedPl
                                                .toStringAsFixed(2),
                                            style: Utils.fonts(
                                                fontWeight: FontWeight.w500,
                                                size: 14.0,
                                                color: PortfolioEquityController
                                                            .getPortfolioEquityListItems[
                                                                PortfolioEquityController
                                                                        .getPortfolioEquityListItems
                                                                        .length -
                                                                    1]
                                                            .unrealisedPl <
                                                        0
                                                    ? Colors
                                                        .red // set color to red if unrealisedPl is less than zero
                                                    : Utils
                                                        .brightGreenColor // set color to green if unrealisedPl is greater than or equal to zero
                                                ),
                                          );
                              }),
                              Text(
                                "-",
                                style: Utils.fonts(
                                    fontWeight: FontWeight.w500,
                                    size: 14.0,
                                    color: PortfolioEquityController
                                                .getPortfolioEquityListItems[
                                                    PortfolioEquityController
                                                            .getPortfolioEquityListItems
                                                            .length -
                                                        1]
                                                .unrealisedPl <
                                            0
                                        ? Colors
                                            .red // set color to red if unrealisedPl is less than zero
                                        : Utils.brightGreenColor),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 3,
              color: Colors.grey[350],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("Asset Class",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 11.0,
                            color: Colors.grey)),
                    SizedBox(height: 15)
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Current",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 11.0,
                            color: Colors.grey)),
                    Text("Invested",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w500,
                            size: 11.0,
                            color: Colors.grey)),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Overall P/L",
                            style: Utils.fonts(
                                fontWeight: FontWeight.w700,
                                size: 11.0,
                                color: Colors.blue)),
                        Container(
                          child: SvgPicture.asset(
                              'assets/appImages/inverted_blue_rectangle.svg'),
                        )
                      ],
                    ),
                    SizedBox(height: 15)
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 2,
              color: Colors.grey[350],
            ),
            Container(
              height: MediaQuery.of(context).size.width,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: SvgPicture.asset(
                                      'assets/appImages/portfolio/zero_equity.svg',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Equity",
                                      style: Utils.fonts(
                                        fontWeight: FontWeight.w700,
                                        size: 14.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Obx(
                                      () {
                                        return PortfolioEquityController
                                                .isLoading.value
                                            ? CircularProgressIndicator()
                                            : PortfolioEquityController
                                                    .getPortfolioEquityListItems
                                                    .isEmpty
                                                ? Text("0.00")
                                                : Text(
                                                    PortfolioEquityController
                                                        .getPortfolioEquityListItems[
                                                            PortfolioEquityController
                                                                    .getPortfolioEquityListItems
                                                                    .length -
                                                                1]
                                                        .valuation
                                                        .toStringAsFixed(2),
                                                    // " ",
                                                    style: Utils.fonts(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      size: 14.0,
                                                    ),
                                                  );
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Obx(
                                      () {
                                        return PortfolioEquityController
                                                .isLoading.value
                                            ? CircularProgressIndicator()
                                            : PortfolioEquityController
                                                    .getPortfolioEquityListItems
                                                    .isEmpty
                                                ? Text("0.00")
                                                : Text(
                                                    PortfolioEquityController
                                                        .getPortfolioEquityListItems[
                                                            PortfolioEquityController
                                                                    .getPortfolioEquityListItems
                                                                    .length -
                                                                1]
                                                        .netValue
                                                        .toStringAsFixed(2),
                                                    // " ",
                                                    style: Utils.fonts(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      size: 14.0,
                                                    ),
                                                  );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      PortfolioEquityController
                                          .getPortfolioEquityListItems[
                                      PortfolioEquityController
                                          .getPortfolioEquityListItems
                                          .length -
                                          1]
                                          .unrealisedPl
                                          .toStringAsFixed(2),
                                      style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.darkGreenColor,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.darkGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                          color: Utils.greyColor.withOpacity(0.5),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: SvgPicture.asset(
                                      'assets/appImages/portfolio/zero_equity.svg'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Derivative",
                                    style: Utils.fonts(
                                        fontWeight: FontWeight.w700,
                                        size: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Obx(() {
                                      return PortfolioDerivateController
                                              .isLoading.value
                                          ? CircularProgressIndicator()
                                          : PortfolioDerivateController
                                                  .getDetailResultListItems1
                                                  .isEmpty
                                              ? Text("0.00")
                                              : Text(
                                                  Dataconstants.deriv_MTM_PL
                                                      .toStringAsFixed(2),
                                                  style: Utils.fonts(
                                                    fontWeight: FontWeight.w500,
                                                    size: 14.0,
                                                  ),
                                                );
                                    }),
                                    SizedBox(height: 10),
                                    Obx(() {
                                      return PortfolioDerivateController
                                              .isLoading.value
                                          ? CircularProgressIndicator()
                                          : PortfolioDerivateController
                                                  .getDetailResultListItems1
                                                  .isEmpty
                                              ? Text("0.00")
                                              : Text(
                                                  '${Dataconstants.deriv_Margin_Used.toStringAsFixed(2)}',
                                                  style: Utils.fonts(
                                                    fontWeight: FontWeight.w500,
                                                    size: 14.0,
                                                  ),
                                                );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.darkGreenColor,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.darkGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                          color: Utils.greyColor.withOpacity(0.5),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: SvgPicture.asset('assets/appImages/portfolio/zero_equity.svg'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Currency",
                                    style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return PortfolioDerivateController.isLoading.value
                                          ? CircularProgressIndicator()
                                          : PortfolioDerivateController.getDetailResultListItems3.isEmpty
                                          ? Text("0.0", style: Utils.fonts(color: Colors.black))
                                          : Text(
                                        '${Dataconstants.cur_MTM_PL ?? 0}',
                                        style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                        ),
                                      );
                                    }),
                                    SizedBox(height: 10),
                                    Obx(() {
                                      return PortfolioDerivateController.isLoading.value
                                          ? CircularProgressIndicator()
                                          : PortfolioDerivateController.getDetailResultListItems3.isEmpty
                                          ? Text("0.0", style: Utils.fonts(color: Colors.black))
                                          : Text(
                                        '${Dataconstants.cur_Margin_Used ?? 0}',
                                        style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.darkGreenColor,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.darkGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                          color: Utils.greyColor.withOpacity(0.5),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: SvgPicture.asset('assets/appImages/portfolio/zero_equity.svg'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Commodity",
                                    style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return PortfolioDerivateController.isLoading.value
                                          ? CircularProgressIndicator()
                                          : PortfolioDerivateController.getDetailResultListItems2.isEmpty
                                          ? Text("0.0", style: Utils.fonts(color: Colors.black))
                                          : Text(
                                        '${Dataconstants.cdx_MTM_PL ?? 0}',
                                        style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                        ),
                                      );
                                    }),
                                    SizedBox(height: 10),
                                    Obx(() {
                                      return PortfolioDerivateController.isLoading.value
                                          ? CircularProgressIndicator()
                                          : PortfolioDerivateController.getDetailResultListItems2.isEmpty
                                          ? Text("0.0", style: Utils.fonts(color: Colors.black))
                                          : Text(
                                        '${Dataconstants.cdx_Margin_Used ?? 0}',
                                        style: Utils.fonts(
                                          fontWeight: FontWeight.w500,
                                          size: 14.0,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.darkGreenColor,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.darkGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                          color: Utils.greyColor.withOpacity(0.5),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: SvgPicture.asset('assets/appImages/portfolio/zero_equity.svg'),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Mutual Funds",
                                    style: Utils.fonts(fontWeight: FontWeight.w700, size: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return PortfolioEquityController.isLoading.value
                                          ? CircularProgressIndicator()
                                          : PortfolioEquityController.getPortfolioEquityListItems.isEmpty
                                          ? Text("0.00", style: Utils.fonts(color: Colors.black))
                                          : Text(
                                        '-',
                                        style: Utils.fonts(
                                          fontWeight: FontWeight.w700,
                                          size: 14.0,
                                        ),
                                      );
                                    }),
                                    SizedBox(height: 10),
                                    Obx(() {
                                      return PortfolioEquityController.isLoading.value
                                          ? CircularProgressIndicator()
                                          : PortfolioEquityController.getPortfolioEquityListItems.isEmpty
                                          ? Text("0.00", style: Utils.fonts(color: Colors.black))
                                          : Text(
                                        '-',
                                        style: Utils.fonts(
                                          fontWeight: FontWeight.w900,
                                          size: 14.0,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.darkGreenColor,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "-",
                                      style: Utils.fonts(
                                        fontWeight: FontWeight.w500,
                                        size: 14.0,
                                        color: Utils.darkGreenColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                          color: Utils.greyColor.withOpacity(0.5),
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
