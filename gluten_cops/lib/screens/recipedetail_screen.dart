import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String recipeName;
  final String recipeDescription;
  final String recipeImage;

  RecipeDetailScreen({
    required this.recipeName,
    required this.recipeDescription,
    required this.recipeImage,
  });

  Stream<List<DocumentSnapshot>> getRecommendations() {
    // Firestore'dan önerileri getirme işlemi
    return FirebaseFirestore.instance.collection('recipes').snapshots().map(
        (snapshot) => snapshot.docs); // Örnek olarak tüm tarifleri döndürüyor
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          recipeName,
          style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0), // Sayfa çevresine boşluk ekle
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                recipeImage,
                height: 200.0, // Resim yüksekliğini ayarla
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipeName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipeDescription,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Önerilenler',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            StreamBuilder<List<DocumentSnapshot>>(
              stream: getRecommendations(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                return Container(
                  height: 220.0, // Öneri listesi yüksekliği
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            right: 8.0), // Öğeler arasındaki boşluk
                        child: Container(
                          width: 160.0,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Wrap(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15.0)),
                                  child: Image.network(
                                    data['imageUrl'],
                                    height:
                                        140.0, // Önerilen yemek resmi yüksekliği
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                ListTile(
                                  title: Text(data['recipeName']),
                                  onTap: () {
                                    // Tarif detay sayfasına yönlendir
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
