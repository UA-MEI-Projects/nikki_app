import 'package:flutter/material.dart';
import 'package:nikki_app/widgets/nikki_title.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:nikki_app/utils/get_it_init.dart';

import '../db/nikki_shared_pref.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: SettingsList(
        sections: [
          SettingsSection(
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                  title: NikkiTitle(content: "Generate a new Prompt"),
                onPressed: (context)=>{},
              ),
              SettingsTile.navigation(
                leading: Icon(Icons.info),
                title: NikkiTitle(content:'About'),
                onPressed: (context)=>{},
              ),
              SettingsTile.switchTile(
                onToggle: (value) {getIt<NikkiSharedPreferences>().setThemeMode(value);},
                initialValue: true,
                leading: Icon(Icons.dark_mode),
                title: NikkiTitle(content:'Dark Mode'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
