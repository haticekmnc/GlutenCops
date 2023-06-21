import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final DocumentSnapshot product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = product.data() as Map<String, dynamic>;

    print('Product Details Data: $data');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Ürün Detayları'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                ? Text(
                    'Ürün Adı: ${data['productName']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : const Text('Ürün adı bilgisi mevcut değil'),
            data.containsKey('glutenStatus') && data['glutenStatus'] != null
                ? Text(
                    'Gluten Durumu: ${data['glutenStatus']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : const Text('Gluten durumu bilgisi mevcut değil'),
          ],
        ),
      ),
    );
  }
}
