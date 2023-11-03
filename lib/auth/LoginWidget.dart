import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetest/firebase/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      //print(image.toString());
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<String> uploadUserImageToStorage(File imageFile, String userId)async{
    try {
      Reference storageReference = FirebaseStorage.instance.ref().child("userProfiles/$userId/userImage");
      TaskSnapshot uploadTask = await storageReference.putFile(imageFile);

      String downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
      
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  Future createUserDocument()async{
    try {

      String imagePath =  await uploadUserImageToStorage(image!, FirebaseAuth.instance.currentUser!.uid);

      UserFirebase user = UserFirebase(
        userId: FirebaseAuth.instance.currentUser!.uid,
        userImage: imagePath,
        name: nameController.text,
        email: emailController.text
        );
      Map<String,dynamic> data = {
        'userId': user.userId,
        'userImage': user.userImage,
        'name': user.name,
        'email': user.email
      };
    //hier würde auch data gehen
      await FirebaseFirestore.instance.collection("Users").doc(user.userId).set(user.JsonFromUser());
      
    } catch (e) {
      print(e.toString());
    }
  }


  Future signUpWithEmail() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  


  
  

  Future signInWithEmail() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  // sign in method for google sign in
  // Important!! for this to work you need to register the sha1 key in firebase
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        image != null ? Container(width: 100,child: Image.file(image!)) : Text("Noch kein Bild ausgewählt"),
        ElevatedButton(onPressed: (){
          pickImage();
        }, child: Text("pick image")),
        Text("Name"),
        TextFormField(
          controller: nameController,
        ),
        Text("Email"),
        TextFormField(
          controller: emailController,
        ),
        Text("Passwort"),
        TextFormField(
          controller: passwordController,
        ),
        ElevatedButton(
            child: Text("Signup"),
            onPressed: () async{
              await signUpWithEmail();
              // check again if user is realyy logged in, this should be allready be catched through an error in the signup function
              if (FirebaseAuth.instance.currentUser != null) {
                await createUserDocument();
                print("registriert");
                Navigator.pushNamed(context, '/varifikationPage');
              }
            }),
        ElevatedButton(
            child: Text("Signin"),
            onPressed: () {
              signInWithEmail();
              if (FirebaseAuth.instance.currentUser != null) {
                print("eingeloggt");
                if (!FirebaseAuth.instance.currentUser!.emailVerified) {
                  Navigator.pushNamed(context, '/varifikationPage');
                } else {
                  Navigator.pushNamed(context, '/loggedInPage');
                }
              }
            }),
        ElevatedButton(
            child: Text("Password forgotten"),
            onPressed: () {
              Navigator.pushNamed(context, '/passwordForgottenPage');
            }),
        ElevatedButton(
            child: Text("Google Signin"),
            onPressed: () async {
              await signInWithGoogle();
              if (FirebaseAuth.instance.currentUser != null) {
                print("mit google eingelogt");
                Navigator.pushNamed(context, '/loggedInPage');
              }
            }),
        ElevatedButton(
            child: Text("Logout"),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            }),
        ElevatedButton(
            child: Text("go to next Page witout signin"),
            onPressed: () {
              Navigator.pushNamed(context, '/loggedInPage');
            }),
      ],
    );
  }
}
