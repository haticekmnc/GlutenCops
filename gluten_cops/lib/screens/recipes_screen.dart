import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gluten_cops/form_screens/addrecipe_screen.dart';
import 'package:gluten_cops/screens/recipedetail_screen.dart';

class RecipesPage extends StatelessWidget {
  RecipesPage({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Stream<QuerySnapshot> _recipesStream =
      FirebaseFirestore.instance.collection('recipes').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Text(
            'Yemek Tarifleri',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popüler Ürünler',
                    style: TextStyle(
                      color: Colors.pink,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Here you can navigate to see all popular recipes
                    },
                    child: const Text(
                      'Hepsini Gör',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _recipesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>;
                    return ListTile(
                      leading: (data['imageUrl'] != null &&
                              data['imageUrl'] is String)
                          ? Image.network(data['imageUrl'])
                          : Container(),
                      title: Text(data['recipeName'] ?? 'Unnamed Recipe'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(
                              recipeName: data['recipeName'],
                              recipeDescription: data['recipeDescription'],
                              recipeImage: data['imageUrl'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddRecipe()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
