import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'Glutenli';
  File? _image;
  String? _imageUrl;
  String productName = '';
  String productBrand = '';
  String barcodeNumber = '';

  void onSavePressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      if (_imageUrl == null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Resim yok'),
            content: const Text('Lütfen bir resim ekleyin.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      } else {
        firestore.collection('products').add({
          'productName': productName,
          'productBrand': productBrand,
          'barcodeNumber': barcodeNumber,
          'glutenStatus': dropdownValue,
          'imageUrl': _imageUrl,
        });

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Kaydedildi'),
            content: const Text('Ürün başarıyla kaydedildi.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Tamam'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<String> uploadImageToFirebase(File imageFile) async {
    String fileName = Path.basename(imageFile.path);
    Reference storageReference =
        FirebaseStorage.instance.ref().child('images/$fileName');
    UploadTask uploadTask = storageReference.putFile(imageFile);

    await uploadTask;
    String imageUrl = await storageReference.getDownloadURL();

    return imageUrl;
  }

  Future<void> _uploadImage(File imageFile) async {
    try {
      String imageUrl = await uploadImageToFirebase(imageFile);
      setState(() {
        _imageUrl = imageUrl;
      });
      print('Resim başarıyla yüklendi. URL: $_imageUrl');
    } catch (error) {
      print('Resim yüklenemedi: $error');
    }
  }

  Future<void> _openCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      final imageFile = File(image.path);
      _uploadImage(imageFile);
      setState(() {
        _image = imageFile;
      });
    }
  }

  Future<void> _openGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      final imageFile = File(image.path);
      _uploadImage(imageFile);
      setState(() {
        _image = imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48.0),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back),
                    ),
                    const SizedBox(width: 8.0),
                    const Text(
                      'Ürün Ekle',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Resim seç'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              GestureDetector(
                                child: const Text('Kamera'),
                                onTap: () {
                                  _openCamera();
                                  Navigator.of(context).pop();
                                },
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                child: const Text('Galeri'),
                                onTap: () {
                                  _openGallery();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: _image != null
                          ? Image.file(_image!, fit: BoxFit.cover)
                          : const Icon(
                              Icons.camera_alt,
                              size: 96,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Ürün adı',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen ürün adı giriniz.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    productName = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Marka',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir marka giriniz.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    productBrand = value!;
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>['Glutenli', 'Glutensiz']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Gluten Durumu',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Barcode No',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lütfen bir barkod numarası giriniz.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    barcodeNumber = value!;
                  },
                ),
                const SizedBox(height: 50.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: onSavePressed,
                      child: Container(
                        width: 100,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Kaydet',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 100,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.pink),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Kapat',
                          style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
