import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class BroadcastKeyService {
  Uuid _uuid = new Uuid();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future generateKey() {
    _prefs.then((value) => value.setString("broadcast_key", _uuid.v4()));
  }

  Future<String> getKey() async {
    final SharedPreferences prefs = await _prefs;
    String v4 = prefs.getString("broadcast_key");
    if (v4 == null) {
      generateKey().then((value) => {v4 = prefs.getString("broadcast_key")});
      print(v4);
    }

    return v4;
  }
}
