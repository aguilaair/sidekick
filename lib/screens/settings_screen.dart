import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sidekick/providers/settings.provider.dart';
import 'package:sidekick/screens/settings_scenes/settings_section_flutter.dart';
import 'package:sidekick/screens/settings_scenes/settings_section_fvm.dart';
import 'package:sidekick/screens/settings_scenes/settings_section_general.dart';
import 'package:sidekick/screens/settings_scenes/settings_section_projects.dart';
import 'package:sidekick/utils/helpers.dart';
import 'package:sidekick/utils/notify.dart';

enum NavSection {
  general,
  projects,
  fvm,
  flutter,
}

const sections = ['General', 'Projects', 'FVM', 'Flutter'];

const sectionIcons = [
  MdiIcons.tune,
  MdiIcons.folderSettings,
  MdiIcons.layers,
  MdiIcons.console
];

typedef RenderSection = Widget Function(Settings, Function(void));

class SettingsScreen extends HookWidget {
  final NavSection section;
  const SettingsScreen({
    this.section = NavSection.general,
    key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = useProvider(settingsProvider.notifier);
    final settings = useProvider(settingsProvider);

    final currentSection = useState(section.index);

    final controller = usePageController(initialPage: section.index);

    void changeSection(int idx) {
      currentSection.value = idx;
      controller.jumpToPage(idx);
    }

    if (settings.sidekick == null) {
      return Container();
    }

    Future<void> handleSave() async {
      try {
        await provider.save(settings);
        notify('Settings have been saved');
      } on Exception catch (e) {
        notifyError('Could not save settings');
        notifyError(e.toString());
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: const [
          CloseButton(),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        child: Row(
          children: [
            const SizedBox(width: 50),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: ListView(
                  children: sections.mapIndexed(
                    (section, idx) {
                      return ListTile(
                        leading: Icon(
                          sectionIcons[idx],
                          size: 20,
                        ),
                        title: Text(
                          section,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        selectedTileColor: Theme.of(context).hoverColor,
                        selected: currentSection.value == idx,
                        onTap: () => changeSection(idx),
                      );
                    },
                  ).toList(),
                ),
              ),
            ),
            const SizedBox(width: 60),
            Expanded(
              flex: 3,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                controller: controller,
                children: [
                  SettingsSectionGeneral(settings, handleSave),
                  SettingsSectionProjects(settings, handleSave),
                  SettingsSectionFvm(settings, handleSave),
                  SettingsSectionFlutter(settings, handleSave),
                ],
              ),
            ),
            const SizedBox(width: 50),
          ],
        ),
      ),
    );
  }
}
