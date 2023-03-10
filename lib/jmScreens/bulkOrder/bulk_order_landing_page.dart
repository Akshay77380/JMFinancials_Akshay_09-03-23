import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../util/Utils.dart';
import 'view_bulk_order.dart';

class bulkOrderLandingPage extends StatefulWidget {
  @override
  State<bulkOrderLandingPage> createState() => _bulkOrderLandingPageState();
}

class _bulkOrderLandingPageState extends State<bulkOrderLandingPage>
     {

  List<MainData> globalArray = [];

  TextEditingController _bulkOrderController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Bulk Order",
          style: Utils.fonts(
              size: 18.0,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyText1.color),
        ),
        elevation: 0,
        actions: [
          InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => bulkOrderLandingPage()
                    )
                );
              },
              child: Center(
                  child: SvgPicture.asset('assets/appImages/tranding.svg')
              )
          ),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 66,
                      decoration: BoxDecoration(
                          color: Utils.containerColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            prefixIcon: Container(height: 30,
                                width: 30,
                                child: Center(child: SvgPicture.asset('assets/appImages/search.svg')
                            )),
                            hintText: "Add Scrips",
                            border: InputBorder.none
                        ),
                      )
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15))),
                          context: context,
                          builder: (context) {
                            return DotExpand2(

                            );

                          });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Utils.containerColor
                      ),
                      child: SvgPicture.asset('assets/appImages/plus.svg', color: Utils.primaryColor,),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 500,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    itemCount: globalArray.length,
                    itemBuilder: (BuildContext context, int index){
                      return Column(
                        children: [
                          Container(
                            height: 70,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => viewBulkOrder(index, globalArray),
                                      // builder: (context) => basketOverview(globalArray, true),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 18,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${globalArray[index]._bulkOrderName}', style: Utils.fonts(fontWeight: FontWeight.w700, size: 13.0),),
                                        Container(
                                            height: 15,
                                            width: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.orange.shade100,
                                                borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: Center(child: Text('${globalArray[index].scripsData.length} + scrips',style: Utils.fonts(fontWeight: FontWeight.w500, size: 11.0, color: Colors.orange),)))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          child: Text("Required Margin: 5,687" ,
                                            style: Utils.fonts(
                                                fontWeight: FontWeight.w500, size: 11.0, color: Utils.greyColor
                                            ),),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey,
                          )
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget DotExpand2() {
    return
       Padding(
         padding: EdgeInsets.only(top: 10,left: 5,right: 5, bottom: MediaQuery.of(context).viewInsets.bottom),
         child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey,
                ),
              ),

              Row(
                children: [
                  Text(
                    "New Bulk Order",
                    style: Utils.fonts(color: Utils.blackColor, size: 16.0),
                  ),
                ],
              ),

              SizedBox(
                height: 30,
              ),

              TextFormField(
                controller: _bulkOrderController,
                decoration: InputDecoration(
                  labelText: 'Label text',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 34, vertical: 10),
                  child: Center(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.0),
                                border: Border.all(color: Utils.greyColor.withOpacity(0.7))),
                            child: Center(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Utils.greyColor.withOpacity(0.8), fontSize: 20),
                                )),
                          ),
                        ),
                        // Spacer(flex: 1),
                        SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: (){
                            // MainData(_bulkOrderController.text, <ScriptsData>[]);
                            globalArray.add(MainData(_bulkOrderController.text,[ScriptsData("ndfeilfh")]));
                            Navigator.pop(context);
                            },
                          child: Container(
                            height: 50,
                         width: MediaQuery.of(context).size.width * 0.32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.blue,
                            ),
                            child: Center(
                              child: Text(
                                "Create",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
       );
    }
}

class MainData{
  String _bulkOrderName;

  List<ScriptsData> scripsData;
  MainData(this._bulkOrderName, this.scripsData);
}

class ScriptsData{

  String _scriptsName;

  ScriptsData(this._scriptsName);
}