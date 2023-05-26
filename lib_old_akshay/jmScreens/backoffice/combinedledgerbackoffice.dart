import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';
import 'dart:math' as math;

class CombinedLedgerBackoffice extends StatefulWidget {
  const CombinedLedgerBackoffice({Key key}) : super(key: key);

  @override
  State<CombinedLedgerBackoffice> createState() => _CombinedLedgerBackofficeState();
}

class _CombinedLedgerBackofficeState extends State<CombinedLedgerBackoffice> {


  List<String> _productItems = ['data1', 'data2', 'data3'];
  String _productType = 'Last 10 Days (1 Apr to 10 Apr)';

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text(
          "Combined Ledger",
          style: Utils.fonts(color: Utils.greyColor, size: 18.0),
        ),
      ),
      floatingActionButton: Container(
        width: 100,
        height: 35,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Utils.primaryColor.withOpacity(0.5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Date",
              style: TextStyle(
                  fontSize: 18,
                  color: Utils.whiteColor
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              width: 5,
            ),
            SvgPicture.asset(
              'assets/appImages/uparrow.svg',
              width: 15,
              height: 15,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "View Combined Ledger for",
                style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 55,
                width: size.width,
                padding: EdgeInsets.only(top: 10, bottom: 5, left: 15, right: 10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Utils.dullWhiteColor),
                child: DropdownButton<String>(
                    isExpanded: true,
                    items: _productItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                        ),
                        onTap: () {
                          //TODO:
                        },
                      );
                    }).toList(),
                    underline: SizedBox(),
                    hint: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _productType,
                          style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                        ),
                      ],
                    ),
                    icon: Icon(
                      // Add this
                      Icons.arrow_drop_down, // Add this
                      color: Theme.of(context).textTheme.bodyText1.color, // Add this
                    ),
                    onChanged: (val) {
                      setState(() {
                        _productType = val;
                      });
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "NSE",
                        style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w600),
                      ),
                      SvgPicture.asset(
                        'assets/appImages/download.svg',
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Cheque/Ref.no",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Dr./Cr.(Rs)",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Net Balance(Rs.)",
                            style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w500,
                                color: Utils.greyColor.withOpacity(0.8)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              ListView.builder(
                  itemCount: 2,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => combinedLedgerRow()),
              SizedBox(height: 20,),
              CommonFunction.message("That's all we have for you today")
            ],
          ),
        ),
      ),
    );
  }
}

class combinedLedgerRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // showModalBottomSheet(
        //     isScrollControlled: true,
        //     context: context,
        //     backgroundColor: Colors.transparent,
        //     builder: (context) => EquitySipOrderDetails(false));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('10 Mar 2022', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 5,),
                    Text('206984365417', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('500.00', style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w500, color: Utils.brightGreenColor)),
                    // const SizedBox(height: 5,),
                    // Text('25 Months', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('500.00', style: Utils.fonts(size: 16.0, fontWeight: FontWeight.w500, color: Utils.blackColor)),
                    // const SizedBox(height: 5,),
                    // Text('100', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600))
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Divider(thickness: 1,),
          ],
        ),
      ),
    );
  }
}
