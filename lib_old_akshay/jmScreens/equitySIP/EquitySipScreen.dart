import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../model/scrip_info_model.dart';
import '../../screens/search_bar_screen.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import 'equity_sip_order_report_screen.dart';
import 'equity_sip_order_screen.dart';
class EquitySipScreen extends StatefulWidget
{

  @override
  State<EquitySipScreen> createState() => _EquitySipScreenState();

}
class _EquitySipScreenState extends State<EquitySipScreen>
{

  int _value = 20000;
  int period = 1;
  List<String> items = ['Daily', 'Weekly', 'Monthly'];
  String dropdownValue = 'Monthly';
  var clientCode,sessionToken;

  @override
  void initState() {
    super.initState();
    Dataconstants.isSip = false;
    clientCode = Dataconstants.feUserID;
    sessionToken = Dataconstants.loginData.data.jwtToken;
    print("data inside: ${clientCode} ${sessionToken}  ");

  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        // bottom: 2,
        bottomOpacity: 2,
        backgroundColor: Utils.whiteColor,
        title: Text(
          "Equity SIP",
          style: Utils.fonts(
              size: 18.0,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyText1.color),
        ),
        elevation: 1,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Utils.greyColor,
            // size: 1,
          ),
        ),
        actions: [
          InkWell(
              onTap: () {},
              child: SvgPicture.asset("assets/appImages/tranding.svg")),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Image.asset('assets/appImages/start_sip.png'),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 2,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Top Performing SIPs',
                        style: Utils.fonts(
                            size: 18.0,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyText1.color),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Utils.greyColor.withOpacity(0.2),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Utils.greyColor,
                          size: 11,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: width * 0.2,
                          child: Text(
                            'Symbol',
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w400,
                                color: Utils.greyColor),
                          )),
                      Text(
                        'LTP',
                        style: Utils.fonts(
                            size: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.greyColor),
                      ),
                      Text(
                        '1Y Rtn',
                        style: Utils.fonts(
                            size: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.greyColor),
                      ),
                    ],
                  ),
                  topPerformingTile(
                      sipName: 'RELIANCE',
                      ltp: '2750',
                      returnVal: '39.5',
                      width: width,
                      theme: theme),
                ],
              ),
            ),
            Divider(
              thickness: 2,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'My Ongoing SIPs',
                        style: Utils.fonts(
                            size: 18.0,
                            fontWeight: FontWeight.w600,
                            color: theme.textTheme.bodyText1.color),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EquitySipOrderReportScreen()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Utils.greyColor.withOpacity(0.2),
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            // color: Utils.greyColor,
                            size: 11,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                          padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Color(0xffff8800).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "6 SIPs",
                            style: Utils.fonts(
                                size: 12.0,
                                fontWeight: FontWeight.w500,
                                color: Color(0xffff8800)),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 116,
                    child: ListView.builder(
                        physics: CustomTabBarScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 3,
                        itemBuilder: (context, index) => ongoingTile(theme)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 2,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SIP Calculator',
                    style: Utils.fonts(
                        size: 18.0,
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyText1.color),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        'I want to start SIP in',
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.greyColor),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Dataconstants.isSip = true;
                          // DataConstants.isComingFromMarginCalculator = true;
                          showSearch(
                            context: context,
                            delegate:
                            SearchBarScreen(InAppSelection.marketWatchID),
                          ).then((value) {
                            setState(() {
                              // DataConstants.isComingFromMarginCalculator = false;
                            });
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Utils.greyColor.withOpacity(0.2)),
                          child: Row(
                            children: [
                              Text(
                                'Search',
                                style: Utils.fonts(
                                    size: 14.0,
                                    fontWeight: FontWeight.w500,
                                    color: theme.textTheme.bodyText1.color),
                              ),
                              SvgPicture.asset('assets/appImages/search.svg'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
              Container(
                height: 32,
                padding: EdgeInsets.only(top: 5, bottom: 5, left: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Utils.greyColor.withOpacity(0.2)),
                child: DropdownButton<String>(
                  value: dropdownValue, // set the default value here
                  items: items.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.bodyText1.color),
                      ),
                    );
                  }).toList(),
                  underline: SizedBox(),
                  hint: Text(
                    'Monthly',
                    style: Utils.fonts(
                        size: 12.0,
                        fontWeight: FontWeight.w500,
                        color: theme.textTheme.bodyText1.color),
                  ),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                  onChanged: (val) {
                    setState(() {
                      dropdownValue = val; // update the selected value here
                    });
                  },
                ),
              )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Text(
                        _value.toString(),
                        style: Utils.fonts(
                            size: 18.0, color: theme.textTheme.bodyText1.color),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Monthly SIP for',
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.greyColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Slider(
                    min: 0.0,
                    max: 100000.0,
                    value: _value.toDouble(),
                    activeColor: Utils.primaryColor,
                    inactiveColor: Utils.greyColor.withOpacity(0.2),
                    onChanged: (value) {
                      setState(() {
                        _value = value.toInt();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0',
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.greyColor),
                      ),
                      Text(
                        '1,00,000',
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.greyColor),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Period of',
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.greyColor),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            period = 1;
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: period == 1
                                    ? Utils.primaryColor.withOpacity(0.2)
                                    : Colors.transparent),
                            child: Text(
                              '1 Year',
                              style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: period == 1
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: period == 1
                                      ? Utils.primaryColor
                                      : Utils.greyColor),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            period = 2;
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: period == 2
                                    ? Utils.primaryColor.withOpacity(0.2)
                                    : Colors.transparent),
                            child: Text(
                              '3 Years',
                              style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: period == 2
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: period == 2
                                      ? Utils.primaryColor
                                      : Utils.greyColor),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            period = 3;
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: period == 3
                                    ? Utils.primaryColor.withOpacity(0.2)
                                    : Colors.transparent),
                            child: Text(
                              '5 Years',
                              style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: period == 3
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: period == 3
                                      ? Utils.primaryColor
                                      : Utils.greyColor),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            period = 4;
                          });
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: period == 4
                                    ? Utils.primaryColor.withOpacity(0.2)
                                    : Colors.transparent),
                            child: Text(
                              '10 Years',
                              style: Utils.fonts(
                                  size: 12.0,
                                  fontWeight: period == 4
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: period == 4
                                      ? Utils.primaryColor
                                      : Utils.greyColor),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Total Investment of 2,40,000 for 1 year in RELIANCE',
                    style: Utils.fonts(
                        size: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Utils.greyColor),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RichText(
                      text: TextSpan(
                          text: 'would have become 3,25,122 ',
                          style: Utils.fonts(
                              size: 16.0,
                              color: theme.textTheme.bodyText1.color),
                          children: [
                            TextSpan(
                              text: '(+25.61%)',
                              style: Utils.fonts(
                                  size: 16.0, color: ThemeConstants.buyColor),
                            )
                          ])),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: width * 0.6,
                      margin: Platform.isIOS
                          ? const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 70)
                          : const EdgeInsets.all(10),
                      child: ButtonTheme(
                        padding: const EdgeInsets.symmetric(vertical: 17),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Utils.primaryColor,
                            shape: StadiumBorder(),
                          ),
                          child: Text(
                            'Start SIP',
                            style: Utils.fonts(color: Utils.whiteColor),
                          ),
                          onPressed: () {
                            {
                              ScripInfoModel model =
                              CommonFunction.getScripDataModel(
                                exch: 'N',
                                exchCode: 22,
                                sendReq: true,
                                getNseBseMap: true,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EquitySipOrderScreen(model: model),

                                ),
                              );
                              print("Script Data  $model");
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topPerformingTile(
      {
        String sipName,
        String ltp,
        String returnVal,
        double width,
        ThemeData theme
      }
      )
  {
    return Column(
      children: [
        Divider(
          thickness: 1,
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: width * 0.2,
                child: Text(
                  sipName,
                  style: Utils.fonts(
                      size: 15.0,
                      fontWeight: FontWeight.w500,
                      color: theme.textTheme.bodyText1.color),
                )),
            Text(
              ltp,
              style: Utils.fonts(
                  size: 15.0,
                  fontWeight: FontWeight.w400,
                  color: theme.textTheme.bodyText1.color),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: ThemeConstants.buyColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "$returnVal%",
                  style:
                  Utils.fonts(size: 15.0, color: ThemeConstants.buyColor),
                ))
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget ongoingTile(ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 180,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Utils.greyColor.withOpacity(0.2))),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RELIANCE',
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w500,
                            color: theme.textTheme.bodyText1.color),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        'NSE',
                        style: Utils.fonts(
                            size: 11.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.greyColor),
                      ),
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: ThemeConstants.buyColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        "+12.5%",
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w500,
                            color: Utils.whiteColor),
                      )),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount',
                        style: Utils.fonts(
                            size: 11.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.greyColor),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '1000',
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400,
                            color: theme.textTheme.bodyText1.color),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next SIP',
                        style: Utils.fonts(
                            size: 11.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.greyColor),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '15 May',
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400,
                            color: theme.textTheme.bodyText1.color),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          width: 15,
        ),
      ],
    );
  }
}
