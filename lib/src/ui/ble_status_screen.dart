import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:location/location.dart';

import '../../generated/l10n.dart';

class BleStatusScreen extends StatelessWidget {
  const BleStatusScreen({required this.status, Key? key}) : super(key: key);

  final BleStatus status;

  List<Widget> _statusBody(BleStatus status) {
    switch (status) {
      case BleStatus.unsupported:
        return [Text(S.current.bleStatusUnsupported)];
      case BleStatus.unauthorized:
        return [
          Text(S.current.bleStatusUnauthorized),
          ElevatedButton(
            onPressed: (() async {
              await Permission.bluetooth.request();
              await Permission.bluetoothConnect.request();
              await Permission.bluetoothScan.request();
              await Permission.location.request();
            }),
            child: Text(S.current.bleTurnOnBluetooth),
          )
        ];
      case BleStatus.poweredOff:
        return [
          Text(S.current.bleStatusPoweredOff),
          ElevatedButton(
            onPressed: (() {
              _enableBT();
            }),
            child: Text(S.current.bleTurnOnBluetooth),
          )
        ];
      case BleStatus.locationServicesDisabled:
        return [
          Text(S.current.bleStatusLocationDisabled),
          ElevatedButton(
            onPressed: (() async {
              Location.instance.requestService();
            }),
            child: Text(S.current.bleTurnOnLocation),
          )
        ];
      case BleStatus.ready:
        return [Text(S.current.bleStatusReady)];
      default:
        return [Text(S.current.bleStatusDefault(status))];
    }
  }

  Future<void> _enableBT() async {
    await BluetoothEnable.enableBluetooth;
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _statusBody(status),
      );
}
