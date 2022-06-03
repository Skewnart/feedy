import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedy/models/plant_type.model.dart';

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
