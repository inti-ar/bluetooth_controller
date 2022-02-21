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

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "bleStatusDefault": m0,
        "bleStatusLocationDisabled": MessageLookupByLibrary.simpleMessage(
            "Habilitá los servicios de ubicación para poder conectar el Bluetooth con otros dispositivos"),
        "bleStatusPoweredOff": MessageLookupByLibrary.simpleMessage(
            "El Bluetooth está deshabilitado en tu dispositivo"),
        "bleStatusReady": MessageLookupByLibrary.simpleMessage(
            "Bluetooth habilitado y funcionando"),
        "bleStatusUnauthorized": MessageLookupByLibrary.simpleMessage(
            "Autorizá la aplicación para utilizar Bluetooth y la ubicación"),
        "bleStatusUnsupported": MessageLookupByLibrary.simpleMessage(
            "Este dispositivo no soporta Bluetooth"),
        "bleTurnOnBluetooth":
            MessageLookupByLibrary.simpleMessage("Activá Bluetooth"),
        "deviceListInvalidUUID":
            MessageLookupByLibrary.simpleMessage("Formato de UUID inválido"),
        "deviceListSearchServiceUUID":
            MessageLookupByLibrary.simpleMessage("UUID de servicio:"),
        "deviceListTitle":
            MessageLookupByLibrary.simpleMessage("Escáner de dispositivos"),
        "title": MessageLookupByLibrary.simpleMessage("Botonera Bluetooth")
      };
}
