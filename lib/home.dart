import 'dart:async';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:beacon_broadcast/beacon_broadcast.dart';
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

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FlutterBlueBeacon flutterBlueBeacon = FlutterBlueBeacon.instance;
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<String, Beacon> beacons = new Map();
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
      beacons = Map<String, Beacon>();
    });
  }

  _startScan() {
    print("Scanning now");
    _scanSubscription =
        flutterBlueBeacon.scan(Duration(seconds: 20)).listen((beacon) {
      print('localName: ${beacon.scanResult.advertisementData.localName}');
      print(
          'manufacturerData: ${beacon.scanResult.advertisementData.manufacturerData}');
      print('serviceData: ${beacon.scanResult.advertisementData.serviceData}');
      setState(() {
        beacons[beacon.id] = beacon;
      });
    });

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

  DesencryptUuid _desencryptUuid = DesencryptUuid();
  DispositivosGuardadosService sqlLiteService =
      new DispositivosGuardadosService();
  List<Widget> _buildScanResultTiles() {
    return beacons.values.map<Widget>((b) {
      if (b is IBeacon) {
        if (b.distance < 3) {
          sqlLiteService.insertUuid(b.uuid);
        }

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
              Text(
                "Distancia",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                b.distance.toString(),
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

  void _buildPopupDialog(BuildContext context) {
    var alert = AlertDialog(
      title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Hello"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            /**/
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  _buildProgressBarTile() {
    return new LinearProgressIndicator();
  }

  CurrentUuidService currentUuidService = CurrentUuidService();
  bool alerta = false;
  BroadcastKeyService broadCastKeyservice = new BroadcastKeyService();
  bool inicioBroadcast = false;
  bool primera = true;
  HttpService httpService = HttpService();
  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 30), (timer) {
      _startScan();
    });

    Timer.periodic(Duration(seconds: 120), (timer) {
      _desencryptUuid.revisarPasswordPublicadas().then((value) {
        if (value) {
          setState(() {
            alerta = value;
          });
        }
      });
    });
    /*httpService.getPassword();
    broadCastKeyservice.getKey();
    ProtocoloService protocoloService = new ProtocoloService();
    protocoloService.cryptoBrodcasKey();
    protocoloService.changeCryptoKey();*/

    currentUuidService.getCurrentUuid3().then((event) {
      print(event);
      if (event != null) {
        beaconBroadcast();

        v4 = event;
      } else {
        currentUuidService.setCurrentUuid(uuid.v4());
        inicioBroadcast = false;
      }
    });

    if (primera) {
      PermissionsService().requestLocationAlwaysPermission();
      PermissionsService().requestLocationPermission();
      PermissionsService().requestLocationWhenInUsePermission();

      primera = false;
    }

    var tiles = new List<Widget>();
    if (state != BluetoothState.on) {}

    tiles.addAll(_buildScanResultTiles());

    return Scaffold(
        backgroundColor: Colors.white,
        body: new Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 20.0, top: 70),
              child: RaisedButton(
                onPressed: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
                    animType: AnimType.BOTTOMSLIDE,
                    btnOkText: 'Reportar',
                    btnCancelText: 'No',
                    title: 'Reporte',
                    desc: '¿Estas seguro que quieres reportar que tuviste coronavirus?',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      currentUuidService.getCurrentUuid3().then((value) {
                        httpService.setPassword(uuid.unparse(value));
                        currentUuidService.setCurrentUuid(uuid.v4());
                        currentUuidService.getCurrentUuid3().then((value) {
                          beaconBroadcaste.setUUID(uuid.unparse(value));
                          print(uuid.unparse(value));
                          beaconBroadcaste
                              .stop()
                              .then((value) => {beaconBroadcaste.start()});
                        });
                      });
                    },
                  )..show();
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF0D47A1),
                        Color(0xFF1976D2),
                        Color(0xFF42A5F5),
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: const Text('tengo coronavirus',
                      style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
            alerta
                ? Container(
                    margin: const EdgeInsets.only(bottom: 20.0, top: 150),
                    child: Card(
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Cuidado'),
                          Text(
                              "Usted estuvo cerca de una persona con coronavirus"),
                          RaisedButton(
                            onPressed: () {
                              setState(() {
                                alerta = false;
                              });
                            },
                            textColor: Colors.white,
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[Colors.red, Colors.amber],
                                ),
                              ),
                              padding: const EdgeInsets.all(10.0),
                              child: const Text('Entiendo',
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ),
                        ],
                      ),
                    ))
                : Container(),
            Container(
              margin: EdgeInsets.only(top: 290),
              child: new ListView(
                children: tiles,
              ),
            )
          ],
        ));
  }

  BeaconBroadcast beaconBroadcaste = BeaconBroadcast();
  var uuid = Uuid();
  Future<void> beaconBroadcast() async {
    BeaconStatus transmissionSupportStatus =
        await beaconBroadcaste.checkTransmissionSupported();

    if (v4 != null && !inicioBroadcast) {
      inicioBroadcast = true;
      beaconBroadcaste
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
