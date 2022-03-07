import '../../../../generated/l10n.dart';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ChangeButtonConfigurationDialog extends StatefulWidget {
  final String title;
  final String prefKey;

  const ChangeButtonConfigurationDialog({
    Key? key,
    required this.title,
    required this.prefKey,
  }) : super(key: key);

  @override
  _ChangeButtonConfigurationDialogState createState() =>
      _ChangeButtonConfigurationDialogState();
}

class _ChangeButtonConfigurationDialogState
    extends State<ChangeButtonConfigurationDialog> {
  final TextEditingController _textEditingController = TextEditingController();

  String? _prefValue;

  @override
  void initState() {
    super.initState();
    _getString();
  }

  // Get string from preference key
  Future<void> _getString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _prefValue = prefs.getString(widget.prefKey));
  }

  // Set string from preference key
  Future<void> _setString(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(widget.prefKey, value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        S.of(context).changeButtonConfigurationDialogTitle(widget.title),
        style: const TextStyle(
          fontSize: 16,
        ),
        textAlign: TextAlign.center,
      ),
      content: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: _prefValue,
        ),
        controller: _textEditingController,
        keyboardType: TextInputType.text,
      ),
      actions: [
        TextButton(
          child: Text(S.of(context).changeButtonConfigurationDialogCancelLabel,
              style: const TextStyle(color: Colors.black)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text(S.of(context).changeButtonConfigurationDialogSaveLabel,
              style: const TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold)),
          onPressed: () => _setString(_textEditingController.text)
              .then(Navigator.of(context).pop),
        ),
      ],
    );
  }
}
