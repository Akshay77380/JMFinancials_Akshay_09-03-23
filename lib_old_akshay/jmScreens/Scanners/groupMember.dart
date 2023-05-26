
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../util/CommonFunctions.dart';

class GroupMemberClass {
  final int scCode;
  final String groupName;

  GroupMemberClass({
    this.scCode,
    this.groupName,
  });

  factory GroupMemberClass.fromJson(Map<String, dynamic> json) {
    return new GroupMemberClass(
      scCode: json['ScCode'],
      groupName: json['GroupName'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'ScCode': scCode,
      'ScName': groupName,
    };
  }
}
class SendTokenToServer {
  Future<String> createToken() async {
    try {
      String token = await FirebaseMessaging.instance.getToken();
      if (token == null) {
        return null;
      }
      return token;
    } catch (ex, stackTrace) {
      // CommonFunction.sendDataToCrashlytics(
      //     ex, stackTrace, 'GenerateToken_CreateToken');
      return null;
    }
  }
}
