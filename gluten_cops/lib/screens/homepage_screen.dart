import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _productsStream =
      FirebaseFirestore.instance.collection('products').snapshots();
  final Stream<QuerySnapshot> _foodsStream =
      FirebaseFirestore.instance.collection('foods').snapshots();
  final Stream<QuerySnapshot> _venuesStream =
      FirebaseFirestore.instance.collection('venues').snapshots();

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(33.0),
              child: Text(
                'Hoşgeldin, ${user?.displayName ?? 'Kullanıcı'}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Arama",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                ),
              ),
            ),
            _buildCategory('Popüler Ürünler', _productsStream),
            _buildCategory('Popüler Yemekler', _foodsStream),
            _buildCategory('Popüler Mekanlar', _venuesStream),
          ],
        ),
      ),
    );
  }

  Widget _buildCategory(String title, Stream<QuerySnapshot> stream) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink),
              ),
              GestureDetector(
                onTap: () {
                  print('Hepsini gör tıklandı');
                },
                child: const Text(
                  'Hepsini Gör',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return SizedBox(
                      width:
                          160.0, // Bu değeri uygulamanızın tasarımına göre ayarlayabilirsiniz.
                      child: ListTile(
                        title: Text(data['name'] ?? 'No name'),
                        subtitle: Text(data['description'] ?? 'No description'),
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
