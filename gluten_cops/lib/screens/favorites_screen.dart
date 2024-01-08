import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  final Set<String> favoriteProductIds;

  FavoritesScreen(this.favoriteProductIds);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Set<String> favoriteProductIds;
  List<DocumentSnapshot> favoriteProducts = [];

  @override
  void initState() {
    super.initState();
    favoriteProductIds = widget.favoriteProductIds;
    loadFavoriteProducts();
  }

  void removeFromFavorites(String productId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Favorilerden Çıkar'),
          content:
              const Text('Bu ürünü favorilerden çıkarmak istiyor musunuz?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Evet'),
              onPressed: () {
                favoriteProductIds.remove(productId);
                // Aynı zamanda favori ürünleri yerel olarak kaldırın
                favoriteProducts
                    .removeWhere((product) => product.id == productId);
                Navigator.of(context).pop();
                setState(() {}); // Sayfayı yenilemek için
              },
            ),
            TextButton(
              child: const Text('Hayır'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  // Favori ürünleri Firestore'dan yükleyin
  void loadFavoriteProducts() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('products')
        .where(FieldPath.documentId, whereIn: favoriteProductIds.toList())
        .get();
    setState(() {
      favoriteProducts = querySnapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoriler'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: favoriteProducts.length,
        itemBuilder: (context, index) {
          DocumentSnapshot product = favoriteProducts[index];
          Map<String, dynamic> productData =
              product.data() as Map<String, dynamic>;
          String productId = product.id;
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(productData['productName'] ?? ''),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => removeFromFavorites(productId),
              ),
            ),
          );
        },
      ),
    );
  }
}
