import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markets/util/Dataconstants.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';

class SebiMtfLedger extends StatefulWidget {
  const SebiMtfLedger({Key key}) : super(key: key);

  @override
  State<SebiMtfLedger> createState() => _SebiMtfLedgerState();
}

class _SebiMtfLedgerState extends State<SebiMtfLedger> with SingleTickerProviderStateMixin {

  TabController _tabController;
  int _currentIndex = 0;
  List<String> _productItems = ['data1', 'data2', 'data3'];
  String _productType = 'Last 10 Days (1 Apr to 10 Apr)';
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this)
      ..addListener(() {
        setState(() {
          _currentIndex = _tabController.index;
        });
      });
    _tabController.index = Dataconstants.tradeScreenIndex;
    // TODO: implement initState
    super.initState();
  }
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
          "SEBI MTF Ledger",
          style: Utils.fonts(color: Utils.greyColor, size: 18.0),
        ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "View SEBI MTF Ledger for",
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _productType,
                          style: Utils.fonts(size: 14.0, color: theme.textTheme.bodyText1.color),
                        ),
                        Text(
                          'Short Description',
                          style: Utils.fonts(fontWeight: FontWeight.w500, size: 12.0, color: theme.textTheme.bodyText1.color),
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
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        "NSE",
                        style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w500,color: Utils.primaryColor),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SvgPicture.asset(
                        'assets/appImages/down_arrow.svg',
                        color: Utils.primaryColor,
                      ),
                    ],
                  ),
                  SvgPicture.asset(
                    'assets/appImages/download.svg',
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Voucher Date",
                        style: Utils.fonts(
                            size: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Utils.greyColor.withOpacity(0.8)),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        "Effective Date",
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Dr./Cr.(Rs)",
                        style: Utils.fonts(
                            size: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Utils.greyColor.withOpacity(0.8)),
                      ),
                      SizedBox(height: 5,),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Net Balance(Rs.)",
                        style: Utils.fonts(
                            size: 14.0,
                            fontWeight: FontWeight.w500,
                            color: Utils.greyColor.withOpacity(0.8)
                        ),
                      ),
                      SizedBox(height: 5,),

                    ],
                  ),
                ],
              ),
              Divider(
                thickness: 2,
              ),
              ListView.builder(
                itemCount: 2,
                shrinkWrap: true,
                  itemBuilder: (context, index) => sebiMTFRow()),
              SizedBox(
                height: 10,
              ),
              CommonFunction.message("That's all we have for you today")
            ],
          ),
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
    );
  }
}

class sebiMTFRow extends StatelessWidget {
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
        margin: EdgeInsets.symmetric(horizontal: 15),
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
                    Text('21 Jan 2022', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 5,),
                    Text('21 Jan 2022', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('-', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.blackColor)),
                    // const SizedBox(height: 5,),
                    // Text('25 Months', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('-', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.blackColor)),
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