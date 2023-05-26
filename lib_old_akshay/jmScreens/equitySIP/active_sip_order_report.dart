import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:googleapis/shared.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:markets/jmScreens/ScriptInfo/bar_chart.dart';
import '../../model/scrip_info_model.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';
import 'equity_sip_order_details.dart';
import '../../util/Dataconstants.dart';
import 'package:flutter/src/widgets/framework.dart';
// class ActiveSipOrderReport extends StatelessWidget
// {
//   // final ScripInfoModel model;
//
//   @override
//   Widget build(BuildContext context) {
//
//     return FutureBuilder<List<dynamic>>(
//
//       future: getActiveSips(Dataconstants.feUserID,Dataconstants.loginData.data.jwtToken),
//
//       builder: (context, snapshot)
//       {
//         if (snapshot.hasData)
//         {
//           final dataList = snapshot.data.where((item) => item['InstructionState'] == 'A').toList();
//           Dataconstants.active_counter.value = dataList.length;
//           return Scaffold(
//             body: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: dataList.length,
//                     itemBuilder: (context, index) =>
//                         ActiveSipRow(data: dataList[index]),
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   CommonFunction.message('That’s all we have for you today'),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         } else if (snapshot.hasError) {
//           return Scaffold(
//             body: Center(
//               child: Text('Error: ${snapshot.error}'),
//             ),
//           );
//         } else {
//           return Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//       },
//     );
//   }
class ActiveSipOrderReport extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getActiveSips(
          Dataconstants.feUserID, Dataconstants.loginData.data.jwtToken),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final dataList = snapshot.data.where((
              item) => item['InstructionState'] == 'A').toList();
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Dataconstants.active_counter.value = dataList.length;

          });
          return ValueListenableBuilder<int>(
            valueListenable: Dataconstants.active_counter,
            builder: (context, value, child) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: dataList.length,
                      itemBuilder: (context, index) =>
                          ActiveSipRow(data: dataList[index]),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CommonFunction.message('That’s all we have for you today'),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  }
  Future<List<dynamic>> getActiveSips(String clientCode, String sessionToken) async
  {
    final url = Uri.parse('https://tradeapiuat.jmfonline.in/tools/Report/api/sip/FetchAll');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'ClientCode': clientCode, 'SessionToken': sessionToken});
    final response = await http.post(url, headers: headers, body: body);
    print("response data ${response.body}");
    print("response body data${body}");
    if (response.statusCode == 200)
    {

      return jsonDecode(response.body);
    }
    else
    {
      throw Exception('Failed to fetch active SIPs');
    }
  }


class ActiveSipRow extends StatelessWidget
{
  ScripInfoModel model = ScripInfoModel();
  final dynamic data;
  final Function() onSipsUpdated;

  ActiveSipRow({Key key, this.data,this.model,this.onSipsUpdated}) : super(key: key);
  @override
  Widget build(BuildContext context)
  {
    final symbol = data['Symbol'], exch = data['Exch'],Sip_Startdate = data['StartDate'],Sip_ExpiryDate = data['ExpiryDate'],Sip_NextDate = data['NextTradeDate'],Sip_Qty = data['Qty'],Sip_OrderValue = data['Value'],instructState = data['InstructionState'],Sip_ReferenceID =data['InstID'],Sip_BuyExchRate = data['BuyExchTradedRate'],ScripCode = data['ScripCode'];
    var sipStatus;
      model = CommonFunction.getScripDataModel(exch: exch, exchCode: ScripCode);
      print('Data script$model');
    if(instructState == 'A')
    {
      sipStatus = "ACTIVE";
    }
    else if(instructState == 'P')
    {
      sipStatus = "PAUSE";
    }
    else if(instructState == 'E')
    {
      sipStatus = "EXPIRED";
    }
    else
    {
      sipStatus = "null";
    }
    DateFormat format = DateFormat('yyyy-MM-ddTHH:mm:ss');
    DateTime startDate ,endDate;
    startDate = format.parse(Sip_Startdate);
    endDate = format.parse(Sip_ExpiryDate);
    int  sipPeriod = ((endDate.difference(startDate).inDays) / 30).floor();

    // print("sip perid :$sipPeriod");
    // print("model data:${model.percentChangeText}");
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => EquitySipOrderDetails(status: true,qty: Sip_Qty,avgPrice: Sip_BuyExchRate,sipStatus: sipStatus,symbol: symbol,price:Sip_OrderValue,percentChangeText: -22,sipReferenceId: Sip_ReferenceID,frequency: 'Monthly',period: sipPeriod,sipType: 'Quantity',startDate: Sip_Startdate,nextDate: Sip_NextDate,endDate:Sip_ExpiryDate),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('$symbol', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600)),
                const SizedBox(width: 10,),
                Text('${exch == 'N' ? 'NSE' : 'BSE'}', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: ThemeConstants.buyColor,
                      borderRadius: BorderRadius.circular(3)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Text('+0.00%', style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w600, color: Utils.whiteColor,) ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SIP Date',
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400, color: Utils.greyColor)),
                    const SizedBox(height: 5,),
                    Text('${Sip_Startdate.toString().substring(0, 10)}', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                        'SIPs Done',
                        style: Utils.fonts(
                            size: 12.0,
                            fontWeight: FontWeight.w400,
                            color: Utils.greyColor
                        )
                    ),
                    const SizedBox(height: 5,),
                    Text(
                        '$sipPeriod Months',
                        style: Utils.fonts(
                            size: 14.0,
                            fontWeight: FontWeight.w600
                        )
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('SIP Qty', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                    const SizedBox(height: 5,),
                    Text('$Sip_Qty', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600))
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
