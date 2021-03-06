import 'package:flutter/material.dart';
import 'package:sidekick/dto/settings.dto.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:sidekick/utils/get_theme_mode.dart';
import 'package:sidekick/utils/notify.dart';
import 'package:sidekick/version.dart';

class SettingsSectionGeneral extends StatelessWidget {
  final Settings settings;
  final void Function() onSave;

  const SettingsSectionGeneral(
    this.settings,
    this.onSave, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void handleReset() async {
      // flutter defined function
      showDialog(
        context: context,
        builder: (context) {
          // return object of type Dialog
          return AlertDialog(
            title: const Text("Are you sure you want to reset settings?"),
            content: const Text(
              'This will only reset Sidekick specific preferences',
            ),
            buttonPadding: const EdgeInsets.all(15),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text("Confirm"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  settings.sidekick = SidekickSettings();
                  onSave();
                  notify('App settings have been reset');
                },
              ),
            ],
          );
        },
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: ListView(
        children: [
          Text('General', style: Theme.of(context).textTheme.headline6),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text("Advanced Mode"),
            subtitle: const Text(
              'Enables more advanced and experimental functionality.',
            ),
            value: settings.sidekick.advancedMode,
            onChanged: (value) {
              settings.sidekick.advancedMode = value;
              onSave();
            },
          ),
          const Divider(),
          ListTile(
            title: const Text("Theme"),
            subtitle: const Text(
              'Select a theme or switch according to system settings..',
            ),
            trailing: DropdownButton(
              underline: Container(),
              isDense: true,
              value: settings.sidekick.themeMode.toString(),
              items: const [
                DropdownMenuItem(
                  child: Text("System"),
                  value: SettingsThemeMode.system,
                ),
                DropdownMenuItem(
                  child: Text("Light"),
                  value: SettingsThemeMode.light,
                ),
                DropdownMenuItem(
                  child: Text("Dark"),
                  value: SettingsThemeMode.dark,
                ),
              ],
              onChanged: (themeMode) async {
                settings.sidekick.themeMode = themeMode;
                onSave();
              },
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text('Version'),
            trailing: Text(appVersion),
          ),
          const Divider(),
          ListTile(
            title: const Text('Reset to default settings'),
            trailing: OutlinedButton(
              onPressed: handleReset,
              child: const Text('Reset'),
            ),
          ),
        ],
      ),
    );
  }
}
