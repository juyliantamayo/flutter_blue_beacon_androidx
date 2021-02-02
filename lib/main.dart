// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:flutter_blue_beacon_androidx/home.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_blue_beacon_androidx/service/broadcastKeyService.dart';
import 'package:flutter_blue_beacon_androidx/service/currentUuidService.dart';
import 'package:flutter_blue_beacon_androidx/service/httpService.dart';
import 'package:flutter_blue_beacon_androidx/service/permissionsService.dart';
import 'package:flutter_blue_beacon_androidx/service/dispositivosGuardados.dart';

import 'package:uuid/uuid.dart';
import 'package:flutter_blue_beacon_androidx/service/desencryptUiid.dart';
import 'functions/beacon.dart';
import 'functions/flutter_blue_beacon.dart';

void main() {
  runApp(new FlutterApp());
}
class FlutterApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        primarySwatch: Colors.blue,
       
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:Home(),
    );
  }
}
