import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' show Intl, toBeginningOfSentenceCase;
import 'generated/l10n.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:bluetooth_controller/src/ble/ble_device_connector.dart';
import 'package:bluetooth_controller/src/ble/ble_device_interactor.dart';
import 'package:bluetooth_controller/src/ble/ble_scanner.dart';
import 'package:bluetooth_controller/src/ble/ble_status_monitor.dart';
import 'package:bluetooth_controller/src/ui/ble_status_screen.dart';
import 'package:bluetooth_controller/src/ui/device_list.dart';
import 'package:provider/provider.dart';

import 'package:permission_handler/permission_handler.dart';

import 'src/ble/ble_logger.dart';

const _themeColor = Colors.lightBlue;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();

  static of(BuildContext context) =>
      context.findAncestorStateOfType<MyAppState>();
}

class MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = Locale(Intl.defaultLocale ?? "es");
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    final _bleLogger = BleLogger();
    final _ble = FlutterReactiveBle();
    final _scanner = BleScanner(ble: _ble, logMessage: _bleLogger.addToLog);
    final _monitor = BleStatusMonitor(_ble);
    final _connector = BleDeviceConnector(
      ble: _ble,
      logMessage: _bleLogger.addToLog,
    );
    final _serviceDiscoverer = BleDeviceInteractor(
      bleDiscoverServices: _ble.discoverServices,
      readCharacteristic: _ble.readCharacteristic,
      writeWithResponse: _ble.writeCharacteristicWithResponse,
      writeWithOutResponse: _ble.writeCharacteristicWithoutResponse,
      subscribeToCharacteristic: _ble.subscribeToCharacteristic,
      logMessage: _bleLogger.addToLog,
    );

    return MultiProvider(
      providers: [
        Provider.value(value: _scanner),
        Provider.value(value: _monitor),
        Provider.value(value: _connector),
        Provider.value(value: _serviceDiscoverer),
        Provider.value(value: _bleLogger),
        StreamProvider<BleScannerState?>(
          create: (_) => _scanner.state,
          initialData: const BleScannerState(
            discoveredDevices: [],
            scanIsInProgress: false,
          ),
        ),
        StreamProvider<BleStatus?>(
          create: (_) => _monitor.state,
          initialData: BleStatus.unknown,
        ),
        StreamProvider<ConnectionStateUpdate>(
          create: (_) => _connector.state,
          initialData: const ConnectionStateUpdate(
            deviceId: 'Unknown device',
            connectionState: DeviceConnectionState.disconnected,
            failure: null,
          ),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          LocaleNamesLocalizationsDelegate(),
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: _locale,
        title: "INTI Bluetooth Controller",
        color: _themeColor,
        theme: ThemeData(primarySwatch: _themeColor),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _requestPermissions() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();
    await Permission.location.request();
  }

  _languageSelector() => DropdownButton<Locale>(
        icon: const Icon(
          Icons.language,
          color: Colors.white,
        ),
        underline: Container(height: 0),
        items: S.delegate.supportedLocales
            .map(
              (locale) => DropdownMenuItem(
                value: locale,
                child: Text(toBeginningOfSentenceCase(
                        LocaleNames.of(context)?.nameOf(locale.languageCode)) ??
                    locale.languageCode),
              ),
            )
            .toList(),
        onChanged: (locale) {
          setState(() {
            S.load(locale!);
            //MyApp.of(context).setLocale(locale);
          });
        },
      );

  @override
  Widget build(BuildContext context) => Consumer<BleStatus?>(
        builder: (_, status, __) {
          _requestPermissions();
          return Scaffold(
            appBar: AppBar(
              title: status == BleStatus.ready
                  ? Text(S.of(context).deviceListTitle)
                  : Text(S.of(context).title),
              actions: <Widget>[
                _languageSelector(),
              ],
            ),
            body: Center(
              child: status == BleStatus.ready
                  ? const DeviceListScreen()
                  : BleStatusScreen(status: status ?? BleStatus.unknown),
            ),
          );
        },
      );
}
