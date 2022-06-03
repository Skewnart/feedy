import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class StorageService {
  String? path;

  StorageService();

  Future<String> getPath(String filename) async {
    String dir =
        path ?? (path = (await getApplicationDocumentsDirectory()).path);
    return "$dir/$filename";
  }

  void writeFile(String filename, Uint8List data) async {
    String dir =
        path ?? (path = (await getApplicationDocumentsDirectory()).path);
    File("$dir/$filename").writeAsBytes(data);
  }
}
