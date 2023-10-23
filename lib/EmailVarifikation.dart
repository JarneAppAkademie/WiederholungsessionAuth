import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerifikationPage extends StatefulWidget {
  const EmailVerifikationPage({super.key});

  @override
  State<EmailVerifikationPage> createState() => _EmailVerifikationState();
}

class _EmailVerifikationState extends State<EmailVerifikationPage> {
  //status if the email is varified
  bool isEmailVarified = false;
  //The timer that checks repeatetly if the email was verified
  Timer? timer;

  @override
  void initState() {
    
    isEmailVarified = FirebaseAuth.instance.currentUser!.emailVerified;
    

    if(!isEmailVarified){
      //we send the mail one time at the beginning
      sendVerifikationMail();
      //calls the checkIfEmailVarified() Funktion every 3 seconds till canceled
      timer = Timer.periodic(Duration(seconds: 3), (timer) { 
        checkIfEmailVarified();
      });
    }

    super.initState();
  }
  @override
  void dispose() {
    //stops the timer
    timer!.cancel();
    super.dispose();
  }

  Future checkIfEmailVarified()async{
    //we reload the current user to get possible new information like the emailVerified status
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVarified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVarified){
      timer?.cancel();
      // push the next page if the email was verified
      Navigator.pushNamed(context, '/loggedInPage');
    }

  }

  Future sendVerifikationMail() async{
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
    
  }on FirebaseAuthException catch(e){
    // show errormessage as snackbar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message!)));
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("VarifikationScreen")),
      // to allow the posiblility to resends the email if the varifikation link is no longer working
      body: ElevatedButton(child: Text("resend Varifikation mail"), onPressed: () {
        sendVerifikationMail();
        
      },),
    );
  }
}