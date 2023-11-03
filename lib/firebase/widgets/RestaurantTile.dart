import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetest/firebase/models/Restaurant.dart';
import 'package:flutter/material.dart';

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({super.key, required this.restaurant});
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {

    Future deleteRestaurantFromFirebase()async{
      try {
        await FirebaseFirestore.instance.collection("Restaurants").doc(restaurant.restaurantId).delete();

        
      } catch (e) {
        print(e.toString());
      }

    }

    return Container(
      color: Colors.amber,
      child: Row(children: [
        Column(
          children: [
            Text(restaurant.restaurantName),
            Text(restaurant.creationDate.toDate().toString(),
            style: TextStyle(fontSize: 8),),
          ],
        ),
        SizedBox(width: 15,),
        ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, '/rewiewPage',arguments: restaurant);
        }, child: Text("show Rewiews")),
        ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, '/editRestaurantPage',arguments: restaurant);
        }, child: Text("edit")),
        IconButton(onPressed: (){
            deleteRestaurantFromFirebase();
        }, icon: Icon(Icons.delete)),
      ]),
    );
  }
}
