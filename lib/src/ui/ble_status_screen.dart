import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';

import '../../generated/l10n.dart';

class BleStatusScreen extends StatelessWidget {
  const BleStatusScreen({required this.status, Key? key}) : super(key: key);

  final BleStatus status;

  String determineText(BleStatus status) {
    switch (status) {
      case BleStatus.unsupported:
        return S.current.bleStatusUnsupported;
      case BleStatus.unauthorized:
        return S.current.bleStatusUnauthorized;
      case BleStatus.poweredOff:
        return S.current.bleStatusPoweredOff;
      case BleStatus.locationServicesDisabled:
        return S.current.bleStatusLocationDisabled;
      case BleStatus.ready:
        return S.current.bleStatusReady;
      default:
        return S.current.bleStatusDefault(status);
    }
  }

  Future<void> _enableBT() async {
    await BluetoothEnable.enableBluetooth;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(determineText(status)),
              status == BleStatus.poweredOff
                  ? ElevatedButton(
                      onPressed: (() {
                        _enableBT();
                      }),
                      child: Text(S.of(context).bleTurnOnBluetooth),
                    )
                  : Container(),
            ],
          ),
        ),
      );
}
