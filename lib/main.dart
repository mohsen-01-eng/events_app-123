import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:new_events_app/screens/home_screen.dart';
import 'package:new_events_app/screens/login_screen.dart';
import 'package:new_events_app/screens/signup_screen.dart';

import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event App',
      theme: ThemeData(primarySwatch: Colors.purple),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/signup': (context) =>SignupScreen(),
        '/login': (context) =>LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
