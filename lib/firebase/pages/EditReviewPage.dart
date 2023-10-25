import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditReviewPage extends StatelessWidget {
  const EditReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? restaurantId = ModalRoute.of(context)!.settings.arguments as String?;
    print("restaurantid: $restaurantId");
    TextEditingController descriptionController = TextEditingController();
    TextEditingController scoreController = TextEditingController();

    addRestaurantToFirebase(){
      final user = FirebaseAuth.instance.currentUser;
      try {
      Map<String,dynamic> data = {
            "authorId" : user != null ? user.uid : throw FormatException("You have to be logged in"),
            "description": descriptionController.text.isNotEmpty ? descriptionController.text : throw FormatException("Die description darf niocht leer sein"),
            "score" : int.parse(scoreController.text) <= 5 && int.parse(scoreController.text) >= 1 
            ? int.parse(scoreController.text) : throw FormatException("Score sollte zahl zwischen 1 und 5 sein"),
          };

          print(data);

      
        FirebaseFirestore.instance.collection("Restaurants").doc(restaurantId).collection("reviews").add(
          data
        );

        Navigator.pop(context);
        
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("description"),
          TextField(
            controller: descriptionController,
          ),
          Text("score"),
          TextField(
            controller: scoreController,
          ),
          FirebaseAuth.instance.currentUser != null
              ? ElevatedButton(
                  child: Text("füge review hinzu"),
                  onPressed: () {
                    addRestaurantToFirebase();
                    
                  },
                )
              : Text("Du musst eingeloggt sein!")
        ],
      ),
    );
  }
}
