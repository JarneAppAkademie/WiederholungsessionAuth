import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoggedInPage extends StatelessWidget {
  const LoggedInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(FirebaseAuth.instance.currentUser?.email ?? "email is null"),
      ),
    );
  }
}