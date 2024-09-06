import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hoopfinder/authentication/login.dart';
import 'package:hoopfinder/main.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    if (_user == null)
      return LoginPage();
    else
      return HomePage();
  }
}
