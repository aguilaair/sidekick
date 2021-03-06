import 'package:flutter/material.dart';
import 'package:sidekick/components/atoms/copy_button.dart';
import 'package:sidekick/components/atoms/group_tile.dart';
import 'package:sidekick/components/atoms/list_tile.dart';
import 'package:sidekick/components/atoms/typography.dart';
import 'package:sidekick/dto/release.dto.dart';
import 'package:sidekick/utils/open_link.dart';

class AdvancedInfoTile extends StatelessWidget {
  final ReleaseDto version;
  const AdvancedInfoTile(this.version, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (version.release == null) {
      return const SizedBox(height: 0);
    }

    return FvmGroupListTile(
      title: const Text('Advanced'),
      children: [
        FvmListTile(
          title: const Text('Download Zip'),
          subtitle: const Caption('Zip file with all release dependencies.'),
          trailing: IconButton(
            icon: const Icon(Icons.cloud_download),
            onPressed: () async {
              await openLink(version.release.archiveUrl);
            },
          ),
        ),
        const Divider(),
        FvmListTile(
          title: const Text('Hash'),
          subtitle: Caption(version.release.hash),
          trailing: CopyButton(version.release.hash),
        ),
        const Divider(),
        FvmListTile(
          title: const Text('Sha256'),
          subtitle: Caption(version.release.sha256),
          trailing: CopyButton(version.release.sha256),
        ),
      ],
    );
  }
}
