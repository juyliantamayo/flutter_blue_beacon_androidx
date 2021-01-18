import 'package:shared_preferences/shared_preferences.dart';

class TimeKeyService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  generateTimer() {}
  Future<int> getTimer2() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt("time2");
  }

  setTimer(int time) {
    _prefs.then((value) => value.setInt("time", time));
  }

  setTimer2(int time) {
    _prefs.then((value) => value.setInt("time2", time));
  }
}
