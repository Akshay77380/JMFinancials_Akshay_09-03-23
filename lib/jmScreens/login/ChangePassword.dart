import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../util/CommonFunctions.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';
import 'Login.dart';

class ChangePassword extends StatefulWidget {
  final bool isSettingScreen;
  final String otp;

  ChangePassword(this.isSettingScreen, {this.otp});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  FocusNode oldPasswordFocus = FocusNode();
  FocusNode newPasswordFocus = FocusNode();
  FocusNode confirmFocus = FocusNode();
  bool isObsercureOldPwText = true, isObsercureNewPwText = true, isObsercureConfirmPwText = true;
  bool sixCharacters = false, oneNumber = false, oneAlphabet = false, oneSpecialCharacter = false, notPrev = false;
  RegExp _regExpNum = RegExp('(?=.*[0-9])');
  RegExp _regExpSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  RegExp _regExpAlph = RegExp('(?=.*[a-zA-Z])');

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: widget.isSettingScreen
          ? AppBar(
              bottomOpacity: 2,
              backgroundColor: Utils.whiteColor,
              title: Text(
                "Change Password",
                style: Utils.fonts(size: 18.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
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
                SvgPicture.asset('assets/appImages/tranding.svg'),
                SizedBox(
                  width: 15,
                )
              ],
            )
          : null,
      body: Builder(builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!widget.isSettingScreen)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.height * 0.1,
                              ),
                              Text(
                                "Change Password",
                                textAlign: TextAlign.center,
                                style: Utils.fonts(size: 24.0, fontWeight: FontWeight.w600, color: Utils.blackColor),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Password must be 6-12 characters in length and must have a combination of alphabets, numbers and symbols.',
                                style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 30,
                        ),
                        Visibility(
                          visible: widget.isSettingScreen,
                          child: Column(
                            children: [
                              TextField(
                                controller: oldPassword,
                                showCursor: true,
                                focusNode: oldPasswordFocus,
                                obscureText: isObsercureOldPwText,
                                textInputAction: TextInputAction.next,
                                obscuringCharacter: "*",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                                onEditingComplete: () {
                                  node.requestFocus(newPasswordFocus);
                                },
                                decoration: InputDecoration(
                                  fillColor: Theme.of(context).cardColor,
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(!isObsercureOldPwText ? Icons.visibility : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        isObsercureOldPwText = !isObsercureOldPwText;
                                      });
                                    },
                                  ),
                                  focusColor: Theme.of(context).primaryColor,
                                  filled: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                  labelText: "Old Password",
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                        TextField(
                          controller: newPassword,
                          showCursor: true,
                          focusNode: newPasswordFocus,
                          // focusNode: myFocusNodeUserIDLogin,
                          textInputAction: TextInputAction.next,
                          obscureText: isObsercureNewPwText,
                          obscuringCharacter: "*",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).cardColor,
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(!isObsercureNewPwText ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  isObsercureNewPwText = !isObsercureNewPwText;
                                });
                              },
                            ),
                            focusColor: Theme.of(context).primaryColor,
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            labelText: "New Password",
                          ),
                          onEditingComplete: () {
                            node.requestFocus(confirmFocus);
                          },
                          onChanged: (value) {
                            if (value.trim().length >= 6 && value.trim().length <= 12) {
                              setState(() {
                                sixCharacters = true;
                              });
                            } else {
                              setState(() {
                                sixCharacters = false;
                              });
                            }
                            if (_regExpNum.hasMatch(value)) {
                              setState(() {
                                oneNumber = true;
                              });
                            } else {
                              setState(() {
                                oneNumber = false;
                              });
                            }
                            if (_regExpSpecialChar.hasMatch(value)) {
                              setState(() {
                                oneSpecialCharacter = true;
                              });
                            } else {
                              setState(() {
                                oneSpecialCharacter = false;
                              });
                            }
                            if (_regExpAlph.hasMatch(value)) {
                              setState(() {
                                oneAlphabet = true;
                              });
                            } else {
                              setState(() {
                                oneAlphabet = false;
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextField(
                          controller: confirmPassword,
                          showCursor: true,
                          focusNode: confirmFocus,
                          // focusNode: myFocusNodeUserIDLogin,
                          // showCursor: true,
                          textInputAction: TextInputAction.done,
                          obscureText: isObsercureConfirmPwText,
                          obscuringCharacter: "*",
                          style: TextStyle(
                            fontSize: 18.0,
                          ),
                          decoration: InputDecoration(
                            fillColor: Theme.of(context).cardColor,
                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(!isObsercureConfirmPwText ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  isObsercureConfirmPwText = !isObsercureConfirmPwText;
                                });
                              },
                            ),
                            focusColor: Theme.of(context).primaryColor,
                            filled: true,
                            enabledBorder: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor),
                            ),
                            labelText: "Confirm Password",
                          ),
                        ),
                        Visibility(
                          visible: widget.isSettingScreen,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: sixCharacters ? Utils.primaryColor.withOpacity(0.2) : Utils.lightGreyColor.withOpacity(0.2),
                                        ),
                                        child: Row(
                                          children: [
                                            if (sixCharacters) SvgPicture.asset('assets/appImages/checkbox_circle_blue.svg'),
                                            if (sixCharacters)
                                              const SizedBox(
                                                width: 5,
                                              ),
                                            Text(
                                              "6-12 Characters",
                                              style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: sixCharacters ? Utils.primaryColor : Utils.lightGreyColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: oneSpecialCharacter ? Utils.primaryColor.withOpacity(0.2) : Utils.lightGreyColor.withOpacity(0.2),
                                        ),
                                        child: Row(
                                          children: [
                                            if (oneSpecialCharacter) SvgPicture.asset('assets/appImages/checkbox_circle_blue.svg'),
                                            if (oneSpecialCharacter)
                                              const SizedBox(
                                                width: 5,
                                              ),
                                            Text(
                                              "1 Special Character",
                                              style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: oneSpecialCharacter ? Utils.primaryColor : Utils.lightGreyColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: oneNumber ? Utils.primaryColor.withOpacity(0.2) : Utils.lightGreyColor.withOpacity(0.2),
                                        ),
                                        child: Row(
                                          children: [
                                            if (oneNumber) SvgPicture.asset('assets/appImages/checkbox_circle_blue.svg'),
                                            if (oneNumber)
                                              const SizedBox(
                                                width: 5,
                                              ),
                                            Text(
                                              "1 Number",
                                              style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: oneNumber ? Utils.primaryColor : Utils.lightGreyColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          color: oneAlphabet ? Utils.primaryColor.withOpacity(0.2) : Utils.lightGreyColor.withOpacity(0.2),
                                        ),
                                        child: Row(
                                          children: [
                                            if (oneAlphabet) SvgPicture.asset('assets/appImages/checkbox_circle_blue.svg'),
                                            if (oneAlphabet)
                                              const SizedBox(
                                                width: 5,
                                              ),
                                            Text(
                                              "1 Alphabet",
                                              style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: oneAlphabet ? Utils.primaryColor : Utils.lightGreyColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              // Container(
                              //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(15),
                              //     color: notPrev ? Utils.primaryColor.withOpacity(0.2) : Utils.lightGreyColor.withOpacity(0.2),
                              //   ),
                              //   child: Row(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       if (notPrev) SvgPicture.asset('assets/appImages/checkbox_circle_blue.svg'),
                              //       if (notPrev)
                              //         const SizedBox(
                              //           width: 5,
                              //         ),
                              //       Text(
                              //         "Password does not match prev. 3 passwords",
                              //         style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: notPrev ? Utils.primaryColor : Utils.lightGreyColor),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!widget.isSettingScreen)
                  Center(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (newPassword.text == '') {
                              CommonFunction.showSnackBar(context: ctx, text: 'New Password cannot be blank', color: Utils.brightRedColor);
                              return;
                            }
                            if (confirmPassword.text == '') {
                              CommonFunction.showSnackBar(context: ctx, text: 'Confirm Password cannot be blank', color: Utils.brightRedColor);
                              return;
                            }
                            if (newPassword.text != confirmPassword.text) {
                              CommonFunction.showSnackBar(context: ctx, text: 'New Password and Confirm Password do not match', color: Utils.brightRedColor);
                              return;
                            }
                            if (!sixCharacters) {
                              CommonFunction.showSnackBar(context: ctx, text: 'Password must contains 6-12 characters', color: Utils.brightRedColor);
                              return;
                            }
                            if (!oneNumber) {
                              CommonFunction.showSnackBar(context: ctx, text: 'Password must contains at least 1 digit', color: Utils.brightRedColor);
                              return;
                            }
                            if (!oneAlphabet) {
                              CommonFunction.showSnackBar(context: ctx, text: 'Password must contains at least 1 alphabet', color: Utils.brightRedColor);
                              return;
                            }
                            if (!oneSpecialCharacter) {
                              CommonFunction.showSnackBar(context: ctx, text: 'Password must contains at least 1 special character', color: Utils.brightRedColor);
                              return;
                            }
                            var requestJson = {
                              "LoginId": Dataconstants.accountDetails[0],
                              "Password": confirmPassword.text,
                              "MobileNo": Dataconstants.accountDetails[2],
                              "OTP": widget.otp,
                            };
                            var responses = await CommonFunction.setPassword(requestJson);
                            var jsons = json.decode(responses);
                            if (jsons['status'] == false)
                              CommonFunction.showBasicToast(jsons["emsg"].toString());
                            else {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                context: context,
                                builder: (context) => Container(
                                  height: MediaQuery.of(context).size.height * 0.4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/appImages/successful.svg'),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Password will expire in",
                                          style: Utils.fonts(
                                            size: 14.0,
                                            fontWeight: FontWeight.w300,
                                            color: Utils.greyColor,
                                          ),
                                        ),
                                        Text(
                                          "90 Days",
                                          style: Utils.fonts(
                                            size: 20.0,
                                            fontWeight: FontWeight.w600,
                                            color: Utils.blackColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: SizedBox(
                                            width: double.maxFinite,
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
                                                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreenJm()));
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                                                  child: Text(
                                                    "OK",
                                                    style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                                                  ),
                                                ),
                                                style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(50.0),
                                                    )))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.white,
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                            child: Text(
                              "Set New Password",
                              style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              )))),
                    ),
                  )
                else
                  Center(
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (oldPassword.text == '') {
                              CommonFunction.showSnackBar(context: ctx, text: 'Old Password cannot be blank', color: Utils.brightRedColor);
                              return;
                            }
                            if (newPassword.text != confirmPassword.text) {
                              CommonFunction.showSnackBar(context: ctx, text: 'New Password and Confirm Password do not match', color: Utils.brightRedColor);
                              return;
                            }
                            if (sixCharacters == true && oneNumber == true && oneAlphabet == true && oneSpecialCharacter == true
                                // && notPrev == true
                                ) {
                              var jsonResponse = {
                                "LoginID": Dataconstants.feUserID,
                                "Password": oldPassword.text,
                                "NewPassword": newPassword.text,
                              };
                              var result = await CommonFunction.changePassword(jsonResponse);
                              var response = jsonDecode(result);
                              if (response['status'] == false)
                                CommonFunction.showSnackBar(context: ctx, text: response['emsg'], color: Utils.brightRedColor);
                              else {
                                  CommonFunction.showSnackBar(context: ctx, text: response['data'], color: Utils.brightGreenColor);
                                  Future.delayed(Duration(seconds: 4), () {
                                    Navigator.pop(context);
                                  });
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 50.0),
                            child: Text(
                              "Set New Password",
                              style: Utils.fonts(size: 14.0, color: Colors.white, fontWeight: FontWeight.w400),
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Utils.primaryColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              )))),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (!widget.isSettingScreen)
                  const SizedBox(
                    height: 10,
                  ),
                // Center(
                //   child: Text(
                //     "Trouble signing in",
                //     style: Utils.fonts(size: 14.0, color: Utils.greyColor),
                //   ),
                // ),
                if (!widget.isSettingScreen)
                  const SizedBox(
                    height: 10,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import '../../util/Utils.dart';
// import 'Login.dart';
//
// class ChangePassword extends StatefulWidget {
//   final bool isSettingScreen;
//
//   ChangePassword(this.isSettingScreen);
//
//   @override
//   State<ChangePassword> createState() => _ChangePasswordState();
// }
//
// class _ChangePasswordState extends State<ChangePassword> {
//   TextEditingController oldPassword = TextEditingController();
//   TextEditingController newPassword = TextEditingController();
//   TextEditingController confirmPassword = TextEditingController();
//   FocusNode oldPasswordFocus = FocusNode();
//   FocusNode newPasswordFocus = FocusNode();
//   FocusNode confirmFocus = FocusNode();
//   bool isObsercureOldPwText = true,
//       isObsercureNewPwText = true,
//       isObsercureConfirmPwText = true;
//   bool sixCharacters = false, oneNumber = false, oneAlphabet = false, oneSpecialCharacter = false, notPrev = false;
//   RegExp _regExpNum = RegExp('(?=.*[0-9])');
//   RegExp _regExpSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
//   RegExp _regExpAlph = RegExp('(?=.*[a-zA-Z])');
//
//   @override
//   Widget build(BuildContext context) {
//     final node = FocusScope.of(context);
//     var size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: widget.isSettingScreen
//           ? AppBar(
//               bottomOpacity: 2,
//               backgroundColor: Utils.whiteColor,
//               title: Text(
//                 "Change Password",
//                 style: Utils.fonts(
//                     size: 18.0,
//                     fontWeight: FontWeight.w600,
//                     color: Utils.blackColor),
//               ),
//               elevation: 1,
//               leading: InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Icon(
//                   Icons.arrow_back,
//                   color: Utils.greyColor,
//                 ),
//               ),
//               actions: [
//                 SvgPicture.asset('assets/appImages/tranding.svg'),
//                 SizedBox(
//                   width: 15,
//                 )
//               ],
//             )
//           : null,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       if (!widget.isSettingScreen)
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: size.height * 0.1,
//                             ),
//                             Text(
//                               "CHANGE PASSWORD",
//                               textAlign: TextAlign.center,
//                               style: Utils.fonts(
//                                   size: 24.0,
//                                   fontWeight: FontWeight.w600,
//                                   color: Utils.blackColor),
//                             ),
//                             SizedBox(
//                               height: 30,
//                             ),
//                             Text(
//                               'Password must be 6-12 characters in length and must have a combination of alphabets, numbers and symbols.',
//                               style: Utils.fonts(
//                                   size: 14.0, color: Utils.greyColor),
//                             ),
//                           ],
//                         ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       TextField(
//                         controller: oldPassword,
//                         showCursor: true,
//                         focusNode: oldPasswordFocus,
//                         obscureText: isObsercureOldPwText,
//                         // keyboardType: ,
//
//                         obscuringCharacter: "*",
//                         style: TextStyle(
//                           fontSize: 18.0,
//                         ),
//                         onEditingComplete: () {
//                           node.requestFocus(newPasswordFocus);
//                         },
//
//                         decoration: InputDecoration(
//                           fillColor: Theme.of(context).cardColor,
//                           labelStyle: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 15,
//                           ),
//                           suffixIcon: IconButton(
//                             icon: Icon(!isObsercureOldPwText
//                                 ? Icons.visibility
//                                 : Icons.visibility_off),
//                             onPressed: () {
//                               setState(() {
//                                 isObsercureOldPwText = !isObsercureOldPwText;
//                               });
//                             },
//                           ),
//                           focusColor: Theme.of(context).primaryColor,
//                           filled: true,
//                           enabledBorder: UnderlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide.none,
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(
//                                 color: Theme.of(context).primaryColor),
//                           ),
//                           labelText: "Old Password",
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       TextField(
//                         controller: newPassword,
//                         showCursor: true,
//                         focusNode: newPasswordFocus,
//                         // focusNode: myFocusNodeUserIDLogin,
//                         // showCursor: true,
//                         obscureText: isObsercureNewPwText,
//                         obscuringCharacter: "*",
//                         style: TextStyle(
//                           fontSize: 18.0,
//                         ),
//                         decoration: InputDecoration(
//                           fillColor: Theme.of(context).cardColor,
//                           labelStyle: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 15,
//                           ),
//                           suffixIcon: IconButton(
//                             icon: Icon(!isObsercureNewPwText
//                                 ? Icons.visibility
//                                 : Icons.visibility_off),
//                             onPressed: () {
//                               setState(() {
//                                 isObsercureNewPwText = !isObsercureNewPwText;
//                               });
//                             },
//                           ),
//                           focusColor: Theme.of(context).primaryColor,
//                           filled: true,
//                           enabledBorder: UnderlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide.none,
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(
//                                 color: Theme.of(context).primaryColor),
//                           ),
//                           labelText: "New Password",
//                         ),
//                         onChanged: (value) {
//                           if(value.trim().length >= 6 && value.trim().length <= 12) {
//                             setState(() {
//                               sixCharacters = true;
//                             });
//                           } else {
//                             setState(() {
//                               sixCharacters = false;
//                             });
//                           }
//                           if(_regExpNum.hasMatch(value)) {
//                             setState(() {
//                               oneNumber = true;
//                             });
//                           } else {
//                             setState(() {
//                               oneNumber = false;
//                             });
//                           }
//                           if(_regExpSpecialChar.hasMatch(value)) {
//                             setState(() {
//                               oneSpecialCharacter = true;
//                             });
//                           } else {
//                             setState(() {
//                               oneSpecialCharacter = false;
//                             });
//                           }
//                           if(_regExpAlph.hasMatch(value)) {
//                             setState(() {
//                               oneAlphabet = true;
//                             });
//                           } else {
//                             setState(() {
//                               oneAlphabet = false;
//                             });
//                           }
//                         },
//                       ),
//                       SizedBox(
//                         height: 30,
//                       ),
//                       TextField(
//                         controller: confirmPassword,
//                         showCursor: true,
//                         focusNode: confirmFocus,
//                         // focusNode: myFocusNodeUserIDLogin,
//                         // showCursor: true,
//                         obscureText: isObsercureConfirmPwText,
//                         obscuringCharacter: "*",
//                         style: TextStyle(
//                           fontSize: 18.0,
//                         ),
//                         decoration: InputDecoration(
//                           fillColor: Theme.of(context).cardColor,
//                           labelStyle: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 15,
//                           ),
//                           suffixIcon: IconButton(
//                             icon: Icon(!isObsercureConfirmPwText
//                                 ? Icons.visibility
//                                 : Icons.visibility_off),
//                             onPressed: () {
//                               setState(() {
//                                 isObsercureConfirmPwText =
//                                     !isObsercureConfirmPwText;
//                               });
//                             },
//                           ),
//                           focusColor: Theme.of(context).primaryColor,
//                           filled: true,
//                           enabledBorder: UnderlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide.none,
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(10),
//                             borderSide: BorderSide(
//                                 color: Theme.of(context).primaryColor),
//                           ),
//                           labelText: "Confirm Password",
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             height: 30,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 3),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(15),
//                                       color:
//                                           sixCharacters ? Utils.primaryColor.withOpacity(0.2) : Utils.lightGreyColor.withOpacity(0.2),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         if(sixCharacters)
//                                         SvgPicture.asset(
//                                             'assets/appImages/checkbox_circle_blue.svg'),
//                                         if(sixCharacters)
//                                         const SizedBox(
//                                           width: 5,
//                                         ),
//                                         Text(
//                                           "6-12 Characters",
//                                           style: Utils.fonts(
//                                               size: 12.0,
//                                               fontWeight: FontWeight.w500,
//                                               color: sixCharacters ? Utils.primaryColor : Utils.lightGreyColor),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 15,
//                                   ),
//                                   Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 3),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(15),
//                                       color:
//                                       oneSpecialCharacter ? Utils.primaryColor.withOpacity(0.2) : Utils.lightGreyColor.withOpacity(0.2),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         if(oneSpecialCharacter)
//                                         SvgPicture.asset(
//                                             'assets/appImages/checkbox_circle_blue.svg'),
//                                         if(oneSpecialCharacter)
//                                         const SizedBox(
//                                           width: 5,
//                                         ),
//                                         Text(
//                                           "1 Special Character",
//                                           style: Utils.fonts(
//                                               size: 12.0,
//                                               fontWeight: FontWeight.w500,
//                                               color: oneSpecialCharacter ? Utils.primaryColor : Utils.lightGreyColor),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 3),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(15),
//                                       color:
//                                       oneNumber ? Utils.primaryColor.withOpacity(0.2) : Utils.lightGreyColor.withOpacity(0.2),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         if(oneNumber)
//                                         SvgPicture.asset(
//                                             'assets/appImages/checkbox_circle_blue.svg'),
//                                         if(oneNumber)
//                                         const SizedBox(
//                                           width: 5,
//                                         ),
//                                         Text(
//                                           "1 Number",
//                                           style: Utils.fonts(
//                                               size: 12.0,
//                                               fontWeight: FontWeight.w500,
//                                               color: oneNumber ? Utils.primaryColor : Utils.lightGreyColor),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 15,
//                                   ),
//                                   Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 3),
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(15),
//                                       color:
//                                       oneAlphabet ? Utils.primaryColor.withOpacity(0.2) : Utils.lightGreyColor.withOpacity(0.2),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         if(oneAlphabet)
//                                         SvgPicture.asset(
//                                             'assets/appImages/checkbox_circle_blue.svg'),
//                                         if(oneAlphabet)
//                                         const SizedBox(
//                                           width: 5,
//                                         ),
//                                         Text(
//                                           "1 Alphabet",
//                                           style: Utils.fonts(
//                                               size: 12.0,
//                                               fontWeight: FontWeight.w500,
//                                               color: oneAlphabet ? Utils.primaryColor : Utils.lightGreyColor),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 15,
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 3),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(15),
//                               color:
//                               notPrev ? Utils.primaryColor.withOpacity(0.2) : Utils.lightGreyColor.withOpacity(0.2),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 if(notPrev)
//                                 SvgPicture.asset(
//                                     'assets/appImages/checkbox_circle_blue.svg'),
//                                 if(notPrev)
//                                 const SizedBox(
//                                   width: 5,
//                                 ),
//                                 Text(
//                                   "Password does not match prev. 3 passwords",
//                                   style: Utils.fonts(
//                                       size: 12.0,
//                                       fontWeight: FontWeight.w500,
//                                       color: notPrev ? Utils.primaryColor : Utils.lightGreyColor),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               if (!widget.isSettingScreen)
//                 Center(
//                   child: SizedBox(
//                     width: double.maxFinite,
//                     child: ElevatedButton(
//                         onPressed: () {
//                           return showModalBottomSheet(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.0),
//                             ),
//                             context: context,
//                             builder: (context) => Container(
//                               height: MediaQuery.of(context).size.height * 0.4,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(20.0),
//                                 child: Column(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceEvenly,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     SvgPicture.asset(
//                                         'assets/appImages/successful.svg'),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     Text(
//                                       "Password will expire in",
//                                       style: Utils.fonts(
//                                         size: 14.0,
//                                         fontWeight: FontWeight.w300,
//                                         color: Utils.greyColor,
//                                       ),
//                                     ),
//                                     Text(
//                                       "90 Days",
//                                       style: Utils.fonts(
//                                         size: 20.0,
//                                         fontWeight: FontWeight.w600,
//                                         color: Utils.blackColor,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: 10,
//                                     ),
//                                     Center(
//                                       child: SizedBox(
//                                         width: double.maxFinite,
//                                         child: ElevatedButton(
//                                             onPressed: () {
//                                               Navigator.pushAndRemoveUntil(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                       builder: (context) =>
//                                                           Login()),
//                                                   (route) => false);
//                                               // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreenJm()));
//                                             },
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                       vertical: 15.0,
//                                                       horizontal: 50.0),
//                                               child: Text(
//                                                 "OK",
//                                                 style: Utils.fonts(
//                                                     size: 14.0,
//                                                     color: Colors.white,
//                                                     fontWeight:
//                                                         FontWeight.w400),
//                                               ),
//                                             ),
//                                             style: ButtonStyle(
//                                                 backgroundColor:
//                                                     MaterialStateProperty.all<
//                                                             Color>(
//                                                         Utils.primaryColor),
//                                                 shape: MaterialStateProperty.all<
//                                                         RoundedRectangleBorder>(
//                                                     RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           50.0),
//                                                 )))),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             backgroundColor: Colors.white,
//                           );
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 15.0, horizontal: 50.0),
//                           child: Text(
//                             "VALIDATE",
//                             style: Utils.fonts(
//                                 size: 14.0,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w400),
//                           ),
//                         ),
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                                 Utils.primaryColor),
//                             shape: MaterialStateProperty.all<
//                                 RoundedRectangleBorder>(RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50.0),
//                             )))),
//                   ),
//                 )
//               else
//                 Center(
//                   child: SizedBox(
//                     width: double.maxFinite,
//                     child: ElevatedButton(
//                         onPressed: () {},
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 15.0, horizontal: 50.0),
//                           child: Text(
//                             "Set New Password",
//                             style: Utils.fonts(
//                                 size: 14.0,
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.w400),
//                           ),
//                         ),
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                                 Utils.primaryColor),
//                             shape: MaterialStateProperty.all<
//                                 RoundedRectangleBorder>(RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(50.0),
//                             )))),
//                   ),
//                 ),
//               const SizedBox(
//                 height: 10,
//               ),
//               if (!widget.isSettingScreen)
//                 Center(
//                   child: Text(
//                     "Trouble signing in",
//                     style: Utils.fonts(size: 14.0, color: Utils.greyColor),
//                   ),
//                 ),
//               if (!widget.isSettingScreen)
//                 const SizedBox(
//                   height: 10,
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
