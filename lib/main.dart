import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:news/pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news/pages/wholeNews.dart';
import 'spash_screen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}