import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final FirebaseFirestore _firestore;

  DatabaseService(this._firestore);

  Future<List<Map<String, dynamic>>> getTableContentWithUser(
      String tableName) async {
    if (FirebaseAuth.instance.currentUser == null) return [];

    return _firestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection(tableName)
        .get()
        .then((event) {
      return event.docs.map((doc) {
        final map = doc.data();
        map["id"] = doc.id;
        return map;
      }).toList();
    });
  }

  Future<List<Map<String, dynamic>>> getTableContent(String tableName) async {
    return _firestore.collection(tableName).get().then((event) {
      return event.docs.map((doc) {
        final map = doc.data();
        map["id"] = doc.id;
        return map;
      }).toList();
    });
  }

  Future<DatabaseMessage> setDataWithUser(
      String tableName, String id, Map<String, dynamic> content) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return DatabaseMessage(true, "User non connecté", '');
    }
    DatabaseMessage? toreturn;
    if (id == "-1") {
      await _firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection(tableName)
          .add(content)
          .then((snapshot) {
        id = snapshot.id;
      }).onError((e, _) {
        toreturn = DatabaseMessage(true, "Erreur dans la sauvegarde : $e", '');
      });
    } else {
      await _firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection(tableName)
          .doc(id)
          .set(content)
          .onError((e, _) {
        toreturn = DatabaseMessage(true, "Erreur dans la sauvegarde : $e", '');
      });
    }
    toreturn ??= DatabaseMessage(false, '', id);
    return toreturn!;
  }

  Future<DatabaseMessage> deleteDataWithUser(
      String tableName, String id) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return DatabaseMessage(true, "User non connecté", '');
    }
    DatabaseMessage? toreturn;
    
    await _firestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection(tableName)
          .doc(id)
          .delete()
          .onError((e, _) {
        toreturn = DatabaseMessage(true, "Erreur dans la sauvegarde : $e", '');
      });
    
    toreturn ??= DatabaseMessage(false, '', id);
    return toreturn!;
  }
}

class DatabaseMessage {
  final bool hasError;
  final String errorMessage;
  final dynamic infos;

  DatabaseMessage(this.hasError, this.errorMessage, this.infos);
}
