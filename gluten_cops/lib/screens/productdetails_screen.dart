import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final DocumentSnapshot product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = product.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(data.containsKey('productName')
            ? data['productName']
            : 'Ürün Detayları'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            data.containsKey('imageUrl') && data['imageUrl'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(
                        15.0), // Resme yuvarlak köşeler ekleme
                    child: Image.network(
                      data['imageUrl'],
                      fit: BoxFit.cover,
                      height: 250, // Resim yüksekliği
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 100,
                    ),
                  ),
            const SizedBox(
                height: 20.0), // Resim ile metin arasına boşluk ekleme
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ürün Adı: ${data['productName'] ?? 'Bilgi Yok'}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Gluten Durumu: ${data['glutenStatus'] ?? 'Bilgi Yok'}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
