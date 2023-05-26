import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:markets/util/CommonFunctions.dart';
import 'package:markets/widget/custom_tab_bar.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';

class BuildUpScanner extends StatefulWidget {
  final List<String> selectedTabIndex;

  const BuildUpScanner({Key key, this.selectedTabIndex}) : super(key: key);

  @override
  State<BuildUpScanner> createState() => _BuildUpScannerState();
}

class _BuildUpScannerState extends State<BuildUpScanner>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<Tab> _tabList = [];
  AnimationController _controller;
  TabController buildUpScanner;

  @override
  void initState() {
    buildUpScanner = TabController(length: 9, vsync: this);
    // buildUpScanner.
    super.initState();
    buildUpScanner.animateTo(widget.selectedTabIndex[1] == "BuildUp" ? 8 : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Row(
          children: [
            Text(
              "Scanners",
              style: Utils.fonts(color: Utils.blackColor, size: 18.0),
            ),
            Icon(
              Icons.arrow_drop_down_rounded,
              color: Utils.greyColor,
            ),
            Icon(
              Icons.rotate_90_degrees_ccw,
              color: Utils.greyColor,
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: 20,
          ),
          InkWell(
              onTap: () {},
              child: SvgPicture.asset('assets/appImages/tranding.svg')),
          SizedBox(
            width: 10,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Expanded(
            child: TabBar(
              isScrollable: true,
              // physics: NeverScrollableScrollPhysics(),
              labelStyle: Utils.fonts(size: 14.0, fontWeight: FontWeight.w700),
              unselectedLabelStyle:
                  Utils.fonts(size: 14.0, fontWeight: FontWeight.w400),
              unselectedLabelColor: Colors.grey[600],
              labelColor: Utils.primaryColor,
              indicatorPadding: EdgeInsets.zero,
              labelPadding: EdgeInsets.symmetric(horizontal: 20),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 0,
              indicator: BubbleTabIndicator(
                indicatorHeight: 40.0,
                insets: EdgeInsets.symmetric(horizontal: 2),
                indicatorColor: Utils.primaryColor.withOpacity(0.3),
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              controller: buildUpScanner,
              tabs: [
                Tab(
                  child: Text(
                    "Rising & Falling",
                    style: Utils.fonts(size: _currentIndex == 0 ? 13.0 : 11.0),
                  ),
                ),
                Tab(
                  child: Text(
                    "High & Low Breaker",
                    style: Utils.fonts(size: _currentIndex == 1 ? 13.0 : 11.0),
                  ),
                ),
                Tab(
                  child: Text(
                    "Strong & Weak",
                    style: Utils.fonts(size: _currentIndex == 2 ? 13.0 : 11.0),
                  ),
                ),
                Tab(
                  child: Text(
                    "Circuit Breaker",
                    style: Utils.fonts(size: _currentIndex == 2 ? 13.0 : 11.0),
                  ),
                ),
                Tab(
                  child: Text(
                    "Volume Shocker",
                    style: Utils.fonts(size: _currentIndex == 2 ? 13.0 : 11.0),
                  ),
                ),
                Tab(
                  child: Text(
                    "Open High Or Low",
                    style: Utils.fonts(size: _currentIndex == 2 ? 13.0 : 11.0),
                  ),
                ),
                Tab(
                  child: Text(
                    "Resistant and Support",
                    style: Utils.fonts(size: _currentIndex == 2 ? 13.0 : 11.0),
                  ),
                ),
                Tab(
                  child: Text(
                    "Spreads",
                    style: Utils.fonts(size: _currentIndex == 2 ? 13.0 : 11.0),
                  ),
                ),
                Tab(
                  child: Text(
                    "Buildup",
                    style: Utils.fonts(size: _currentIndex == 2 ? 13.0 : 11.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: buildUpScanner,
        children: [
          RisingFalling(),
          HighLowBreaker(),
          StrongWeak(),
          CircuitBreaker(),
          VolumeShocker(),
          OpenHighLow(),
          ResistanceSupport(),
          Spreads(),
          BuildupWidget()
        ],
      ),
    );
  }
}

class BuildupWidget extends StatefulWidget {
  final int index;

  const BuildupWidget({Key key, this.index}) : super(key: key);

  @override
  State<BuildupWidget> createState() => _BuildupWidgetState();
}

class _BuildupWidgetState extends State<BuildupWidget>
    with TickerProviderStateMixin {
  TabController controller;
  bool isLongUnwindSelected = true,
      islongBuildUpSelected = false,
      isShortBuildupSelected = false,
      isShortunwindSelected = false;

  // bool isLongBuildupClicked= false,isLongUnwindClicked =false,isShortbuildUpClicked = false,isShortUnwindClicked = false;
  @override
  void initState() {
    controller = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: TabBar(
            controller: controller,
            indicatorColor: Colors.transparent,
            indicatorPadding: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.symmetric(horizontal: 5),
            unselectedLabelColor: Utils.greyColor.withOpacity(0.5),
            labelColor: Utils.primaryColor,
            physics: CustomTabBarScrollPhysics(),
            isScrollable: true,
            tabs: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLongUnwindSelected = true;
                    islongBuildUpSelected = false;
                    isShortBuildupSelected = false;
                    isShortunwindSelected = false;
                  });
                },
                child: Container(
                  height: 35,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: isLongUnwindSelected
                            ? Utils.primaryColor
                            : Utils.greyColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                    child: Text(
                      "${OIBuiltUpType.LongUnwind.name}",
                      textAlign: TextAlign.center,
                      style: Utils.fonts(
                          size: 12.0,
                          color: isLongUnwindSelected
                              ? Utils.primaryColor
                              : Utils.greyColor.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLongUnwindSelected = false;
                    islongBuildUpSelected = true;
                    isShortBuildupSelected = false;
                    isShortunwindSelected = false;
                  });
                },
                child: Container(
                  height: 35,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: islongBuildUpSelected
                            ? Utils.primaryColor
                            : Utils.greyColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                    child: Text(
                      "${OIBuiltUpType.LongBuildUp.name}",
                      textAlign: TextAlign.center,
                      style: Utils.fonts(
                          size: 12.0,
                          color: islongBuildUpSelected
                              ? Utils.primaryColor
                              : Utils.greyColor.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLongUnwindSelected = false;
                    islongBuildUpSelected = false;
                    isShortBuildupSelected = true;
                    isShortunwindSelected = false;
                  });
                },
                child: Container(
                  height: 35,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: isShortBuildupSelected
                            ? Utils.primaryColor
                            : Utils.greyColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                    child: Text(
                      "${OIBuiltUpType.ShortBuildUp.name}",
                      textAlign: TextAlign.center,
                      style: Utils.fonts(
                          size: 12.0,
                          color: isShortBuildupSelected
                              ? Utils.primaryColor
                              : Utils.greyColor.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLongUnwindSelected = false;
                    islongBuildUpSelected = false;
                    isShortBuildupSelected = false;
                    isShortunwindSelected = true;
                  });
                },
                child: Container(
                  height: 35,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: isShortunwindSelected
                            ? Utils.primaryColor
                            : Utils.greyColor.withOpacity(0.5)),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Center(
                    child: Text(
                      "${OIBuiltUpType.ShortUnwind.name}",
                      textAlign: TextAlign.center,
                      style: Utils.fonts(
                          size: 12.0,
                          color: isShortunwindSelected
                              ? Utils.primaryColor
                              : Utils.greyColor.withOpacity(0.5)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("SYMBOL"),
                  Spacer(),
                  Text("PRICE"),
                  Spacer(),
                  Text("CHG%")
                ],
              ),
              Column(
                children: [Text("2")],
              ),
              Column(
                children: [Text("3")],
              ),
              Column(
                children: [Text("4")],
              )
            ],
          ),
        )
      ],
    );
  }
}

class RisingFalling extends StatefulWidget {
  const RisingFalling({Key key}) : super(key: key);

  @override
  State<RisingFalling> createState() => _RisingFallingState();
}

class _RisingFallingState extends State<RisingFalling> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class HighLowBreaker extends StatefulWidget {
  const HighLowBreaker({Key key}) : super(key: key);

  @override
  State<HighLowBreaker> createState() => _HighLowBreakerState();
}

class _HighLowBreakerState extends State<HighLowBreaker> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class StrongWeak extends StatefulWidget {
  const StrongWeak({Key key}) : super(key: key);

  @override
  State<StrongWeak> createState() => _StrongWeakState();
}

class _StrongWeakState extends State<StrongWeak> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CircuitBreaker extends StatefulWidget {
  const CircuitBreaker({Key key}) : super(key: key);

  @override
  State<CircuitBreaker> createState() => _CircuitBreakerState();
}

class _CircuitBreakerState extends State<CircuitBreaker> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class VolumeShocker extends StatefulWidget {
  const VolumeShocker({Key key}) : super(key: key);

  @override
  State<VolumeShocker> createState() => _VolumeShockerState();
}

class _VolumeShockerState extends State<VolumeShocker> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Spreads extends StatefulWidget {
  const Spreads({Key key}) : super(key: key);

  @override
  State<Spreads> createState() => _SpreadsState();
}

class _SpreadsState extends State<Spreads> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ResistanceSupport extends StatefulWidget {
  const ResistanceSupport({Key key}) : super(key: key);

  @override
  State<ResistanceSupport> createState() => _ResistanceSupportState();
}

class _ResistanceSupportState extends State<ResistanceSupport> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class OpenHighLow extends StatefulWidget {
  const OpenHighLow({Key key}) : super(key: key);

  @override
  State<OpenHighLow> createState() => _OpenHighLowState();
}

class _OpenHighLowState extends State<OpenHighLow> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
