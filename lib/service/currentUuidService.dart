import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class CurrentUuidService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> setCurrentUuid(String uuid) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("currentKey", uuid);
    return uuid;
  }

  var uuid = Uuid();
  Future<Stream<List<int>>> getCurrentUuid() async {
    final SharedPreferences prefs = await _prefs;
    return Stream<List<int>>.periodic(const Duration(minutes: 1), (x) {
      if (prefs.getString("currentKey").codeUnits == null) {
        setCurrentUuid(uuid.v4()).then((value) => value.codeUnits);
      } else {
        return prefs.getString("currentKey").codeUnits;
      }
    });
  }

  getCurrentUuid2() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString("currentKey");
  }

  Future<List<int>> getCurrentUuid3() async {
    final SharedPreferences prefs = await _prefs;
    List<int> bytes;
    if (prefs.getString("currentKey") == null) {
      setCurrentUuid(uuid.v4()).then((value) => {bytes = value.codeUnits});
    } else {
      bytes = prefs.getString("currentKey").codeUnits;
    }

    return bytes;
  }
}
