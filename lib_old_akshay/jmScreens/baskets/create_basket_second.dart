import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../util/Utils.dart';

class createBasketSecond extends StatefulWidget {

  @override
  State<createBasketSecond> createState() => _createBasketSecondState();
}

class _createBasketSecondState extends State<createBasketSecond> {
  final List<String> item = ['COFORGE','HCLTECH','INFOSYS','LTI',
    'MINDTREE', 'MPHASIS', 'PERSISTENT','TCS', 'TECHM'];

  void reorderData(int oldindex, int newindex){
    setState(() {
      if(newindex>oldindex){
        newindex-=1;
      }
      final items =item.removeAt(oldindex);
      item.insert(newindex, items);
    });
  }

  void sorting(){
    setState(() {
      item.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Create Basket", style: Utils.fonts(fontWeight: FontWeight.w700, color: Utils.blackColor,size: 18.0)),
        actions: [
          InkWell(
            child: SvgPicture.asset('assets/appImages/basket/tranding.svg'),
          ),
          SizedBox(width: 10,),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("IT Basket", style: Utils.fonts(fontWeight: FontWeight.w700, size: 15.0),),
                      SizedBox(height: 30,),
                      InkWell(onTap:(){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // builder: (context) => (),
                          ),
                        );
                      },child: SvgPicture.asset('assets/appImages/basket/edit.svg'))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Basket Value: 5,654", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor),),
                      Text("12 Scrips", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor) )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: 50,
                width: 390,
                decoration: BoxDecoration(
                    color: Utils.containerColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Utils.greyColor,),
                      hintText: "Add Scrips",
                      border: InputBorder.none,
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text("2/20"),
                    )
                  ),
                )
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 58.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Scrips", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor),),
                  Text("Weightage (%)", style: Utils.fonts(fontWeight: FontWeight.w500, size: 13.0, color: Utils.greyColor),)
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              thickness: 1,
            ),

        SingleChildScrollView(
          child: Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child:  ReorderableListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: <Widget>[
            for (int index = 0; index < item.length; index += 1)
              Container(
                key: Key('$index'),
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        child: SvgPicture.asset('assets/appImages/basket/drag.svg'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("COFORGE",
                        style: Utils.fonts(
                            fontWeight: FontWeight.w700,
                            size: 13.0, color: Utils.greyColor.withOpacity(0.9)),),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        height: 50,
                        width: 120,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Utils.greyColor.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Container(child: Center(child: SvgPicture.asset('assets/appImages/basket/minus.svg')),),
                            SizedBox(
                              width: 10,
                            ),
                            Text("7.68" , style: Utils.fonts(
                            fontWeight: FontWeight.w700,
                                size: 13.0, color: Utils.greyColor.withOpacity(0.9))),
                            SizedBox(
                              width: 10,
                            ),
                            Container(child: Center(child: SvgPicture.asset('assets/appImages/basket/plus.svg')),)
                            ,SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        child: Center(child: SvgPicture.asset('assets/appImages/basket/lock.svg'),),)
                    ],
                  ),
                ),
              ),
          ],
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final String item1 = item.removeAt(oldIndex);
              item.insert(newIndex, item1);
            });
          },
        )
            )

        ),
  ]
        ),
      ),
    );
  }


}
