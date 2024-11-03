import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  // ignore: unused_field
  String _confirmPassword = '';

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        Navigator.pushNamed(context, '/home');
      } catch (e) {
        print(e);  // التعامل مع الخطأ
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء حساب')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'البريد الإلكتروني'),
              onChanged: (value) => _email = value,
              validator: (value) =>
                  value!.isEmpty ? 'يرجى إدخال بريد إلكتروني' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'كلمة المرور'),
              onChanged: (value) => _password = value,
              obscureText: true,
              validator: (value) =>
                  value!.length < 6 ? 'يجب أن تكون كلمة المرور 6 أحرف أو أكثر' : null,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'تأكيد كلمة المرور'),
              onChanged: (value) => _confirmPassword = value,
              obscureText: true,
              validator: (value) => value != _password
                  ? 'كلمة المرور غير متطابقة'
                  : null,
            ),
            ElevatedButton(
              onPressed: _signup,
              child: const Text('إنشاء الحساب'),
            ),
          ],
        ),
      ),
    );
  }
}
