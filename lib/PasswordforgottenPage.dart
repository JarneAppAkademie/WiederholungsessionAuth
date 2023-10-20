import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordForgottenPage extends StatefulWidget {
  const PasswordForgottenPage({super.key});

  @override
  State<PasswordForgottenPage> createState() => _PasswordForgottenPageState();
}

class _PasswordForgottenPageState extends State<PasswordForgottenPage> {
  TextEditingController emailController = TextEditingController();

Future resetPassword() async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
    Navigator.pop(context);
  }on FirebaseAuthException catch(e){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgotten Password Page")),
      body: Column(
        children: [
          Text("Gebe deine Email ein um das passwort zurück zusetzten"),
          TextFormField(
            controller: emailController,
          ),
          FloatingActionButton(onPressed: (){
            resetPassword();
            
          },
          child: Text("Password zurücksetzten"),)
        ],
      ),
    );
  }
}