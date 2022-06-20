import '../LoginWelcomeScrenn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePageState(),
  ));
}

class HomePageState extends StatefulWidget {
  @override
  State<HomePageState> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageState> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WelcomeScreen(),
    );
  }
}
