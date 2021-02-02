import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DispositivosGuardadosService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<void> insertUuid(String uuid) async {
    final SharedPreferences prefs = await _prefs;
    List<String> lista = await getUuid();
    if (lista == null) {
      lista = new List<String>();
    }

    if (lista.indexOf(uuid) == -1) {
      lista.add(uuid);
      prefs.setStringList('Dispositivos', lista);
    }
  }

  Future<void> deleteUuid(String uuid) async {
    final SharedPreferences prefs = await _prefs;
    List<String> lista = await getUuid();
    if (lista == null) {
      lista = new List<String>();
    }

    if (lista.indexOf(uuid) != -1) {
      lista.remove(uuid);
      prefs.setStringList('Dispositivos', lista);
    }
  }

  Future<List<String>> getUuid() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getStringList('Dispositivos');
  }
}
