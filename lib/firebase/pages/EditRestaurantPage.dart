import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasetest/firebase/models/Restaurant.dart';
import 'package:flutter/material.dart';

class EditRestaurantPage extends StatelessWidget {
  const EditRestaurantPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    Restaurant restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
    nameController.text = restaurant.restaurantName;

    updateRestaurantToFirebase(){
      final user = FirebaseAuth.instance.currentUser;
      try {
      Map<String,dynamic> data = {
            "ownerId" : user != null ? user.uid : throw FormatException("You have to be logged in"),
            "restaurantName": nameController.text.isNotEmpty ? nameController.text :
             throw FormatException("Ein restaurant braucht einen Namen"),
            "creationDate" : restaurant.creationDate,
          };

      
        FirebaseFirestore.instance.collection("Restaurants").doc(restaurant.restaurantId).update(data);
        
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
                  child: Text("update restaurant"),
                  onPressed: () {
                    updateRestaurantToFirebase();
                    Navigator.pop(context);
                  },
                )
              : Text("Du musst eingeloggt sein!")
        ],
      ),
    );
  }
}
