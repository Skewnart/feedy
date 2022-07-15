import 'package:package_info_plus/package_info_plus.dart';

class AppService {
  AppService();

  Future<String> getVersion() async {
    return PackageInfo.fromPlatform().then((value) => value.version);
  }
}
