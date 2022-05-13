import 'package:flutter/material.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: ListTile(
            title: const Text('Temperature Unit'),
            subtitle: const Text('Celsius/Fahrenheit (Default: Celsius)'),
            trailing: Switch(
              value: false,
              onChanged: (_){},
            ),
        ),
        ),
    );
  }
}