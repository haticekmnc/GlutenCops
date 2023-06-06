import 'package:flutter/material.dart';

class LocationDetailScreen extends StatelessWidget {
  final int index;

  LocationDetailScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mekan Detayları'),
      ),
      body: Center(
        child: Text('Mekan $index'),
      ),
    );
  }
}
