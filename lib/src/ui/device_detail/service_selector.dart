import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:bluetooth_controller/src/ble/ble_device_connector.dart';
import 'package:bluetooth_controller/src/ble/ble_device_interactor.dart';
import 'package:functional_data/functional_data.dart';
import 'package:provider/provider.dart';

import 'characteristic_interaction_dialog.dart';

part 'service_selector.g.dart';
//ignore_for_file: annotate_overrides

class DeviceInteractionTab extends StatelessWidget {
  final DiscoveredDevice device;

  const DeviceInteractionTab({
    required this.device,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer3<BleDeviceConnector, ConnectionStateUpdate, BleDeviceInteractor>(
        builder: (_, deviceConnector, connectionStateUpdate, serviceDiscoverer,
                __) =>
            _DeviceInteractionTab(
          viewModel: DeviceInteractionViewModel(
              deviceId: device.id,
              connectionStatus: connectionStateUpdate.connectionState,
              deviceConnector: deviceConnector,
              discoverServices: () =>
                  serviceDiscoverer.discoverServices(device.id)),
        ),
      );
}

@immutable
@FunctionalData()
class DeviceInteractionViewModel extends $DeviceInteractionViewModel {
  const DeviceInteractionViewModel({
    required this.deviceId,
    required this.connectionStatus,
    required this.deviceConnector,
    required this.discoverServices,
  });

  final String deviceId;
  final DeviceConnectionState connectionStatus;
  final BleDeviceConnector deviceConnector;
  @CustomEquality(Ignore())
  final Future<List<DiscoveredService>> Function() discoverServices;

  bool get deviceConnected =>
      connectionStatus == DeviceConnectionState.connected;

  void connect() {
    deviceConnector.connect(deviceId);
  }

  void disconnect() {
    deviceConnector.disconnect(deviceId);
  }
}

class _DeviceInteractionTab extends StatefulWidget {
  const _DeviceInteractionTab({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final DeviceInteractionViewModel viewModel;

  @override
  _DeviceInteractionTabState createState() => _DeviceInteractionTabState();
}

class _DeviceInteractionTabState extends State<_DeviceInteractionTab> {
  late List<DiscoveredService> discoveredServices;

  @override
  void initState() {
    discoveredServices = [];
    super.initState();
  }

  Future<void> discoverServices() async {
    final result = await widget.viewModel.discoverServices();
    setState(() {
      discoveredServices = result;
    });
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed(
              [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                      top: 8.0, bottom: 16.0, start: 16.0),
                  child: Text(
                    "ID: ${widget.viewModel.deviceId}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16.0),
                  child: Text(
                    "Status: ${widget.viewModel.connectionStatus}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: !widget.viewModel.deviceConnected
                            ? widget.viewModel.connect
                            : null,
                        child: const Text("Connect"),
                      ),
                      ElevatedButton(
                        onPressed: widget.viewModel.deviceConnected
                            ? widget.viewModel.disconnect
                            : null,
                        child: const Text("Disconnect"),
                      ),
                      ElevatedButton(
                        onPressed: widget.viewModel.deviceConnected
                            ? discoverServices
                            : null,
                        child: const Text("Discover Services"),
                      ),
                    ],
                  ),
                ),
                if (widget.viewModel.deviceConnected)
                  _ServiceDiscoveryList(
                    deviceId: widget.viewModel.deviceId,
                    discoveredServices: discoveredServices,
                  ),
              ],
            ),
          ),
        ],
      );
}

class _ServiceDiscoveryList extends StatefulWidget {
  const _ServiceDiscoveryList({
    required this.deviceId,
    required this.discoveredServices,
    Key? key,
  }) : super(key: key);

  final String deviceId;
  final List<DiscoveredService> discoveredServices;

  @override
  _ServiceDiscoveryListState createState() => _ServiceDiscoveryListState();
}

class _ServiceDiscoveryListState extends State<_ServiceDiscoveryList> {
  DiscoveredService? selectedService;
  DiscoveredCharacteristic? selectedReadCharacteristic;
  DiscoveredCharacteristic? selectedWriteCharacteristic;

  @override
  void initState() {
    super.initState();
  }

  // Service Selector
  Widget _serviceSelector() => DropdownButton<DiscoveredService>(
        hint: const Text("Service UUID"),
        value: selectedService,
        onChanged: (service) => setState(() => selectedService = service),
        items: widget.discoveredServices
            .map(
              (service) => DropdownMenuItem<DiscoveredService>(
                value: service,
                child: Text(
                  '${service.serviceId}',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            )
            .toList(),
      );

  // Read Characteristic Selector
  Widget _readCharacteristicSelector() =>
      DropdownButton<DiscoveredCharacteristic>(
          hint: const Text("Read Characteristic UUID"),
          value: selectedReadCharacteristic,
          items: selectedService?.characteristics
              .where((c) => c.isReadable && c.isNotifiable)
              .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(
                      '${c.characteristicId}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ))
              .toList(),
          onChanged: (DiscoveredCharacteristic? c) {
            setState(() {
              selectedReadCharacteristic = c!;
            });
          });

  // Write Characteristic Selector
  Widget _writeCharacteristicSelector() =>
      DropdownButton<DiscoveredCharacteristic>(
          hint: const Text("Write Characteristic UUID"),
          value: selectedWriteCharacteristic,
          items: selectedService?.characteristics
              .where((c) =>
                  (c.isWritableWithResponse || c.isWritableWithoutResponse) &&
                  c.isIndicatable)
              .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(
                      '${c.characteristicId}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ))
              .toList(),
          onChanged: (DiscoveredCharacteristic? c) {
            setState(() {
              selectedWriteCharacteristic = c!;
            });
          });

  @override
  Widget build(BuildContext context) => widget.discoveredServices.isEmpty
      ? const SizedBox()
      : Padding(
          padding: const EdgeInsetsDirectional.only(
            top: 20.0,
            start: 20.0,
            end: 20.0,
          ),
          child: Column(children: [
            _serviceSelector(),

            // Select a read characteristic
            selectedService != null &&
                    selectedService?.characteristics
                            .any((c) => c.isReadable && c.isNotifiable) ==
                        true
                ? _readCharacteristicSelector()
                : const SizedBox(),

            // Select a write characteristic
            selectedService != null &&
                    selectedService?.characteristics.any((c) =>
                            (c.isWritableWithResponse ||
                                c.isWritableWithoutResponse) &&
                            c.isIndicatable) ==
                        true
                ? _writeCharacteristicSelector()
                : const SizedBox(),
          ]),
        );
}
