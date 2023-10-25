import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddRestaurantPage extends StatelessWidget {
  const AddRestaurantPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    addRestaurantToFirebase(){
      final user = FirebaseAuth.instance.currentUser;
      try {
      Map<String,dynamic> data = {
            "ownerId" : user != null ? user.uid : throw FormatException("You have to be logged in"),
            "restaurantName": nameController.text.isNotEmpty ? nameController.text :
             throw FormatException("Ein restaurant braucht einen Namen"),
            "creationDate" : Timestamp.now(),
          };

      
        FirebaseFirestore.instance.collection("Restaurants").add(
          data
        );
        
      } catch (e) {
        debugPrint(e.toString());
        
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("restaurant Name"),
          TextField(
            controller: nameController,
          ),
          FirebaseAuth.instance.currentUser != null
              ? ElevatedButton(
                  child: Text("füge restaurant hinzu"),
                  onPressed: () {
                    addRestaurantToFirebase();
                    Navigator.pop(context);
                  },
                )
              : Text("Du musst eingeloggt sein!")
        ],
      ),
    );
  }
}
