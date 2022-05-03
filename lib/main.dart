import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedy/pages/old/account_page.dart';
import 'package:feedy/pages/home.page.dart';
import 'package:feedy/pages/login.page.dart';
import 'package:feedy/pages/splash.page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://dkakpeueinbiwnsrzyxm.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRrYWtwZXVlaW5iaXduc3J6eXhtIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NDkyNTkyMDAsImV4cCI6MTk2NDgzNTIwMH0.FpVjbCgGgatvgRwrw5CIcxeunUoxAaALvHF6kuuYon8',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      ///////////////////////////################################
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ///////////////////////////################################
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (_) => const SplashPage(),
        '/login': (_) => const LoginPage(),
        '/account': (_) => const AccountPage(),
        '/home': (_) => const MyHomePage(),
      },
    );
  }
}
