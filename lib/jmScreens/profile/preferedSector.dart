import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../util/CommonFunctions.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';
import '../mainScreen/MainScreen.dart';

class PreferredSector extends StatefulWidget {
  @override
  State<PreferredSector> createState() => _PreferredSectorState();
}

class _PreferredSectorState extends State<PreferredSector> {
  int index = 0;

  List preferredSector = [
    'All',
    'Nifty 50',
    'Nifty Midcap 150',
    'Nifty Smallcap 250',
    'Nifty Smallcap 100',
    'Nifty Large Midcap',
    'Nifty Mid Smallcap',
    'Nifty SME Emerge',
    'Nifty 100 Equal',
    'Nifty Alpha 50',
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 2,
        backgroundColor: Utils.whiteColor,
        title: Text(
          "Preferred Sector",
          style: Utils.fonts(
              size: 18.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
        ),
        elevation: 1,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Utils.greyColor,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              InAppSelection.mainScreenIndex = 1;
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (_) => MainScreen(
                    toChangeTab: false,
                  )), (route) => false);
            },
              child: SvgPicture.asset('assets/appImages/tranding.svg')),
          SizedBox(
            width: 15,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text('You can select any one preferred sector.',
                      style: Utils.fonts(
                          size: 11.0,
                          fontWeight: FontWeight.w400,
                          color: Utils.greyColor)),
                  Column(
                    children: List.generate(preferredSector.length, (index) {
                      return preferredSectorTitle(preferredSector[index], index);
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CommonFunction.saveAndCancelButton(
                    SaveText: 'Save',
                    cancelText: 'Cancel',
                    saveCall: () {
                      // Navigator.pop(context);
                    },
                    cancelCall: () {
                      Navigator.pop(context);
                    }
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget preferredSectorTitle(String title, int i) {
    return Column(
      children: [
        const SizedBox(
          height: 15,
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              index = i;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: Utils.fonts(
                      size: 14.0,
                      fontWeight: index == i ? FontWeight.w600 : FontWeight.w400,
                      color: index == i ? Utils.primaryColor : Utils.blackColor)),
              index == i
                  ? SvgPicture.asset('assets/appImages/checkbox_circle_blue.svg')
                  : Container(
                      height: 17,
                      width: 17,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Utils.greyColor,
                            width: 1,
                          )),
                    ),
            ],
          ),
        ),
        const SizedBox(height: 15,),
        Divider(thickness: 1,),
      ],
    );
  }
}
