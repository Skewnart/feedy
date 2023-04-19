import 'package:feedy/modules/authentication/no_auth_required_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:feedy/extensions/buildcontext.ext.dart';
import 'package:feedy/services/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends NoAuthRequiredState<LoginPage> {
  bool _isLoading = false;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  Future<User?> signInUsingEmailPassword() async {
    setState(() {
      _isLoading = true;
    });

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      await auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        context.showErrorSnackBar(message: 'Cet email n\'est pas enregistré.');
      } else if (e.code == 'wrong-password') {
        context.showErrorSnackBar(message: 'Mot de passe erroné.');
      } else if (e.code == 'invalid-email') {
        context.showErrorSnackBar(message: 'L\'email est mal formatté.');
      }
    }

    setState(() {
      _isLoading = false;
    });

    return user;
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 50,
                  ),
                  child: FutureBuilder<Image>(
                    future: Services.storageService.getImageFromPngName(
                      "icon",
                      width: MediaQuery.of(context).size.width * 0.5,
                      fit: BoxFit.cover,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return const SizedBox(
                        height: 150,
                        width: 150,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Bienvenue !',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Flexible(
                        child: Text(
                            'Entrez votre adresse email, nous vous enverrons un lien pour vous connecter sans mot de passe !',
                            style: Theme.of(context).textTheme.bodyText2),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Entrez votre adresse email',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFF1F4F8),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFF1F4F8),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Entrez votre mot de passe',
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFF1F4F8),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFF1F4F8),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: _initializeFirebase(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        children: const [
                          Text('Login firebase done'),
                        ],
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : signInUsingEmailPassword,
                  child: Text(_isLoading ? 'Chargement...' : 'Envoyer le lien'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
