import 'package:flutter/material.dart';
import 'package:markets/util/Dataconstants.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Utils.dart';
import 'Login.dart';

class MultipleAccounts extends StatefulWidget {
  const MultipleAccounts({Key key}) : super(key: key);

  @override
  State<MultipleAccounts> createState() => _MultipleAccountsState();
}

class _MultipleAccountsState extends State<MultipleAccounts> {
  var selectedAccount = 0;

  @override
  void initState() {
    var params = {
      "screen": "Multiple_Account_Screen",
    };
    CommonFunction.JMFirebaseLogging("Screen_Tracking", params);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Welcome",
                textAlign: TextAlign.center,
                style: Utils.fonts(size: 26.0),
              ),
              Text(
                "Login to Blink Trade using one of the following Accounts",
                style: Utils.fonts(size: 14.0, color: Utils.greyColor),
              ),
              Container(
                height: 300,
                child: ListView.builder(
                    itemCount: Dataconstants.multipleMapIDs.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedAccount = index;
                              Dataconstants.selectedID =  Dataconstants.multipleMapIDs[index];
                            });
                          },
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Text(
                                    Dataconstants.multipleMapIDs[index],
                                    style: Utils.fonts(size: 15.0),
                                  ),
                                  Spacer(),
                                  selectedAccount == index
                                      ? Icon(
                                    Icons.check_circle,
                                    color: Utils.primaryColor,
                                    size: 19.0,
                                  )
                                      : Icon(
                                    Icons.circle_outlined,
                                    color: Utils.greyColor,
                                    size: 19.0,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 50.0),
                      child: Text(
                        "CONTINUE",
                        style: Utils.fonts(
                            size: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Utils.primaryColor),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            )))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
