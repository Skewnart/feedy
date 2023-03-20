import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class NoAuthRequiredState<T extends StatefulWidget> extends State<T> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  bool checkLoginForRedirect() {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    _initializeFirebase().then((firebaseApp) {
      if (!checkLoginForRedirect()) {
        FirebaseAuth.instance.authStateChanges().listen((user) {
          checkLoginForRedirect();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
