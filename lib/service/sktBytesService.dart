import 'package:shared_preferences/shared_preferences.dart';

class SktBytesService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  setKey(String key) {
    _prefs.then((value) => value.setString("skt", key));
  }

  Future<String> getKey() async {
    final SharedPreferences prefs = await _prefs;
    String v4 = prefs.getString("skt");

    return v4;
  }
}
