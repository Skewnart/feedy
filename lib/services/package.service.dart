import 'package:package_info_plus/package_info_plus.dart';

class PackageService {
  PackageService();

  Future<String> getVersion() async {
    return PackageInfo.fromPlatform().then((value) => value.version);
  }
}
