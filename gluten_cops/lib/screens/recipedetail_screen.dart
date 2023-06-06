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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeName),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network(recipeImage),
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
          ],
        ),
      ),
    );
  }
}
