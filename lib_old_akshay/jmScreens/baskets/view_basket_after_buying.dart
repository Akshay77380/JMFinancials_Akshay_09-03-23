import 'package:flutter/material.dart';
import '../../util/Utils.dart';
import '../../widget/custom_tab_bar.dart';
import '../../widget/slider_button.dart';
import 'basket_overview.dart';

class viewBasketAfterBuying extends StatefulWidget {
  var globalarray = [];

  viewBasketAfterBuying(@required this.globalarray);

  @override
  State<viewBasketAfterBuying> createState() => _viewBasketAfterBuyingState();
}

class _viewBasketAfterBuyingState extends State<viewBasketAfterBuying>
    with TickerProviderStateMixin {
  TabController _tabController;

  var globalArray = [];

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {

    bool isCompleted = false;
    return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                physics: CustomTabBarScrollPhysics(),
                controller: _tabController,
                children: [
                  basketOverview(widget.globalarray, true),
                  // swipeToBuy()
                  isCompleted ? SliderButton(
                    height: 55,
                    width: MediaQuery.of(context).size.width * 0.80,
                    text: 'SWIPE TO BUY',
                    textStyle: Utils.fonts(size: 18.0, color: Utils.whiteColor),
                    backgroundColor: Utils.brightGreenColor ,
                    foregroundColor: Utils.whiteColor,
                    iconColor: Utils.brightGreenColor,
                    icon: Icons.double_arrow,
                    shimmer: false,
                    onConfirmation: () async {
                      setState(() {
                        isCompleted = !isCompleted;
                      });
                    },
                  ) : Card(elevation: 5,child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 18),
                    child: displayButtons(context),
                  )
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}
