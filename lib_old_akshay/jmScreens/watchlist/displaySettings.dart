import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../CommonWidgets/switch.dart';
import 'editColumns.dart';
import 'pinIndices.dart';

class DisplaySettings extends StatefulWidget {
  const DisplaySettings({Key key}) : super(key: key);

  @override
  State<DisplaySettings> createState() => _DisplaySettingsState();
}

class _DisplaySettingsState extends State<DisplaySettings> {
  final _sparkLineController = ValueNotifier<bool>(Dataconstants.sparkLineArray[InAppSelection.marketWatchID]);
  // final _sparkLineController = ValueNotifier<bool>(false);
  // final _heatMapController = DataConstants.heatMapArray[InAppSelection.marketWatchID];
  final _heatMapController = ValueNotifier<bool>(Dataconstants.heatMapArray[InAppSelection.marketWatchID]);
  final _displayIndicesController = ValueNotifier<bool>(false);

  @override
  void initState() {
    // _sparkLineController.value = Dataconstants.sparkLine;

    // _sparkLineController.addListener(() async {
    //   SharedPreferences pref = await SharedPreferences.getInstance();
    //   setState(() {
    //     if (Dataconstants.sparkLine) {
    //       Dataconstants.sparkLine = false;
    //     } else {
    //       Dataconstants.sparkLine = true;
    //     }
    //     pref.setBool("sparkLine", Dataconstants.sparkLine);
    //   });
    // });
    _sparkLineController.addListener(() async {
      SharedPreferences pref = await SharedPreferences.getInstance();

      Dataconstants.sparkLineArray[InAppSelection.marketWatchID] = !Dataconstants.sparkLineArray[InAppSelection.marketWatchID];

      _sparkLineController.value = Dataconstants.sparkLineArray[InAppSelection.marketWatchID];
      pref.setString('sparkLine', jsonEncode(Dataconstants.heatMapArray));


      // setState(() {
      //   if (DataConstants.sparkLine) {
      //     DataConstants.sparkLine = false;
      //   } else {
      //     DataConstants.sparkLine = true;
      //   }
      //   pref.setBool("sparkLine", DataConstants.sparkLine);
      // });
    });
    _displayIndicesController.addListener(() {
      saveDisplayIndices();
      setState(() {
        Dataconstants.displayIndices = _displayIndicesController.value;
      });
    });
    _displayIndicesController.value = Dataconstants.displayIndices;

    // _heatMapController.value = Dataconstants.isHeatMap;

    _heatMapController.addListener(() async {
      Dataconstants.heatMapArray[InAppSelection.marketWatchID] = !Dataconstants.heatMapArray[InAppSelection.marketWatchID];
      _heatMapController.value = Dataconstants.heatMapArray[InAppSelection.marketWatchID];

      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('graphLists', jsonEncode(Dataconstants.heatMapArray));
      // pref.setBool("heatMap",DataConstants.heatMapArray);
      // setState(() {
      //   if (DataConstants.isHeatMap)
      //   {
      //     DataConstants.isHeatMap = false;
      //     // for(int i=0; i<4;i++){
      //     //   if(InAppSelection.tabsView[i][1].toString() == "predefined"){ setState(() {
      //     //     DataConstants.isPredefine=true;
      //     //   });} else if(InAppSelection.tabsView[i][1].toString() == "Holdings"){
      //     //     setState(() {
      //     //       DataConstants.isHolding=true;
      //     //     });
      //     //   } else {
      //     //     setState(() {
      //     //       DataConstants.isWatchlist=true;
      //     //     });
      //     //   }}
      //   } else
      //   // {DataConstants.isHeatMap = false;}
      //
      //   // else {
      //   //   DataConstants.isHeatMap = true;
      //   // }
      //       {
      //     // for(int i=0; i<4;i++){
      //     //   if(InAppSelection.tabsView[i][1].toString() == "predefined"){
      //     //     setState(() {
      //     //     DataConstants.isPredefine=true;
      //     //     });}
      //     //   else if(InAppSelection.tabsView[i][1].toString() == "Holdings"){
      //     //     setState(() {
      //     //       DataConstants.isHolding=true;
      //     //     });
      //     //   } else
      //     //   if(InAppSelection.tabsView[i][1].toString() == "watchlist"){
      //     //     setState(() {
      //     //       DataConstants.isWatchlist=true;
      //     //     });
      //     //   }
      //     //   // {
      //     //   //   setState(() {
      //     //   //     DataConstants.isWatchlist=true;
      //     //   //   });
      //     //   // }
      //     //   // InAppSelection.tabsView[i][1].toString() == "predefined"?DataConstants.isPredefine
      //     //   //     :InAppSelection.tabsView[i][1].toString() == "Holdings"?DataConstants.isHolding:DataConstants.isWatchlist;
      //     //   // // if(InAppSelection.marketWatchID)
      //     // }
      //     DataConstants.isHeatMap = true;
      //   }
      //
      //   pref.setBool("heatMap", DataConstants.isHeatMap);
      // });
    });



    // _heatMapController.addListener(() async {
    //   SharedPreferences pref = await SharedPreferences.getInstance();
    //   setState(() {
    //     if (Dataconstants.isHeatMap) {
    //       Dataconstants.isHeatMap = false;
    //     } else {
    //       Dataconstants.isHeatMap = true;
    //     }
    //     pref.setBool("heatMap", Dataconstants.isHeatMap);
    //   });
    // });

    super.initState();
  }

  saveDisplayIndices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("displayIndices", _displayIndicesController.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Display Settings",
          style: Utils.fonts(size: 16.0, color: Utils.blackColor),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Spark Line Display",
                      style: Utils.fonts(
                          size: 15.0,
                          color: Utils.blackColor,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SvgPicture.asset(
                      "assets/appImages/green_small_chart_shadow.svg",
                      width: 50,
                      height: 40,
                    ),
                  ],
                ),
                Spacer(),
                ToggleSwitch(
                    height: 22.0,
                    isBorder: false,
                    switchController: _sparkLineController,
                    activeColor: Utils.primaryColor.withOpacity(0.5),
                    inactiveColor: Utils.greyColor.withOpacity(0.3),
                    thumbColor: Dataconstants.sparkLineArray[InAppSelection.marketWatchID] == true
                        ? Utils.primaryColor
                        : Utils.greyColor)
              ],
            ),
            Divider(
              thickness: 2,
              color: Utils.greyColor.withOpacity(0.2),
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                Text(
                  "Heatmap View",
                  style: Utils.fonts(
                      size: 15.0,
                      color: Utils.blackColor,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 10,
                ),
                SvgPicture.asset("assets/appImages/heatmap.svg"),
                Spacer(),
                ToggleSwitch(
                    height: 22.0,
                    isBorder: false,
                    switchController: _heatMapController,
                    activeColor: Utils.primaryColor.withOpacity(0.5),
                    inactiveColor: Utils.greyColor.withOpacity(0.3),
                    thumbColor:  Dataconstants.heatMapArray[InAppSelection.marketWatchID] == true
                        ? Utils.primaryColor
                        : Utils.greyColor)
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Divider(
              thickness: 2,
              color: Utils.greyColor.withOpacity(0.2),
            ),
            SizedBox(
              height: 8.0,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PinIndicesOnTop()));
              },
              child: Row(
                children: [
                  Text(
                    "Pin Indices on Top",
                    style: Utils.fonts(
                        size: 15.0,
                        color: Utils.blackColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Spacer(),
                  ToggleSwitch(
                      height: 22.0,
                      isBorder: false,
                      switchController: _displayIndicesController,
                      activeColor: Utils.primaryColor.withOpacity(0.5),
                      inactiveColor: Utils.greyColor.withOpacity(0.3),
                      thumbColor: _displayIndicesController.value == true
                          ? Utils.primaryColor
                          : Utils.greyColor)
                ],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Divider(
              thickness: 2,
              color: Utils.greyColor.withOpacity(0.2),
            ),
            SizedBox(
              height: 8.0,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditColumns()));
              },
              child: Row(
                children: [
                  Text(
                    "Edit Columns",
                    style: Utils.fonts(
                        size: 15.0,
                        color: Utils.blackColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Divider(
              thickness: 2,
              color: Utils.greyColor.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}
