import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  String? path;
  final FirebaseStorage _storage;
  final FlutterSecureStorage _secureStorage;

  StorageService(this._storage, this._secureStorage) {}

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
    print("##test " + name);
    return getPath(name).then((filepath) {
      return File(filepath).exists().then((exists) {
        if (!exists) {
          try {
            return _storage
                .ref()
                .child(name)
                .getData(1024 * 1024)
                .then((image) {
              print("$name téléchargée. Ecriture fichier.");
              writeFile(name, image!);
              return Image.memory(
                image,
                width: width,
                height: height,
                fit: fit,
              );
            });
          } on FirebaseException catch (fe) {
            print(
                "$name non trouvé dans le bucket. Utilisation de l'image par défaut. ${fe.code} - ${fe.message}");
            return Image.asset(
              "assets/images/lambdaImage.png",
              width: width,
              height: height,
              fit: fit,
            );
          }
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
    return _secureStorage.write(key: key, value: value);
  }

  Future<String?> getValue(String key) {
    return _secureStorage.read(key: key);
  }
}
