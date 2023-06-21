import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gluten_cops/form_screens/addproduct_screen.dart';
import 'package:gluten_cops/screens/productdetails_screen.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int selectedButton = 0;
  final Stream<QuerySnapshot> _allProductsStream =
      FirebaseFirestore.instance.collection('products').snapshots();

  @override
  Widget build(BuildContext context) {
    print('Selected Button: $selectedButton');

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
            const TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
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
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading");
                  }

                  final products = snapshot.data!.docs;
                  final filteredProducts = products.where((p) {
                    final glutenStatus = p['glutenStatus'];
                    if (selectedButton == 0) {
                      return true;
                    } else if (selectedButton == 1) {
                      return glutenStatus == 'glutenli';
                    } else {
                      return glutenStatus == 'glutensiz';
                    }
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> productData = filteredProducts[index]
                          .data() as Map<String, dynamic>;

                      return Card(
                        child: ListTile(
                          leading: productData.containsKey('imageUrl') &&
                                  productData['imageUrl'] != null
                              ? Image.network(
                                  productData['imageUrl'],
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                )
                              : const Icon(
                                  Icons.image_not_supported,
                                  color: Colors.grey,
                                ),
                          title: Text(productData['productName']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailsScreen(
                                  product: filteredProducts[index],
                                ),
                              ),
                            );
                          },
                        ),
                      );
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

  Widget _buildButton(String name, int index, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: (selectedButton == index) ? color : Colors.grey),
      onPressed: () {
        setState(() {
          selectedButton = index;
        });
      },
      child: Text(
        name,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
