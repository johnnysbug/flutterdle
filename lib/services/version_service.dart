import 'package:package_info_plus/package_info_plus.dart';

class VersionService {
  Future<PackageInfo> loadVersion() async => await PackageInfo.fromPlatform();
}