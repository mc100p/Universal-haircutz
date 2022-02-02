import 'package:flutter/material.dart';
import 'package:universalhaircutz/utils/themeProvider.dart';
import 'package:universalhaircutz/utils/widget.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context, 'Settings'),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: ListTile(
              title: Text("Dark Theme"),
              trailing: ChangeThemeButtonWidget(),
            ),
          )
        ],
      ),
    );
  }
}
