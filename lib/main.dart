import 'package:feedy/pages/catalog_viewer.page.dart';
import 'package:feedy/pages/my_plant_viewer.page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:feedy/services/services.dart';
import 'package:feedy/pages/home.page.dart';
import 'package:feedy/pages/login.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

final _messageStreamController = BehaviorSubject<RemoteMessage>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final messaging = FirebaseMessaging.instance;

  //Permission messaging pour IOS/Web
  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  print('Permission granted: ${settings.authorizationStatus}');

  String? token = await messaging.getToken();
  print('Registration Token=$token');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    _messageStreamController.sink.add(message);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Services.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedy',
      theme: ThemeData(
        colorScheme: Services.colorService.scheme,
        textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme)
            .copyWith(
                // headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),

                ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ),
      initialRoute: '/home',
      routes: <String, WidgetBuilder>{
        '/login': (_) => const LoginPage(),
        '/home': (_) => const MyHomePage(),
        '/plant': (_) => const MyPlantViewerPage(),
        '/catalog': (_) => const CatalogViewerPage(),
      },
    );
  }
}
