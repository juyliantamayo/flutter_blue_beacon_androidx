import 'package:shared_preferences/shared_preferences.dart';

class CurrentUuidService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  setCurrentUuid(String uuid) {
    _prefs.then((value) => value.setString("currentKey", uuid));
  }

  Future<Stream<List<int>>> getCurrentUuid() async {
    final SharedPreferences prefs = await _prefs;
    return Stream<List<int>>.periodic(const Duration(minutes: 1), (x) {
      return prefs.getString("currentKey").codeUnits;
    });
  }

  getCurrentUuid2() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString("currentKey");
  }
}
