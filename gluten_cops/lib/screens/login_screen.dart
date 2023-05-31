import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gluten_cops/screens/homepage_screen.dart';
import 'package:gluten_cops/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signInWithEmailAndPassword(BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // User successfully signed in.
      // For instance, you could push to a new screen here.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'kullanıcı bulunamadı') {
        message = 'Bu e-posta için kullanıcı bulunamadı.';
      } else if (e.code == 'yanlış şifre') {
        message = 'Kullanıcı için sağlanan yanlış şifre.';
      } else {
        message =
            'Bir şeyler yanlış gitti. Lütfen daha sonra tekrar deneyiniz.';
      }

      final snackBar = SnackBar(content: Text(message));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "GLUTEN",
                      style: TextStyle(
                        color: Colors.pink,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "COPS",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                _buildTextField(_emailController, "Email", false),
                const SizedBox(height: 10),
                _buildTextField(_passwordController, "Şifre", true),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Center(
                    child: Text(
                      "Şifreni mi unuttun?",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.pink, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () {
                    _signInWithEmailAndPassword(context);
                  },
                  child: const Text("GİRİŞ YAP"),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.black)),
                    Text("veya"),
                    Expanded(child: Divider(color: Colors.black)),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterScreen(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hesabın yok mu? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        "Kayıt ol.",
                        style: TextStyle(color: Colors.pink),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextField _buildTextField(
      TextEditingController controller, String labelText, bool isPassword) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        fillColor: Colors.grey.shade200,
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(4),
          ),
        ),
      ),
    );
  }
}
