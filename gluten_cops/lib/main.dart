import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gluten_cops/screens/barcode_screen.dart';
import 'package:gluten_cops/screens/map_screen.dart';
import 'package:gluten_cops/screens/profile_screen.dart';
import 'package:gluten_cops/screens/recipes_screen.dart';
import 'package:gluten_cops/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/recipes': (context) => RecipesPage(),
        '/barcode': (context) => BarcodeScreen(),
        '/map': (context) => const MapScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
