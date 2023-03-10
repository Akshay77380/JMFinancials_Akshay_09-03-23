import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:markets/util/Dataconstants.dart';

class LoginEncryption {
  String key;
  String iv;
  String strInput;
  String randNum;
  String encryptedString;

  LoginEncryption(this.strInput) {
    key = Dataconstants.secretKey;
    iv = ""; //Api.iv_key;
    var encodedString = asciiEncoding(input: strInput);
    var iv1 = generateIvByteArray();

    // Encrypter()
    Encrypter encrypter =
        Encrypter(AES(Key(generateEncyKey()), mode: AESMode.ecb));
    encryptedString = encrypter.encryptBytes(encodedString, iv: IV(iv1)).base64;
  }

  generateEncyKey() {
    var newkey = generateRandomNumber() + key.substring(0, 24);
    // //print("newkey - $newkey");
    return Uint8List.fromList(newkey.codeUnits);
  }

  asciiEncoding({input}) {
    return ascii.encode(input);
  }

  generateIvByteArray() {
    return Uint8List.fromList(iv.codeUnits);
  }

  String generateRandomNumber() {
    randNum = reverseAString(DateTime.now().millisecondsSinceEpoch.toString())
        .substring(0, 8);
    return randNum;
  }

  String reverseAString(String input) {
    final output = input.split('').reversed.join('');
    return output;
  }

  String getRandomNumber() {
    return randNum;
  }

  String getEncryptionString() {
    return encryptedString;
  }

  String loginEncryptionWithOldRandomNumber({strInput2, randNum}) {
    key = Dataconstants.secretKey;
    iv = ""; //Api.iv_key;
    var encodedString = asciiEncoding(input: strInput2);
    var iv1 = generateIvByteArray();

    // Encrypter()
    Encrypter encrypter = Encrypter(
        AES(Key(generateEncyKeyWithOldKey(randNum)), mode: AESMode.ecb));
    var val = encrypter.encryptBytes(encodedString, iv: IV(iv1)).base64;
    return val;
  }

  generateEncyKeyWithOldKey(randNum) {
    var newkey = randNum + key.substring(0, 24);
    return Uint8List.fromList(newkey.codeUnits);
  }
}
