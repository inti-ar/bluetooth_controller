// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(status) => "Waiting to fetch Bluetooth status ${status}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "bleStatusDefault": m0,
        "bleStatusLocationDisabled":
            MessageLookupByLibrary.simpleMessage("Enable location services"),
        "bleStatusPoweredOff": MessageLookupByLibrary.simpleMessage(
            "Bluetooth is powered off on your device turn it on"),
        "bleStatusReady":
            MessageLookupByLibrary.simpleMessage("Bluetooth is up and running"),
        "bleStatusUnauthorized": MessageLookupByLibrary.simpleMessage(
            "Authorize the INTI Bluetooth Controller app to use Bluetooth and location"),
        "bleStatusUnsupported": MessageLookupByLibrary.simpleMessage(
            "This device does not support Bluetooth"),
        "bleTurnOnBluetooth":
            MessageLookupByLibrary.simpleMessage("Turn on Bluetooth"),
        "deviceListInvalidUUID":
            MessageLookupByLibrary.simpleMessage("Invalid UUID format"),
        "deviceListSearchServiceUUID":
            MessageLookupByLibrary.simpleMessage("Service UUID:"),
        "deviceListTitle":
            MessageLookupByLibrary.simpleMessage("Scan for devices"),
        "title":
            MessageLookupByLibrary.simpleMessage("INTI Bluetooth Controller")
      };
}
