import 'package:firebasetest/firebase/pages/AddRestaurantPage.dart';
import 'package:firebasetest/firebase/pages/AddReviewPage.dart';
import 'package:firebasetest/firebase/pages/RewiewPage.dart';
import 'package:flutter/material.dart';

//Imports for authentication, remember that you need them in your dependencies
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebasetest/firebase_options.dart';

import 'package:firebasetest/firebase/pages/LoggedInPage.dart';
import 'package:firebasetest/auth/EmailVarifikation.dart';
import 'package:firebasetest/auth/PasswordforgottenPage.dart';



import 'auth/LoginWidget.dart';




void main() async{
  //importend for firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/':(context) => _FirebaseTest(),
        '/passwordForgottenPage':(context) => PasswordForgottenPage(),
        '/varifikationPage':(context) => EmailVerifikationPage(),
        '/loggedInPage' :(context) => LoggedInPage(),
        '/rewiewPage':(context) => RewiewPage(),
        '/addRestaurantPage':(context) => AddRestaurantPage(),
        '/addReviewPage':(context) => AddReviewPage(),

      },
      initialRoute: '/loggedInPage',
    );
  }
}



class _FirebaseTest extends StatefulWidget {
  const _FirebaseTest({super.key});

  @override
  State<_FirebaseTest> createState() => __FirebaseTestState();
}

class __FirebaseTestState extends State<_FirebaseTest>{
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Authentikation Wiederholung")),
      
      body: LoginWidget(),
    );
  }
}

