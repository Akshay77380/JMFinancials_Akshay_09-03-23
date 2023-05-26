import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';

import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import '../../widget/scripdetail_optionChain.dart';

class OptionsPage extends StatefulWidget {

  bool bankNifty = false;
  OptionsPage(this.bankNifty);

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {

  var optionChainVar = 1;
  static List<int> optionDates;

  @override
  void initState() {

    optionDates = Dataconstants.exchData[1].getDatesForOptions(Dataconstants.indicesListener.indices1);
    // TODO: implement initState
    super.initState();
    setState(() {
      widget.bankNifty ? optionChainVar = 2 : optionChainVar = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Options", style: Utils.fonts(
              color: Utils.blackColor,
              size: 20.0
          ))
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            optionChainVar == 1 ? optionChainVar = 2 : optionChainVar = 1;
                            optionDates = Dataconstants.exchData[1].getDatesForOptions(Dataconstants.indicesListener.indices1);
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                    color: optionChainVar == 1 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  top: BorderSide(
                                    color: optionChainVar == 1 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: optionChainVar == 1 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: optionChainVar == 1 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "NIFTY",
                                style: Utils.fonts(size: 12.0, color: optionChainVar == 1 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              ),
                            )),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            optionChainVar == 1 ? optionChainVar = 2 : optionChainVar = 1;
                            optionDates = Dataconstants.exchData[1].getDatesForOptions(Dataconstants.indicesListener.indices3);
                          });
                        },
                        child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                    color: optionChainVar == 2 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  bottom: BorderSide(
                                    color: optionChainVar == 2 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  right: BorderSide(
                                    color: optionChainVar == 2 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  ),
                                  left: BorderSide(
                                    color: optionChainVar == 2 ? Utils.primaryColor : Utils.greyColor,
                                    width: 1,
                                  )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "BANKNIFTY",
                                style: Utils.fonts(size: 12.0, color: optionChainVar == 2 ? Utils.primaryColor : Utils.greyColor, fontWeight: FontWeight.w500),
                              ),
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Observer(builder: (_) {
              if (Dataconstants.indicesListener == null)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else {
                if (optionDates.length == 0) optionDates = Dataconstants.exchData[1].getDatesForOptions(Dataconstants.indicesListener.indices1);
                return Column(
                  children: [
                    if (optionChainVar == 1)
                      Container(
                          height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, child: ScripdetailOptionChain(Dataconstants.indicesListener.indices1, optionDates, 0, "0"))
                    else
                      SizedBox.shrink(),
                    if (optionChainVar == 2)
                      Container(
                          height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width, child: ScripdetailOptionChain(Dataconstants.indicesListener.indices3, optionDates, 0, "0"))
                    else
                      SizedBox.shrink()
                  ],
                );
              }
            }),
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
