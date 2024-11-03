import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String _email = '';
  String _password = '';

  void _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      print(e);  // التعامل مع الخطأ
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
            onChanged: (value) => _email = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'كلمة المرور'),
            onChanged: (value) => _password = value,
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: _login,
            child: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    );
  }
}
