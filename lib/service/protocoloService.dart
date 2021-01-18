import 'dart:async';
import 'dart:convert';

import 'package:aes_crypt/aes_crypt.dart';
import 'package:crypto/crypto.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_beacon_androidx/service/currentUuidService.dart';
import 'package:flutter_blue_beacon_androidx/service/sktBytesService.dart';
import 'package:flutter_blue_beacon_androidx/service/timeKeyService.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'broadcastKeyService.dart';

class ProtocoloService {
  cryptoBrodcasKey() {
    SktBytesService sktBytesService = new SktBytesService();
    sktBytesService.getKey().then((value2) {
      if (value2 != null) {
        Timer.periodic(Duration(days: 1), (timer) {
          TimeKeyService timeKeyService = TimeKeyService();
          timeKeyService.setTimer(timer.tick);
          BroadcastKeyService broadcastKeyService = BroadcastKeyService();
          broadcastKeyService.getKey().then((value) {
            sktBytesService.getKey().then((value3) {
              List<int> bytes = utf8.encode(value3);
              sktBytesService.setKey(sha1.convert(bytes).toString());
            });
          });
        });
      } else {
        BroadcastKeyService broadcastKeyService = BroadcastKeyService();
        broadcastKeyService.getKey().then((value) {
          List<int> bytes = utf8.encode(value);
          sktBytesService.setKey(sha1.convert(bytes).toString());
        });
      }
    });
  }

  changeCryptoKey() {
    BroadcastKeyService broadcastKeyService = BroadcastKeyService();
    broadcastKeyService.getKey().then((value2) {
      print(value2);
    });
    TimeKeyService timeKeyService = new TimeKeyService();
    timeKeyService.getTimer2().then((value) {
      if (value != null) {
        Timer.periodic(Duration(seconds: 1), (timer) {
          SktBytesService sktBytesService = new SktBytesService();

          sktBytesService.getKey().then((value) {
            List<int> bytes = utf8.encode(value);
            BroadcastKeyService broadcastKeyService = BroadcastKeyService();
            broadcastKeyService.getKey().then((value2) {
              var crypt = AesCrypt();
              crypt.setPassword(value);
              List<int> bytes2 = utf8.encode(value2);
              CurrentUuidService currentUuidService = new CurrentUuidService();
              var key = String.fromCharCodes(
                  (crypt.hmacSha256(bytes2, (sha256.convert(bytes).bytes))));

              currentUuidService.setCurrentUuid(key);
            });
          });
        });
      } else {
        SktBytesService sktBytesService = new SktBytesService();
        timeKeyService.setTimer2(1);
        sktBytesService.getKey().then((value) {
          List<int> bytes = utf8.encode(value);
          BroadcastKeyService broadcastKeyService = BroadcastKeyService();
          broadcastKeyService.getKey().then((value2) {
            var crypt = AesCrypt();
            crypt.setPassword(value);
            CurrentUuidService currentUuidService = new CurrentUuidService();
            List<int> bytes2 = utf8.encode(value2);
            var key = crypt
                .hmacSha256(bytes2, (sha256.convert(bytes).bytes))
                .toString();
            currentUuidService.setCurrentUuid(key);
          });
        });
      }
    });
  }
}
