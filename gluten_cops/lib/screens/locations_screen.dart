import 'package:flutter/material.dart';
import 'package:gluten_cops/form_screens/addlocation_screen.dart';
import 'package:gluten_cops/screens/locationdetail_screen.dart';
import 'package:gluten_cops/screens/profile_screen.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int selectedButton = 0;

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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => const ProfileScreen())));
                    },
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Mekanlar",
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
                _buildButton('İkiside', 1, Colors.pink),
                _buildButton('Glutenli', 2, Colors.pink),
                _buildButton('Glutensiz', 3, Colors.green),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(10, (index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LocationDetailScreen(index: index)),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: (index % 2 == 0) ? Colors.red : Colors.green,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: Image.network(
                        'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.pink, // background
                onPrimary: Colors.white, // foreground
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => const AddLocation())));
              },
              child: const Text("Mekan Ekle"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String title, int index, Color color) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedButton = index;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          color: selectedButton == index ? Colors.white : color,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        backgroundColor: selectedButton == index ? color : Colors.white,
      ),
    );
  }
}
