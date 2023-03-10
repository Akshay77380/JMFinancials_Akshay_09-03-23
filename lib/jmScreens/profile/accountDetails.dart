import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../util/Dataconstants.dart';
import '../../util/InAppSelections.dart';
import '../../util/Utils.dart';

class AccountDetails extends StatefulWidget {
  @override
  State<AccountDetails> createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails> {
  List eqSegments = [], fnoSegments = [], names = [];

  @override
  void initState() {
    List segments = InAppSelection.profileData['activesegments'].toString().split("|");
    for (int i = 0; i < segments.length; i++) {
      if (segments[i].toString().toUpperCase() == 'NSE' || segments[i].toString().toUpperCase() == 'BSE')
        eqSegments.add(segments[i]);
      else
        fnoSegments.add(segments[i]);
    }
    names = InAppSelection.profileData['name'].toString().split(" ");
    super.initState();
  }

  Future<bool> handleWillPop(BuildContext context) async {
    if (Dataconstants.profileSelectedIndex != 0) {
      setState(() {
        Dataconstants.profileSelectedIndex = 0;
      });
      Dataconstants.profilePageController.add(true);
      // Navigator.of(context).pop();
      return true;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: WillPopScope(
        onWillPop: () => handleWillPop(context),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: size.width,
                  height: 160,
                  padding: EdgeInsets.all(10),
                  color: Utils.primaryColor.withOpacity(0.2),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 105,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              backgroundColor: Utils.primaryColor.withOpacity(0.5),
                              radius: 45,
                              child: Text(
                                names.map((e) => e.toString().characters.first).toString().replaceAll("(", "").replaceAll(")", "").replaceAll(", ", ""),
                                style: Utils.fonts(size: 24.0, fontWeight: FontWeight.w600, color: Utils.whiteColor),
                              ),
                            ),
                            Positioned(
                              bottom: 30,
                              right: 0,
                              child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: Utils.whiteColor, shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.camera_alt_rounded,
                                    color: Utils.primaryColor,
                                    size: 20,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(InAppSelection.profileData['name'],
                          style: Utils.fonts(
                            size: 18.0,
                            fontWeight: FontWeight.w500,
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Text('Good Afternoon', style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Client ID', style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(InAppSelection.profileData['clientcode'].toString(),
                              style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w600,
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('PAN Number', style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: 8,
                              ),
                              Icon(
                                Icons.circle,
                                size: 8,
                              ),
                              Icon(
                                Icons.circle,
                                size: 8,
                              ),
                              Icon(
                                Icons.circle,
                                size: 8,
                              ),
                              Icon(
                                Icons.circle,
                                size: 8,
                              ),
                              Icon(
                                Icons.circle,
                                size: 8,
                              ),
                              Icon(
                                Icons.circle,
                                size: 8,
                              ),
                              Text(
                                  InAppSelection.profileData['pannumber'].toString()[InAppSelection.profileData['pannumber'].toString().length - 3] +
                                      InAppSelection.profileData['pannumber'].toString()[InAppSelection.profileData['pannumber'].toString().length - 2] +
                                      InAppSelection.profileData['pannumber'].toString()[InAppSelection.profileData['pannumber'].toString().length - 1],
                                  style: Utils.fonts(
                                    size: 14.0,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DP ID', style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(InAppSelection.profileData['dpid'] == null ? '' : InAppSelection.profileData['dpid'],
                              style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w600,
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('DOB', style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(InAppSelection.profileData['dob'],
                              style: Utils.fonts(
                                size: 14.0,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bank Details', style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/appImages/icici.png',
                            height: 30,
                            width: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ICICI Bank",
                                style: Utils.fonts(
                                  size: 14.0,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.circle, size: 8, color: Utils.greyColor.withOpacity(0.8)),
                                  Icon(Icons.circle, size: 8, color: Utils.greyColor.withOpacity(0.8)),
                                  Icon(Icons.circle, size: 8, color: Utils.greyColor.withOpacity(0.8)),
                                  Icon(Icons.circle, size: 8, color: Utils.greyColor.withOpacity(0.8)),
                                  Icon(Icons.circle, size: 8, color: Utils.greyColor.withOpacity(0.8)),
                                  Icon(Icons.circle, size: 8, color: Utils.greyColor.withOpacity(0.8)),
                                  Icon(Icons.circle, size: 8, color: Utils.greyColor.withOpacity(0.8)),
                                  Icon(Icons.circle, size: 8, color: Utils.greyColor.withOpacity(0.8)),
                                  Icon(Icons.circle, size: 8, color: Utils.greyColor.withOpacity(0.8)),
                                  Icon(Icons.circle, size: 8, color: Utils.greyColor.withOpacity(0.8)),
                                  Text(
                                    "2334",
                                    style: Utils.fonts(size: 14.0, color: Utils.greyColor.withOpacity(0.8), fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Active Segments', style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w500, color: Utils.greyColor)),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Equity',
                                      style: Utils.fonts(
                                        size: 13.0,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SvgPicture.asset('assets/appImages/checkbox_circle_green.svg'),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(eqSegments.map((e) => e).toString().replaceAll("(", "").replaceAll(")", ""),
                                  style: Utils.fonts(
                                    size: 14.0,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('F&O',
                                      style: Utils.fonts(
                                        size: 13.0,
                                        fontWeight: FontWeight.w400,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  SvgPicture.asset('assets/appImages/checkbox_circle_green.svg'),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: 150,
                                child: Text(fnoSegments.map((e) => e).toString().replaceAll("(", "").replaceAll(")", ""),
                                    style: Utils.fonts(
                                      size: 14.0,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
