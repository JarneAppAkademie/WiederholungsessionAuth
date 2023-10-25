import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebasetest/firebase/widgets/RestaurantTile.dart';
import 'package:firebasetest/firebase/models/Restaurant.dart';
import 'package:flutter/material.dart';

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({super.key});

  @override
  State<LoggedInPage> createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {


  Future<List<Restaurant>> fetchResterauntsFromFirebase() async {
    try {
      QuerySnapshot restaurantCollection =
          await FirebaseFirestore.instance.collection("Restaurants").get();



      List<Restaurant> restaurants = restaurantCollection.docs
          .map((doc) {
            //debugPrint("RestaurantId: " + doc.id);
           return Restaurant.fromJson(
            (doc.data() as Map<String, dynamic>),doc.id
            );
          }).toList(); 
          
      print(restaurants.toString());

      

      return restaurants;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }
  // returns a Stream of Restaurants, this allows us to see the chages of firebase directly
  // With the Future we would have had to restart the widget to refresh the data
  Stream<List<Restaurant>> fetchResterauntStreamFromFirebase() {

    Stream<QuerySnapshot> restaurantCollectionStream =
        FirebaseFirestore.instance.collection("Restaurants").snapshots();

    Stream<List<Restaurant>> restaurants =
        restaurantCollectionStream.map((QuerySnapshot snapshot) {
      return snapshot.docs
          .map((doc) => Restaurant.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });

    print(restaurants);

    return restaurants;
  }

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(FirebaseAuth.instance.currentUser?.email ?? "email is null"),
      ),
      body: Column(
        children: [
          FutureBuilder(
              future: fetchResterauntsFromFirebase(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Restaurant> restaurantList = snapshot.data ?? [];
                  return Expanded(
                    child: ListView(
                      children: restaurantList
                          .map((rest) => RestaurantTile(restaurant: rest))
                          .toList(),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
          StreamBuilder(
            stream: fetchResterauntStreamFromFirebase(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                List<Restaurant> restaurantList = snapshot.data ?? [];
                return Expanded(
                  child: ListView(
                    children: restaurantList
                        .map((rest) => RestaurantTile(restaurant: rest))
                        .toList(),
                  ),
                );
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushNamed(context, "/addRestaurantPage");
      },
      child: Text("new Restaurant"),),
    );
  }
}
