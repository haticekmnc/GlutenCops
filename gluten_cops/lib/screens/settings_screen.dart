import 'package:flutter/material.dart';
import 'package:gluten_cops/screens/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayarlar"),
        backgroundColor: Colors.pink,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.pink),
              title: const Text('Profil Düzenle'),
              onTap: () {
                // Profil düzenleme sayfasına yönlendir
              },
            ),
          ),
          Card(
            child: SwitchListTile(
              title: const Text('Bildirimler'),
              subtitle: const Text('Bildirim ayarları'),
              value: true, // Bu değer uygulamanın ayarlarına bağlı olmalı
              onChanged: (bool value) {
                // Bildirim ayarını güncelle
              },
              secondary: const Icon(Icons.notifications, color: Colors.pink),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info, color: Colors.pink),
              title: const Text('Hakkında'),
              onTap: () {
                // Uygulama hakkında bilgi göster
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.pink),
              title: const Text('Çıkış Yap'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => LoginScreen())));
              },
            ),
          ),
        ],
      ),
    );
  }
}
