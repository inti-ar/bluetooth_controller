// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:inti_bluetooth_controller/main.dart';

void main() {
  testWidgets('Initial screen loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify initial text to connect Bluetooth.
    expect(
        find.text('Connect Bluetooth device and control it'), findsOneWidget);

    // Tap the start button and trigger a frame.
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.pump();

    // Tap the stop button and trigger a frame.
    await tester.tap(find.byIcon(Icons.stop));
    await tester.pump();

    // Tap the configure button and trigger a frame.
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();
  });
}
