import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScreen extends StatefulWidget {
  @override
  _BarcodeScreenState createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  String _result = '';

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
    } on PlatformException catch (e) {
      if (e.code == '-1') {
        setState(() {
          _result = 'Kamera erişimi reddedildi';
        });
      } else {
        setState(() {
          _result = 'Bir hata oluştu: $e';
        });
      }
    } on FormatException {
      setState(() {
        _result = 'Tarama iptal edildi';
      });
    } catch (e) {
      setState(() {
        _result = 'Bir hata oluştu: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürünü Tarayınız'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            _result,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.pink,
              onPrimary: Colors.white,
            ),
            onPressed: _scanBarcode,
            child: Text('Taramayı Başlat'),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.pink,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Tarifler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Barkod Okuma',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Haritalar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Hesaplar',
          ),
        ],
        // onTap: _onItemTapped,
      ),
    );
  }
}
