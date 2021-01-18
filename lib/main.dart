// Copyright 2017, Paul DeMarco.
// All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:beacon_broadcast/beacon_broadcast.dart';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_blue_beacon_androidx/service/broadcastKeyService.dart';
import 'package:flutter_blue_beacon_androidx/service/currentUuidService.dart';
import 'package:flutter_blue_beacon_androidx/service/permissionsService.dart';
import 'package:flutter_blue_beacon_androidx/service/protocoloService.dart';

import 'package:uuid/uuid.dart';

import 'functions/beacon.dart';
import 'functions/flutter_blue_beacon.dart';

void main() {
  runApp(new FlutterBlueApp());
}

class FlutterBlueApp extends StatefulWidget {
  FlutterBlueApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FlutterBlueAppState createState() => new _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  FlutterBlueBeacon flutterBlueBeacon = FlutterBlueBeacon.instance;
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<int, Beacon> beacons = new Map();
  bool isScanning = false;

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;
  List<int> v4;
  @override
  void initState() {
    super.initState();
    // Immediately get the state of FlutterBlue

    // Subscribe to state changes
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    super.dispose();
  }

  _clearAllBeacons() {
    setState(() {
      beacons = Map<int, Beacon>();
    });
  }

  _startScan() {
    print("Scanning now");
    _scanSubscription = flutterBlueBeacon
        .scan(timeout: const Duration(seconds: 20))
        .listen((beacon) {
      print('localName: ${beacon.scanResult.advertisementData.localName}');
      print(
          'manufacturerData: ${beacon.scanResult.advertisementData.manufacturerData}');
      print('serviceData: ${beacon.scanResult.advertisementData.serviceData}');
      setState(() {
        beacons[beacon.hash] = beacon;
      });
    }, onDone: _stopScan);

    setState(() {
      isScanning = true;
    });
  }

  _stopScan() {
    print("Scan stopped");
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      isScanning = false;
    });
  }

  _buildScanningButton() {
    if (isScanning) {
      return new FloatingActionButton(
        child: new Icon(Icons.stop),
        onPressed: _stopScan,
        backgroundColor: Colors.red,
      );
    } else {
      return new FloatingActionButton(
          child: new Icon(Icons.search), onPressed: _startScan);
    }
  }

  List<Widget> _buildScanResultTiles() {
    return beacons.values.map<Widget>((b) {
      if (b is IBeacon) {
        return Card(
          child: Column(
            children: [
              Text(
                "UUID",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                b.uuid,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "name",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                b.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "Type",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "IBeacon",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        );
      }
      if (b is EddystoneUID) {
        return Card(
          child: Column(
            children: [
              Text(
                "UUID",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                b.namespaceId,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "name",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                b.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "Type",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "EddystoneUID",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        );
      }
      if (b is EddystoneEID) {
        return Card(
          child: Column(
            children: [
              Text(
                "UUID",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                b.ephemeralId,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "name",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                b.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
              Text(
                "Type",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                "EddystoneEID",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        );
      }
      return Card();
    }).toList();
  }

  _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }

  BroadcastKeyService broadCastKeyservice = new BroadcastKeyService();
  bool inicioBroadcast = false;
  bool primera = true;

  @override
  Widget build(BuildContext context) {
    broadCastKeyservice.getKey();
    ProtocoloService protocoloService = new ProtocoloService();
    protocoloService.cryptoBrodcasKey();
    protocoloService.changeCryptoKey();
    CurrentUuidService currentUuidService = CurrentUuidService();
    currentUuidService.getCurrentUuid().then((value) => value.listen((event) {
          if (event != null) {
            beaconBroadcast();

            v4 = event;
          } else {
            inicioBroadcast = false;
          }
        }));

    if (primera) {
      PermissionsService().requestLocationAlwaysPermission();
      PermissionsService().requestLocationPermission();
      PermissionsService().requestLocationWhenInUsePermission();

      primera = false;
    }

    var tiles = new List<Widget>();
    if (state != BluetoothState.on) {}

    tiles.addAll(_buildScanResultTiles());

    return new MaterialApp(
      home: new Scaffold(
        floatingActionButton: _buildScanningButton(),
        body: new Stack(
          children: <Widget>[
            (isScanning) ? _buildProgressBarTile() : new Container(),
            new ListView(
              children: tiles,
            )
          ],
        ),
      ),
    );
  }

  var uuid = Uuid();
  Future<void> beaconBroadcast() async {
    BeaconBroadcast beaconBroadcast = BeaconBroadcast();
    BeaconStatus transmissionSupportStatus =
        await beaconBroadcast.checkTransmissionSupported();

    if (v4 != null && !inicioBroadcast) {
      inicioBroadcast = true;
      beaconBroadcast
          .setUUID(uuid.unparse(v4))
          .setMajorId(1)
          .setMinorId(100)
          //optional
          .setIdentifier('com.example.myDeviceRegion') //iOS-only, optional
          .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24')
          .setManufacturerId(0x004C)
          .start();
    }
    //Android-only, optional

    //beaconBroadcast.isAdvertising().then((value) => print(value));
  }
}
