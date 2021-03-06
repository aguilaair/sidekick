import 'package:github/github.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:sidekick/version.dart';

/// Latest Version update for package
class LatestVersion {
  final bool needUpdate;
  final String latestVersion;
  final String currentVersion;

  /// Constructor
  LatestVersion({
    this.needUpdate = false,
    this.latestVersion = '',
    this.currentVersion = appVersion,
  });
}

/// Helper method to easily check for updates on [packageName]
/// comparing with [currentVersion] returns `LatestVersion`
Future<LatestVersion> checkLatestRelease() async {
  try {
    final latestRelease = await GitHub(
      auth: Authentication.anonymous(),
    ).repositories.getLatestRelease(
          RepositorySlug(
            "leoafarias",
            "sidekick",
          ),
        );

    final latestVersion = Version.parse((latestRelease.tagName));
    final currentVersion = Version.parse(appVersion);

    final needUpdate = latestVersion > currentVersion;

    return LatestVersion(
      needUpdate: needUpdate,
      latestVersion: latestVersion.toString(),
      currentVersion: currentVersion.toString(),
    );
  } on Exception {
    //TODO: Need to do some error logging here
    return LatestVersion();
  }
}
