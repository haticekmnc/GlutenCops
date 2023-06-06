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
  String _productInfo = '';

  Future<void> _scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Tarayıcı arka plan rengi
        'İptal', // İptal butonunun metni
        true, // Barkod tarayıcısının flaşını etkinleştirme
        ScanMode.BARCODE, // Barkod tarayıcı modu
      );
      setState(() {
        _result = barcode;
      });

      // Barkod tarama başarılı olursa, ürünü Firestore'dan al
      if (_result != '-1' && _result != 'Tarama iptal edildi') {
        FirebaseFirestore.instance
            .collection('products')
            .where('barcodeNumber', isEqualTo: _result)
            .get()
            .then((QuerySnapshot querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            var doc = querySnapshot.docs.first;
            _productInfo = "Product Name: ${doc['productName']}\n"
                "Product Brand: ${doc['productBrand']}\n"
                "Barcode Number: ${doc['barcodeNumber']}\n"
                "Gluten Status: ${doc['glutenStatus']}\n"
                "Image Url: ${doc['imageUrl']}";
            setState(() {});
          } else {
            print("No product found with this barcode.");
          }
        });
      }
    } on PlatformException catch (e) {
      if (e.code == '-1') {
        setState(() {
          _result = 'Kamera erişimi reddedildi';
          _productInfo = '';
        });
      } else {
        setState(() {
          _result = 'Bir hata oluştu: $e';
          _productInfo = '';
        });
      }
    } on FormatException {
      setState(() {
        _result = 'Tarama iptal edildi';
        _productInfo = '';
      });
    } catch (e) {
      setState(() {
        _result = 'Bir hata oluştu: $e';
        _productInfo = '';
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
                'Ürünü Tarayınız',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            _result.isEmpty
                ? Expanded(child: Container())
                : Expanded(
                    child: Center(
                      child: Text(
                        _productInfo.isEmpty ? _result : _productInfo,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
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
                  child: const Text('Taramayı Başlat'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
