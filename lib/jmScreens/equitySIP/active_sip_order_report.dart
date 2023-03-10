import 'package:flutter/material.dart';
import '../../style/theme.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';
import 'equity_sip_order_details.dart';

class ActiveSipOrderReport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) => ActiveSipRow()),
            const SizedBox(
              height: 15,
            ),
            CommonFunction.message('That’s all we have for you today'),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class ActiveSipRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => EquitySipOrderDetails(true)
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('TCS', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600)),
                const SizedBox(width: 5,),
                Text('NSE', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: ThemeConstants.buyColor,
                    borderRadius: BorderRadius.circular(3)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  child: Text('+12.5%', style: Utils.fonts(size: 13.0, fontWeight: FontWeight.w600, color: Utils.whiteColor) ),
                )
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SIP Date', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                    const SizedBox(height: 5,),
                    Text('13th', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600))
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
                        '25 Months',
                        style: Utils.fonts(
                            size: 14.0,
                            fontWeight: FontWeight.w600
                        )
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('SIP Qty', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                    const SizedBox(height: 5,),
                    Text('100', style: Utils.fonts(size: 14.0, fontWeight: FontWeight.w600))
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
