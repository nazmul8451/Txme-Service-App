import 'package:shared_preferences/shared_preferences.dart';

class SharePrefsHelper {

  /// ================= KEYS =================
  static const String language = "language";
  static const String bearerToken = "bearerToken";
  static const String userRole = "user_role";
  static const String user = "CUSTOMER";
  static const String provider = "PROVIDER";
  static const String languageSelected = "language_selected";
  static const String splashSeen = "splash_seen";
  static const String refreshToken = "refresh_token";
  static const String userId = "user_id";
  static const String userEmail = "user_email";



  /// ================= GET =================
  static Future<String> getString(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key) ?? "";
  }

  /// ================= SET =================
  static Future<void> setString(String key, String value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(key, value);
  }

  /// ================= REMOVE =================
  static Future<void> remove(String key) async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(key, value);
  }

  static Future<bool> getBool(String key) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? false;
  }


  static Future<void> clearSessionData() async {
    final pref = await SharedPreferences.getInstance();

    //  Remove session-based data
    await pref.remove("user_id");
    await pref.remove(refreshToken);
    await pref.remove("user_email");
    await pref.remove(userRole);

    //  DO NOT REMOVE refresh_token
  }


}
