// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static String m0(status) => "Esperando para obtener el estado ${status}";

  static String m1(widgetTitle) =>
      "Cambiar configuración del botón:\n \"${widgetTitle}\"";

  static String m2(connectionStatus) => "Estado: ${connectionStatus}";

  static String m3(deviceID) => "ID: ${deviceID}";

  static String m4(deviceID, deviceRSSI) => "${deviceID}\nRSSI: ${deviceRSSI}";

  static String m5(count) => "cantidad: ${count}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "bleStatusDefault": m0,
        "bleStatusLocationDisabled": MessageLookupByLibrary.simpleMessage(
            "Habilitá los servicios de ubicación"),
        "bleStatusPoweredOff": MessageLookupByLibrary.simpleMessage(
            "El Bluetooth está deshabilitado en tu dispositivo"),
        "bleStatusReady": MessageLookupByLibrary.simpleMessage(
            "Bluetooth habilitado y funcionando"),
        "bleStatusUnauthorized": MessageLookupByLibrary.simpleMessage(
            "Autorizá la aplicación para utilizar Bluetooth y la ubicación"),
        "bleStatusUnsupported": MessageLookupByLibrary.simpleMessage(
            "Este dispositivo no soporta Bluetooth"),
        "bleTurnOnBluetooth":
            MessageLookupByLibrary.simpleMessage("Activar Bluetooth"),
        "bleTurnOnLocation":
            MessageLookupByLibrary.simpleMessage("Activar la ubicación"),
        "changeButtonConfigurationDialogCancelLabel":
            MessageLookupByLibrary.simpleMessage("Cancelar"),
        "changeButtonConfigurationDialogSaveLabel":
            MessageLookupByLibrary.simpleMessage("Guardar"),
        "changeButtonConfigurationDialogTitle": m1,
        "chatBackButtonText": MessageLookupByLibrary.simpleMessage("Volver"),
        "chatConnect": MessageLookupByLibrary.simpleMessage("Conectar"),
        "chatConnectionStatus": m2,
        "chatDeviceID": m3,
        "chatDeviceMessageSender":
            MessageLookupByLibrary.simpleMessage("Dispositivo"),
        "chatDisconnect": MessageLookupByLibrary.simpleMessage("Desconectar"),
        "chatDiscoverServices":
            MessageLookupByLibrary.simpleMessage("Encontrar servicios"),
        "chatOffTitle": MessageLookupByLibrary.simpleMessage("Apagar"),
        "chatOnTitle": MessageLookupByLibrary.simpleMessage("Encender"),
        "chatOriginalTextOff": MessageLookupByLibrary.simpleMessage("0"),
        "chatOriginalTextOn": MessageLookupByLibrary.simpleMessage("1"),
        "chatOwnMessageSender": MessageLookupByLibrary.simpleMessage("Yo"),
        "chatReadCharacteristicSelectorHint":
            MessageLookupByLibrary.simpleMessage(
                "UUID de característica de lectura"),
        "chatServiceSelectorHint":
            MessageLookupByLibrary.simpleMessage("UUID del servicio"),
        "chatWriteCharacteristicSelectorHint":
            MessageLookupByLibrary.simpleMessage(
                "UUID de característica de escritura"),
        "chatWriteMessageLabel":
            MessageLookupByLibrary.simpleMessage("Mensaje"),
        "deviceListDiscoveredDeviceSubtitle": m4,
        "deviceListDiscoveredDevicesCount": m5,
        "deviceListInvalidUUID":
            MessageLookupByLibrary.simpleMessage("Formato de UUID inválido"),
        "deviceListScan": MessageLookupByLibrary.simpleMessage("Escanear"),
        "deviceListSearchServiceUUID":
            MessageLookupByLibrary.simpleMessage("UUID del servicio:"),
        "deviceListStop": MessageLookupByLibrary.simpleMessage("Parar"),
        "deviceListTapToConnect": MessageLookupByLibrary.simpleMessage(
            "Seleccioná un dispositivo para conectar"),
        "deviceListTapToScan": MessageLookupByLibrary.simpleMessage(
            "Ingresá un UUID arriba y comenzá a escanear"),
        "deviceListTitle":
            MessageLookupByLibrary.simpleMessage("Escáner de dispositivos"),
        "title": MessageLookupByLibrary.simpleMessage("Botonera Bluetooth")
      };
}
