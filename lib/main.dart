import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:sidekick/app_shell.dart';
import 'package:sidekick/constants.dart';
import 'package:sidekick/dto/settings.dto.dart';
import 'package:sidekick/screens/error_db_screen.dart';
import 'package:sidekick/services/settings_service.dart';
import 'package:sidekick/theme.dart';
import 'package:sidekick/utils/get_theme_mode.dart';
import 'package:window_size/window_size.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(SidekickSettingsAdapter());
  await Hive.initFlutter();

  try {
    await SettingsService.init();
  } on FileSystemException {
    print("There was an issue opening the DB");
  }

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle(kAppTitle);
    setWindowMinSize(const Size(800, 500));
    setWindowMaxSize(Size.infinite);
  }

  runApp(ProviderScope(child: FvmApp()));
}

class FvmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (SettingsService.box == null) {
      return const ErrorDBScreen();
    }

    return ValueListenableBuilder(
      valueListenable: SettingsService.box.listenable(),
      builder: (context, box, widget) {
        final settings = SettingsService.read();

        return OKToast(
          child: MaterialApp(
            title: kAppTitle,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: getThemeMode(settings.themeMode),
            home: const AppShell(),
          ),
        );
      },
    );
  }
}
