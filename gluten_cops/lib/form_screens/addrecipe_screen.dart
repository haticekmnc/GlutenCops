import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({Key? key}) : super(key: key);

  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _materialsController = TextEditingController();
  final TextEditingController _recipeDescriptionController =
      TextEditingController();

  File? _image;
  bool _isUploading = false;

  Future<String> uploadImageToFirebase(BuildContext context) async {
    String fileName = _image!.path;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('recipes/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> onSavePressed() async {
    if (_image != null) {
      setState(() {
        _isUploading = true;
      });
      try {
        String imageUrl = await uploadImageToFirebase(context);
        await FirebaseFirestore.instance.collection('recipes').add({
          'imageUrl': imageUrl,
          'recipeName': _recipeNameController.text,
          'materials': _materialsController.text,
          'recipeDescription': _recipeDescriptionController.text,
        });
        if (mounted) {
          setState(() {
            _isUploading = false;
            _recipeNameController.clear();
            _materialsController.clear();
            _recipeDescriptionController.clear();
            _image = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tarif başarıyla kaydedildi.')));
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Tarif kaydedilemedi.')));
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Resim yüklenmelidir.')));
    }
  }

  void onCancelPressed() {
    _recipeNameController.clear();
    _materialsController.clear();
    _recipeDescriptionController.clear();
    setState(() {
      _image = null;
    });
  }

  Future<void> _openCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  Future<void> _openGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (image != null) {
        _image = File(image.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                    'Yemek Tarifi Ekle',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Resim Seç'),
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
              Flexible(
                fit: FlexFit.loose,
                child: TextFormField(
                  controller: _recipeNameController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Yemek Adı',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Flexible(
                fit: FlexFit.loose,
                child: TextFormField(
                  controller: _materialsController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Malzemeler',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Flexible(
                fit: FlexFit.loose,
                child: TextFormField(
                  controller: _recipeDescriptionController,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: 'Yapılışı',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              _isUploading
                  ? Center(child: CircularProgressIndicator())
                  : Row(
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
                          onTap: onCancelPressed,
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
                              'Vazgeç',
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
    );
  }
}
