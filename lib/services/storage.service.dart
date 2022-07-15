import 'dart:io';
import 'dart:typed_data';
import 'package:feedy/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  String? path;
  final SupabaseClient _client;
  late FlutterSecureStorage _secure_storage;

  StorageService(this._client) {
    _secure_storage = const FlutterSecureStorage();
  }

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

  //Charger l'image du bucket si elle n'a pas déjà été téléchargée
  Future<Image> getImageFromName(String name,
      {double? width, double? height, BoxFit? fit}) {
    return Services.storageService.getPath(name).then((filepath) {
      return File(filepath).exists().then((exists) {
        if (!exists) {
          return _client.storage.from("plants").download(name).then((image) {
            if (image.hasError) {
              print(
                  "$name non trouvé dans le bucket. Utilisation de l'image par défaut. ${image.error}");
              return Image.asset(
                "assets/images/lambdaImage.png",
                width: width,
                height: height,
                fit: fit,
              );
            } else {
              print("$name téléchargée. Ecriture fichier.");
              Services.storageService.writeFile(name, image.data!);
              return Image.memory(
                image.data!,
                width: width,
                height: height,
                fit: fit,
              );
            }
          });
        } else {
          print("$name trouvé dans le stockage. Chargement du fichier.");
          return Image.file(
            File(filepath),
            width: width,
            height: height,
            fit: fit,
          );
        }
      });
    });
  }

  //Charger l'image (PNG) du bucket si elle n'a pas déjà été téléchargée
  Future<Image> getImageFromPngName(String name,
      {double? width, double? height, BoxFit? fit}) {
    return getImageFromName("$name.png",
        width: width, height: height, fit: fit);
  }

  Future<void> setValue(String key, String? value) {
    return _secure_storage.write(key: key, value: value);
  }

  Future<String?> getValue(String key) {
    return _secure_storage.read(key: key);
  }
}
