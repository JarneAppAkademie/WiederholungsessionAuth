import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

  Future resetPassword()async{
    try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Resset email send')));
    }on FirebaseAuthException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Tippe die Email ein, von der du das passwort vergessen hast"),
          TextFormField(
            controller: emailController,
            
          ),
          ElevatedButton(
            onPressed: (){
              resetPassword();
            }
          , child: Text("Reset password")
          )
        ],
      ),
    );
  }
}