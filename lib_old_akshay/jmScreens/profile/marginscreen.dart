import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:markets/screens/web_view_link_screen.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';

class MarginScreen extends StatefulWidget {
  const MarginScreen({Key key}) : super(key: key);

  @override
  State<MarginScreen> createState() => _MarginScreenState();
}

class _MarginScreenState extends State<MarginScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        elevation: 0,
        title: Text("Pledge Holdings",style: Utils.fonts(
            size: 18.0,
            color: Utils.blackColor,
            fontWeight: FontWeight.w500),),
      ),
      body: Container(
        height: 280,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
                Text("Margin Pledge",style: Utils.fonts(
                    size: 14.0,
                    color: Utils.blackColor,
                    fontWeight: FontWeight.w600)),
                SizedBox(width: 3,),
                Icon(Icons.info_outline_rounded,size: 14,)
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Text("ELIGIBLE MARGIN AGAINST HOLDINGS",style: Utils.fonts(
                        size: 10.0,
                        color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600
                    ),),
                    SizedBox(height: 3,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("₹",style: TextStyle(
                            fontFeatures: [FontFeature.superscripts()]),
                        ),
                        SizedBox(height: 30,),
                        Text("0",style: Utils.fonts(
                            size: 20.0,
                            color: Utils.blackColor,
                            fontWeight: FontWeight.w700
                        ),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.primaryColor),
                        ),
                        child: Text('UNPLEDGE', style: Utils.fonts(fontWeight: FontWeight.w600,size: 14.0,color: Utils.primaryColor)),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder:(context)=>WebViewLinkScreen(Dataconstants.clientTypeData["unpledge_url"],"UNPLEDGE")));
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      height: 45,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith((states) => Utils.primaryColor)
                        ),
                        child: Text('PLEDGE', style: Utils.fonts(fontWeight: FontWeight.w600,size: 14.0,color: Utils.whiteColor)),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder:(context)=>WebViewLinkScreen(Dataconstants.clientTypeData["pledge_url"],"PLEDGE")));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.work_outline,color: Utils.primaryColor,),
                  SizedBox(width: 15,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Margin Pledge transaction",style: Utils.fonts(size: 14.0,color: Utils.blackColor,fontWeight: FontWeight.w600)),
                      SizedBox(height: 3,),
                      Text("Pledge/unpledge Request details",
                        style: Utils.fonts(size: 11.0,color: Utils.blackColor,fontWeight: FontWeight.w500),),
                    ],
                  ),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_right_rounded,color: Colors.grey.shade600,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
