import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScreen extends StatefulWidget {
  @override
  _BarcodeScreenState createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  String _result = '';
  String _productName = '';
  String _glutenStatus = '';
  String _imageUrl = '';

  Future<void> _scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Scanner background color
        'Cancel', // Cancel button text
        true, // Enable scanner flash
        ScanMode.BARCODE, // Barcode scanner mode
      );
      setState(() {
        _result = barcode;
      });

      if (_result != '-1' && _result != 'Scanning canceled') {
        int barcodeNumber = int.parse(_result);

        FirebaseFirestore.instance
            .collection('products')
            .where('barcodeNumber', isEqualTo: barcodeNumber)
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            var doc = querySnapshot.docs.first;
            setState(() {
              _productName = doc['productName'];
              _glutenStatus = doc['glutenStatus'];
              _imageUrl = doc['imageUrl'];
            });
          } else {
            setState(() {
              _result = "Product not found in the database.";
              _productName = '';
              _glutenStatus = '';
              _imageUrl = '';
            });
          }
        });
      }
    } on PlatformException catch (e) {
      if (e.code == '-1') {
        setState(() {
          _result = 'Camera access denied';
          _productName = '';
          _glutenStatus = '';
          _imageUrl = '';
        });
      } else {
        setState(() {
          _result = 'An error occurred: $e';
          _productName = '';
          _glutenStatus = '';
          _imageUrl = '';
        });
      }
    } on FormatException {
      setState(() {
        _result = 'Scanning canceled';
        _productName = '';
        _glutenStatus = '';
        _imageUrl = '';
      });
    } catch (e) {
      setState(() {
        _result = 'An error occurred: $e';
        _productName = '';
        _glutenStatus = '';
        _imageUrl = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Scan Product',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            _result.isEmpty
                ? Expanded(child: Container())
                : Expanded(
                    child: Center(
                      child: _productName.isEmpty
                          ? Text(
                              _result,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  _productName,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  _glutenStatus,
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                                _imageUrl.isNotEmpty
                                    ? Image.network(_imageUrl)
                                    : Container(),
                              ],
                            ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink,
                    onPrimary: Colors.white,
                  ),
                  onPressed: _scanBarcode,
                  child: const Text('Start Scanning'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
