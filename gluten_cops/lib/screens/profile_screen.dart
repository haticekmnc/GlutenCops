import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gluten_cops/screens/locations_screen.dart';
import 'package:gluten_cops/screens/product_screen.dart';
import 'package:gluten_cops/screens/recipes_screen.dart';
import 'package:gluten_cops/screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isButtonPressed = false;
  int selectedButtonIndex = -1;

  User? user = FirebaseAuth
      .instance.currentUser; // Firebase'den kullanıcı bilgilerini al

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Profil',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Ayarlar sayfasına git
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()));
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          CircleAvatar(
            radius: 64,
            backgroundImage: AssetImage(
                'assets/images/splash.jpg'), // Kullanıcının resmi burada kullanılacak
          ),
          const SizedBox(height: 16.0),
          Text(
            user?.displayName ??
                'Kullanıcı Adı Soyadı', // Kullanıcının adı soyadı burada yer alacak
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ??
                'kullanici@mail.com', // Kullanıcının emaili burada yer alacak
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton('Ürünler', 0),
              const SizedBox(width: 16.0),
              _buildButton('Tarifler', 1),
              const SizedBox(width: 16.0),
              _buildButton('Mekanlar', 2),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildButton(String text, int index) {
    bool isSelected = isButtonPressed && index == selectedButtonIndex;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isButtonPressed = true;
          selectedButtonIndex = index;
        });

        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductsScreen()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RecipesPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LocationScreen()),
          );
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          isSelected ? Colors.pink : Colors.white,
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
              color: isSelected ? Colors.pink : Colors.grey,
              width: 1.5,
            ),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.pink,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
