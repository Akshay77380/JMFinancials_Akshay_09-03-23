// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:markets/model/jmModel/limit.dart';
// import 'package:markets/util/CommonFunctions.dart';
//
// class ProfileController extends GetxController {
//   static var isLoading = true.obs;
//   static var limit = Limit().obs;
//   static var limitData = LimitData().obs;
//
//   Future<void> getProfileData() async {
//     isLoading(true);
//     var responses = await CommonFunction.getLimits();
//     var jsons = json.decode(responses);
//     try {
//       if (jsons['status'] == true) {
//         prefs.setString('profileData', jsonEncode(responseJson['data']));
//         InAppSelection.profileData = jsonDecode(prefs.getString('profileData'));
//       } else
//         CommonFunction.showBasicToast(jsons["emsg"].toString());
//     } catch (e) {
//       CommonFunction.showBasicToast(jsons["data"].toString());
//     } finally {}
//     isLoading(false);
//     return;
//   }
// }
