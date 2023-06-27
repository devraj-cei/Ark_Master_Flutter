import 'package:ark_master/Utils/AppConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageServices {
  late SharedPreferences _prefs;

  Future<StorageServices> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setUserProfile(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getUserProfile() {
    return _prefs.getString(AppConstants.STORAGE_USER_PROFILE);
  }

  Future<bool> setToken(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getToken() {
    return _prefs.getString(AppConstants.STORAGE_USER_TOKEN);
  }

  Future<bool> setProfilePic(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getProfilePic() {
    return _prefs.getString(AppConstants.STORAGE_PROFILE_PICTURE);
  }

  Future<bool> setAppClientId(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? getAppClientId() {
    return _prefs.getInt(AppConstants.STORAGE_APP_CLIENT_ID);
  }

  Future<bool> setDrawerList(String key, var value) async {
    return await _prefs.setString(key, value);
  }

  String? getDrawerItems() {
    return _prefs.getString(AppConstants.STORAGE_DRAWER_ITEMS);
  }
}
