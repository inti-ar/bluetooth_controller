import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:bluetooth_controller/src/ble/ble_scanner.dart';
import 'package:provider/provider.dart';

import '../widgets.dart';
import 'device_detail/device_detail_screen.dart';

import '../../generated/l10n.dart';

class DeviceListScreen extends StatelessWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer2<BleScanner, BleScannerState?>(
        builder: (_, bleScanner, bleScannerState, __) => _DeviceList(
          scannerState: bleScannerState ??
              const BleScannerState(
                discoveredDevices: [],
                scanIsInProgress: false,
              ),
          startScan: bleScanner.startScan,
          stopScan: bleScanner.stopScan,
        ),
      );
}

class _DeviceList extends StatefulWidget {
  const _DeviceList(
      {required this.scannerState,
      required this.startScan,
      required this.stopScan});

  final BleScannerState scannerState;
  final void Function(List<Uuid>) startScan;
  final VoidCallback stopScan;

  @override
  _DeviceListState createState() => _DeviceListState();
}

class _DeviceListState extends State<_DeviceList> {
  late TextEditingController _uuidController;

  @override
  void initState() {
    super.initState();
    _uuidController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    widget.stopScan();
    _uuidController.dispose();
    super.dispose();
  }

  bool _isValidUuidInput() {
    final uuidText = _uuidController.text;
    if (uuidText.isEmpty) {
      return true;
    } else {
      try {
        Uuid.parse(uuidText);
        return true;
      } on Exception {
        return false;
      }
    }
  }

  void _startScanning() {
    final text = _uuidController.text;
    widget.startScan(text.isEmpty ? [] : [Uuid.parse(_uuidController.text)]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).deviceListTitle),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(S.of(context).deviceListSearchServiceUUID),
                  TextField(
                    controller: _uuidController,
                    enabled: !widget.scannerState.scanIsInProgress,
                    decoration: InputDecoration(
                        errorText:
                            _uuidController.text.isEmpty || _isValidUuidInput()
                                ? null
                                : S.of(context).deviceListInvalidUUID),
                    autocorrect: false,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        child: Text(S.of(context).deviceListScan),
                        onPressed: !widget.scannerState.scanIsInProgress &&
                                _isValidUuidInput()
                            ? _startScanning
                            : null,
                      ),
                      ElevatedButton(
                        child: Text(S.of(context).deviceListStop),
                        onPressed: widget.scannerState.scanIsInProgress
                            ? widget.stopScan
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(!widget.scannerState.scanIsInProgress
                            ? S.of(context).deviceListTapToScan
                            : S.of(context).deviceListTapToConnect),
                      ),
                      if (widget.scannerState.scanIsInProgress ||
                          widget.scannerState.discoveredDevices.isNotEmpty)
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.only(start: 18.0),
                          child: Text(
                            S.of(context).deviceListDiscoveredDevicesCount(
                                widget.scannerState.discoveredDevices.length),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: ListView(
                children: widget.scannerState.discoveredDevices
                    .map(
                      (device) => ListTile(
                        title: Text(device.name),
                        subtitle: Text(
                          S.of(context).deviceListDiscoveredDeviceSubtitle(
                              device.id, device.rssi),
                        ),
                        leading: const BluetoothIcon(),
                        onTap: () async {
                          widget.stopScan();
                          await Navigator.push<void>(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      DeviceDetailScreen(device: device)));
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      );
}
