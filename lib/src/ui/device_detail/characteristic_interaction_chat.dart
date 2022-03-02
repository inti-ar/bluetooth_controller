import 'dart:async';

import '../../../generated/l10n.dart';

import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:bluetooth_controller/src/ble/ble_device_interactor.dart';
import 'package:provider/provider.dart';

// Message object
class Message {
  final String content;
  final String sender;

  Message({required this.content, required this.sender});
}

class CharacteristicInteractionChat extends StatelessWidget {
  const CharacteristicInteractionChat({
    required this.readCharacteristic,
    required this.writeCharacteristic,
    Key? key,
  }) : super(key: key);
  final QualifiedCharacteristic readCharacteristic;
  final QualifiedCharacteristic writeCharacteristic;

  @override
  Widget build(BuildContext context) => Consumer<BleDeviceInteractor>(
      builder: (context, interactor, _) => _CharacteristicInteractionChat(
            characteristicRead: readCharacteristic,
            characteristicWrite: writeCharacteristic,
            readCharacteristic: interactor.readCharacteristic,
            writeWithResponse: interactor.writeCharacteristicWithResponse,
            writeWithoutResponse: interactor.writeCharacteristicWithoutResponse,
            subscribeToCharacteristic: interactor.subScribeToCharacteristic,
          ));
}

class _CharacteristicInteractionChat extends StatefulWidget {
  const _CharacteristicInteractionChat({
    required this.characteristicRead,
    required this.characteristicWrite,
    required this.readCharacteristic,
    required this.writeWithResponse,
    required this.writeWithoutResponse,
    required this.subscribeToCharacteristic,
    Key? key,
  }) : super(key: key);

  final QualifiedCharacteristic characteristicRead;
  final QualifiedCharacteristic characteristicWrite;
  final Future<List<int>> Function(QualifiedCharacteristic characteristic)
      readCharacteristic;
  final Future<void> Function(
          QualifiedCharacteristic characteristic, List<int> value)
      writeWithResponse;

  final Stream<List<int>> Function(QualifiedCharacteristic characteristic)
      subscribeToCharacteristic;

  final Future<void> Function(
          QualifiedCharacteristic characteristic, List<int> value)
      writeWithoutResponse;

  @override
  _CharacteristicInteractionChatState createState() =>
      _CharacteristicInteractionChatState();
}

class _CharacteristicInteractionChatState
    extends State<_CharacteristicInteractionChat> {
  late List<Message> messages;
  late TextEditingController textEditingController;
  late StreamSubscription<List<int>>? subscribeStream;

  @override
  void initState() {
    messages = <Message>[];
    textEditingController = TextEditingController();
    subscribeCharacteristic();
    super.initState();
  }

  @override
  void dispose() {
    subscribeStream?.cancel();
    super.dispose();
  }

  String parseData(List<int> data) {
    return String.fromCharCodes(data);
  }

  void onNewReceivedData(List<int> data) {
    messages.add(Message(
        sender: S.of(context).chatDeviceMessageSender,
        content: parseData(data)));
  }

  Future<void> subscribeCharacteristic() async {
    subscribeStream = widget
        .subscribeToCharacteristic(widget.characteristicRead)
        .listen((event) {
      setState(() {
        onNewReceivedData(event);
      });
    });
  }

  List<int> _parseInput() => textEditingController.text.codeUnits;

  Future<void> writeCharacteristicWithResponse() async {
    final value = _parseInput();
    await widget.writeWithResponse(widget.characteristicWrite, value);
    setState(() {
      messages.add(Message(
          content: parseData(value),
          sender: S.of(context).chatOwnMessageSender));
      textEditingController.clear();
    });
  }

  Future<void> writeCharacteristicWithoutResponse() async {
    final value = _parseInput();
    await widget.writeWithoutResponse(widget.characteristicWrite, value);
    setState(() {
      messages.add(Message(
          content: parseData(value),
          sender: S.of(context).chatOwnMessageSender));
      textEditingController.clear();
    });
  }

  Function() get writeCharacteristic => writeCharacteristicWithResponse;

  List<Widget> get writeSection => [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () => {
                      textEditingController = TextEditingController(
                          text: S.of(context).chatOriginalTextOn),
                      writeCharacteristic()
                    },
                child: Text(S.of(context).chatOnMessage)),
            ElevatedButton(
                onPressed: () => {
                      textEditingController = TextEditingController(
                          text: S.of(context).chatOriginalTextOff),
                      writeCharacteristic()
                    },
                child: Text(S.of(context).chatOffMessage)),
          ],
        ),
        TextField(
          controller: textEditingController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            icon: const Icon(Icons.message),
            labelText: 'Message',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: writeCharacteristic,
            ),
          ),
          // text input type text
          keyboardType: TextInputType.text,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final pHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        SizedBox(
          height: pHeight * 0.46,
          child: messages.isEmpty
              ? Container()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) => Column(
                    crossAxisAlignment: messages[index].sender ==
                            S.of(context).chatOwnMessageSender
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Text(
                        messages[index].sender,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(messages[index].content),
                    ],
                  ),
                ),
        ),
        SizedBox(
          height: pHeight * 0.15,
          child: BottomAppBar(
            child: ListView(
              shrinkWrap: false,
              children: writeSection,
            ),
          ),
        ),
      ],
    );
  }
}
