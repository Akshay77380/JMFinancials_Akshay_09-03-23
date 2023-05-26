
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../screens/search_bar_screen.dart';
import '../../style/theme.dart';
import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import 'basketSearchScreen.dart';

class BasketModifyAndAdd extends StatefulWidget {
  final String basketName;
  final String series;
  final String noOfInstrument;
  final String date;

  const BasketModifyAndAdd(
      {this.basketName, this.series, this.noOfInstrument, this.date, Key key})
      : super(key: key);

  @override
  State<BasketModifyAndAdd> createState() => _BasketModifyAndAddState();
}

class _BasketModifyAndAddState extends State<BasketModifyAndAdd> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: theme.appBarTheme.color,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 25),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: SvgPicture.asset(
                                      'assets/images/Basket/arrow.svg')),
                              SizedBox(
                                width: 25,
                              ),
                              SvgPicture.asset(
                                  'assets/images/Basket/basket.svg'),
                              SizedBox(
                                width: 10,
                              ),
                              Text("${widget.basketName}"),
                              SizedBox(
                                width: 25,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    // Dataconstants.itsClient.basketOrderForFno(
                                    //   series: widget.series,
                                    //   symbol: widget.basketName,
                                    //   requestType: 'N',
                                    //   exchCode: 'NFO',
                                    // );
                                  },
                                  child: SvgPicture.asset(
                                      'assets/images/Basket/edit.svg')),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${widget.noOfInstrument}/20 items',
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.0),
                              ),
                              Text('Created on ${widget.date}',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.0)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  height: 130,
                  width: width,
                ),
                Card(
                  color: theme.accentColor,
                  margin: EdgeInsets.only(
                    left: 10,
                    top: 105,
                    right: 10,
                    bottom: 4,
                  ),
                  elevation: 5,
                  child: Container(
                    height: 48,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text("No items in Basket",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: TextField(
                    onTap: () {
                      showSearch(
                          context: context,
                          delegate:
                              SearchBarScreen(InAppSelection.marketWatchID));
                    },
                    decoration: InputDecoration(
                        hintText: "Search and add",
                        hintStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                        icon: SvgPicture.asset(
                            'assets/images/Basket/search_on_edit_add.svg'),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none),
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 250,
                ),
                Center(
                    child: GestureDetector(
                      onTap: (){
                       showSearch(context: context, delegate: basketSearchScreen());
                      },
                      child: Text.rich(
                  TextSpan(
                      children: [
                        TextSpan(
                          text: 'Use ',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0),
                        ),
                        TextSpan(
                          text: ' Search ',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                        ),
                        TextSpan(
                          text: ' to add instrument',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0),
                        ),
                      ],
                  ),
                ),
                    )),
              ],
            )
          ],
        ),
      ),
    );
  }
}
