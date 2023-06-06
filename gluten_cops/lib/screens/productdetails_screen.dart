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
        title: const Text('Ürün Detayları'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            data.containsKey('imageUrl') && data['imageUrl'] != null
                ? Image.network(
                    data['imageUrl'],
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
            const SizedBox(height: 20.0),
            data.containsKey('productName') && data['productName'] != null
                ? Text('Ürün Adı: ${data['productName']}')
                : const Text('Ürün adı bilgisi mevcut değil'),
          ],
        ),
      ),
    );
  }
}
