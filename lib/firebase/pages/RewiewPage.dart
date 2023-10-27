
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetest/firebase/widgets/RewiewTile.dart';
import 'package:firebasetest/firebase/models/Restaurant.dart';
import 'package:flutter/material.dart';

import '../models/Review.dart';

class RewiewPage extends StatelessWidget {
  
  RewiewPage({super.key});

  Future<List<Review>> fetchReviewsFromFirebase(String restaurantId) async {
    try {
      QuerySnapshot reviewCollection =
          await FirebaseFirestore.instance.collection("Restaurants").
          doc(restaurantId).collection("reviews").get();

      List<Review> reviews = reviewCollection.docs
          .map((doc) {
            //debugPrint("RestaurantId: " + doc.id);
           return Review.fromJson(
            (doc.data() as Map<String, dynamic>),doc.id
            );
          }).toList(); 
          
      print(reviews.toString());

      return reviews;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
  Stream<List<Review>> fetchReviewStreamFromFirebase(String restaurantId) {

    Stream<QuerySnapshot> reviewCollectionStream =
        FirebaseFirestore.instance.collection("Restaurants")
        .doc(restaurantId).collection("reviews").snapshots();

    Stream<List<Review>> reviews =
        reviewCollectionStream.map((QuerySnapshot snapshot) {
      return snapshot.docs
          .map((doc) => Review.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });

    print(reviews);

    return reviews;
  }

  

  @override
  Widget build(BuildContext context) {

    Restaurant restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;
    
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
          future: fetchReviewsFromFirebase(restaurant.restaurantId),
           builder:(context, snapshot) {
            if(snapshot.hasData){
              List<Review> reviewList = snapshot.data ?? [];
              return Expanded(
                child: ListView(
                  children: reviewList.map((review) => ReviewTile(review: review,restaurant: restaurant,)).toList(),
                ),
              );  
            }else{
              return CircularProgressIndicator();
            }
          },),
          StreamBuilder(stream: fetchReviewStreamFromFirebase(restaurant.restaurantId),
           builder:(context, snapshot) {
             if(snapshot.hasData){
              List<Review> reviewList = snapshot.data ?? [];
              return Expanded(
                child: ListView(
                  children: reviewList.map((review) => ReviewTile(review: review, restaurant: restaurant)).toList(),
                ),
              );  
            }else{
              return CircularProgressIndicator();
            }
           },)
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, '/addReviewPage',arguments: restaurant);
      },
      child: Text("new review"),),
    );
  }
}