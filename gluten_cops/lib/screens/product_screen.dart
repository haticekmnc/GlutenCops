import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gluten_cops/form_screens/addproduct_screen.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int selectedButton = 0;
  final Stream<QuerySnapshot> _allProductsStream =
      FirebaseFirestore.instance.collection('products').snapshots();

  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50.0, left: 10.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Ürünler",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ara',
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton('Tümü', 0, Colors.pink),
                _buildButton('Glutenli', 1, Colors.pink),
                _buildButton('Glutensiz', 2, Colors.green),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _allProductsStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Bir şeyler yanlış gitti: ${snapshot.error}');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Yükleniyor");
                  }

                  List<DocumentSnapshot> products = snapshot.data!.docs;
                  List<DocumentSnapshot> filteredProducts =
                      _filterProducts(products);

                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      return _buildProductListTile(filteredProducts[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProduct()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }

  List<DocumentSnapshot> _filterProducts(List<DocumentSnapshot> products) {
    String filter = '';
    if (selectedButton == 1) {
      filter = 'glutenli';
    } else if (selectedButton == 2) {
      filter = 'glutensiz';
    }

    return products.where((product) {
      final productName = product['productName']?.toLowerCase() ?? '';
      final productStatus = product['glutenStatus']?.toLowerCase() ?? '';
      final searchText = _searchController.text.toLowerCase();

      if (_searchController.text.isNotEmpty &&
          !productName.contains(searchText)) {
        return false;
      }

      if (selectedButton != 0 && productStatus != filter) {
        return false;
      }

      return true;
    }).toList();
  }

  Widget _buildProductListTile(DocumentSnapshot product) {
    Map<String, dynamic> productData = product.data() as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 5.0,
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: productData.containsKey('imageUrl') &&
                    productData['imageUrl'] != null
                ? Image.network(
                    productData['imageUrl'],
                    fit: BoxFit.cover,
                    height: 60,
                    width: 60,
                  )
                : const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                    size: 60,
                  ),
          ),
          title: Text(productData['productName']),
          onTap: () {
            _showProductDetailPopup(context, productData);
          },
        ),
      ),
    );
  }

  void _showProductDetailPopup(
      BuildContext context, Map<String, dynamic> productData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(productData['productName'], textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    productData['imageUrl'] ?? '',
                    fit: BoxFit.cover,
                    height: 200.0,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Gluten Durumu: ${productData['glutenStatus'] ?? 'Bilgi yok'}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Kapat', style: TextStyle(color: Colors.pink)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton(String name, int index, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: selectedButton == index ? color : Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      onPressed: () {
        setState(() {
          selectedButton = index;
        });
      },
      child: Text(
        name,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
