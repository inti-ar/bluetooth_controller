import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:bluetooth_controller/src/ble/ble_device_connector.dart';
import 'package:bluetooth_controller/src/ble/ble_device_interactor.dart';
import 'package:functional_data/functional_data.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';

import 'chat_configuration/characteristic_interaction_chat.dart';

part 'chat_tab.g.dart';
//ignore_for_file: annotate_overrides

class ChatTab extends StatelessWidget {
  final DiscoveredDevice device;

  const ChatTab({
    required this.device,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Consumer3<BleDeviceConnector, ConnectionStateUpdate, BleDeviceInteractor>(
        builder: (_, deviceConnector, connectionStateUpdate, serviceDiscoverer,
                __) =>
            _ChatTab(
          viewModel: ChatViewModel(
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
class ChatViewModel extends $ChatViewModel {
  const ChatViewModel({
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

class _ChatTab extends StatefulWidget {
  const _ChatTab({
    required this.viewModel,
    Key? key,
  }) : super(key: key);

  final ChatViewModel viewModel;

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<_ChatTab> {
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
                    S.of(context).chatDeviceID(widget.viewModel.deviceId),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 16.0),
                  child: Text(
                    S.of(context).chatConnectionStatus(
                        widget.viewModel.connectionStatus),
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
                        child: Text(S.of(context).chatConnect),
                      ),
                      ElevatedButton(
                        onPressed: widget.viewModel.deviceConnected
                            ? widget.viewModel.disconnect
                            : null,
                        child: Text(S.of(context).chatDisconnect),
                      ),
                      ElevatedButton(
                        onPressed: widget.viewModel.deviceConnected
                            ? discoverServices
                            : null,
                        child: Text(S.of(context).chatDiscoverServices),
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
        hint: Text(S.of(context).chatServiceSelectorHint),
        value: selectedService,
        onChanged: (service) => setState(() => selectedService = service),
        items: widget.discoveredServices
            .where((service) =>
                service.characteristics.any(isReadableCharacteristic) &&
                service.characteristics.any(isWritableCharacteristic))
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
          hint: Text(S.of(context).chatReadCharacteristicSelectorHint),
          value: selectedReadCharacteristic,
          items: selectedService?.characteristics
              .where(isReadableCharacteristic)
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
          hint: Text(S.of(context).chatWriteCharacteristicSelectorHint),
          value: selectedWriteCharacteristic,
          items: selectedService?.characteristics
              .where(isWritableCharacteristic)
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

  bool isWritableCharacteristic(c) =>
      c.isWritableWithResponse || c.isWritableWithoutResponse;

  _selectorInterface() => Padding(
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
                          .any(isReadableCharacteristic) ==
                      true
              ? _readCharacteristicSelector()
              : const SizedBox(),

          // Select a write characteristic
          selectedService != null &&
                  selectedService?.characteristics
                          .any(isWritableCharacteristic) ==
                      true
              ? _writeCharacteristicSelector()
              : const SizedBox(),
        ]),
      );

  bool isReadableCharacteristic(c) => c.isNotifiable || c.isIndicatable;

  _chatInterface() => CharacteristicInteractionChat(
        readCharacteristic: QualifiedCharacteristic(
            characteristicId: selectedReadCharacteristic!.characteristicId,
            serviceId: selectedReadCharacteristic!.serviceId,
            deviceId: widget.deviceId),
        writeCharacteristic: QualifiedCharacteristic(
            characteristicId: selectedWriteCharacteristic!.characteristicId,
            serviceId: selectedWriteCharacteristic!.serviceId,
            deviceId: widget.deviceId),
      );

  @override
  Widget build(BuildContext context) => widget.discoveredServices.isEmpty
      ? const SizedBox()
      : selectedService == null ||
              selectedReadCharacteristic == null ||
              selectedWriteCharacteristic == null
          ? _selectorInterface()
          : Column(
              children: [
                _chatInterface(),
                // button to back to the service selector
                ElevatedButton(
                  onPressed: () => setState(() {
                    selectedService = null;
                    selectedReadCharacteristic = null;
                    selectedWriteCharacteristic = null;
                  }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.arrow_back),
                      const SizedBox(width: 8.0),
                      Text(S.of(context).chatBackButtonText),
                    ],
                  ),
                ),
              ],
            );
}
