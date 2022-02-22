// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `INTI Bluetooth Controller`
  String get title {
    return Intl.message(
      'INTI Bluetooth Controller',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth is up and running`
  String get bleStatusReady {
    return Intl.message(
      'Bluetooth is up and running',
      name: 'bleStatusReady',
      desc: '',
      args: [],
    );
  }

  /// `Enable location services`
  String get bleStatusLocationDisabled {
    return Intl.message(
      'Enable location services',
      name: 'bleStatusLocationDisabled',
      desc: '',
      args: [],
    );
  }

  /// `Bluetooth is powered off on your device turn it on`
  String get bleStatusPoweredOff {
    return Intl.message(
      'Bluetooth is powered off on your device turn it on',
      name: 'bleStatusPoweredOff',
      desc: '',
      args: [],
    );
  }

  /// `Authorize the INTI Bluetooth Controller app to use Bluetooth and location`
  String get bleStatusUnauthorized {
    return Intl.message(
      'Authorize the INTI Bluetooth Controller app to use Bluetooth and location',
      name: 'bleStatusUnauthorized',
      desc: '',
      args: [],
    );
  }

  /// `This device does not support Bluetooth`
  String get bleStatusUnsupported {
    return Intl.message(
      'This device does not support Bluetooth',
      name: 'bleStatusUnsupported',
      desc: '',
      args: [],
    );
  }

  /// `Waiting to fetch Bluetooth status {status}`
  String bleStatusDefault(Object status) {
    return Intl.message(
      'Waiting to fetch Bluetooth status $status',
      name: 'bleStatusDefault',
      desc: '',
      args: [status],
    );
  }

  /// `Turn on Bluetooth`
  String get bleTurnOnBluetooth {
    return Intl.message(
      'Turn on Bluetooth',
      name: 'bleTurnOnBluetooth',
      desc: '',
      args: [],
    );
  }

  /// `Scan for devices`
  String get deviceListTitle {
    return Intl.message(
      'Scan for devices',
      name: 'deviceListTitle',
      desc: '',
      args: [],
    );
  }

  /// `Service UUID:`
  String get deviceListSearchServiceUUID {
    return Intl.message(
      'Service UUID:',
      name: 'deviceListSearchServiceUUID',
      desc: '',
      args: [],
    );
  }

  /// `Invalid UUID format`
  String get deviceListInvalidUUID {
    return Intl.message(
      'Invalid UUID format',
      name: 'deviceListInvalidUUID',
      desc: '',
      args: [],
    );
  }

  /// `Scan`
  String get deviceListScan {
    return Intl.message(
      'Scan',
      name: 'deviceListScan',
      desc: '',
      args: [],
    );
  }

  /// `Stop`
  String get deviceListStop {
    return Intl.message(
      'Stop',
      name: 'deviceListStop',
      desc: '',
      args: [],
    );
  }

  /// `Enter a UUID above and start to scan`
  String get deviceListTapToScan {
    return Intl.message(
      'Enter a UUID above and start to scan',
      name: 'deviceListTapToScan',
      desc: '',
      args: [],
    );
  }

  /// `Tap a device to connect to it`
  String get deviceListTapToConnect {
    return Intl.message(
      'Tap a device to connect to it',
      name: 'deviceListTapToConnect',
      desc: '',
      args: [],
    );
  }

  /// `count: {count}`
  String deviceListDiscoveredDevicesCount(Object count) {
    return Intl.message(
      'count: $count',
      name: 'deviceListDiscoveredDevicesCount',
      desc: '',
      args: [count],
    );
  }

  /// `${deviceID}\nRSSI: ${deviceRSSI}`
  String deviceListDiscoveredDeviceSubtitle(
      Object deviceID, Object deviceRSSI) {
    return Intl.message(
      '\$$deviceID\nRSSI: \$$deviceRSSI',
      name: 'deviceListDiscoveredDeviceSubtitle',
      desc: '',
      args: [deviceID, deviceRSSI],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
