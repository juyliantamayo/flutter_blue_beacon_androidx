import 'package:flutter_blue_beacon_androidx/service/httpService.dart';
import 'package:flutter_blue_beacon_androidx/service/dispositivosGuardados.dart';
import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DesencryptUuid {
  HttpService httpService = HttpService();
  DispositivosGuardadosService sqlLiteService = DispositivosGuardadosService();

  Future<bool> revisarPasswordPublicadas() async {
    bool compatibilidad = false;
    await httpService.getPassword().then((value) async {
      List<dynamic> lista = json.decode(value.body)['result'];
      // ignore: await_only_futures
      await lista.forEach((element) async {
        bool bandera = await desencriptarUuid(element['passwordKey']);
        if (bandera) {
          sqlLiteService.deleteUuid(element['passwordKey']);
          compatibilidad = bandera;
        }
      });
    });
    return compatibilidad;
  }

  var uuid = Uuid();

  Future<bool> desencriptarUuid(String element) async {
    bool bandera = false;
    /* List<int> bytes = utf8.encode(element);
    List<int> bytes3 = utf8.encode(sha1.convert(bytes).toString());

    var crypt = AesCrypt();
    crypt.setPassword(element);
    List<int> bytes2 = utf8.encode(element);
    List<int> key = crypt
        .hmacSha256(bytes2, (sha256.convert(bytes3).bytes))
        .toString()
        .codeUnits;
*/
    await sqlLiteService.getUuid().then((value) => {
          if (value.indexOf(element) != -1) {bandera = true}
        });
    return bandera;
  }
}
