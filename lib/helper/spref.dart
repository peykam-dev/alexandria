import 'package:shared_preferences/shared_preferences.dart';

class SprefHelper {
  static String keyIsUserLoggedIn = 'ISLOGGEDIN';
  static String keyUsername = 'USERNAMEKEY';
  static String keyEmail = 'USEREMAILKEY';

  static Future<bool> saveUserLogIn(bool isUserLoggedIn) async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    return await spref.setBool(keyIsUserLoggedIn, isUserLoggedIn);
  }

  static Future<bool> saveUsernameSpref(String userName) async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    return await spref.setString(keyUsername, userName);
  }

  static Future<bool> saveUserEmailSpref(String userEmail) async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    return await spref.setString(keyEmail, userEmail);
  }

  static Future<bool> getUserLogIn() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    return spref.getBool(keyIsUserLoggedIn) ?? false;
  }

  static Future<String> getUsernameSpref() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    return spref.getString(keyUsername)!;
  }

  static Future<String?> getUserEmailSpref() async {
    SharedPreferences spref = await SharedPreferences.getInstance();
    return spref.getString(keyEmail)!;
  }
}
