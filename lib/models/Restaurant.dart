import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant{
  String ownerId;
  String restaurantName;
  DateTime creationDate;

  Restaurant({required this.ownerId, required this.restaurantName,required this.creationDate});

  factory Restaurant.fromJson(Map<String,dynamic> json) => 
    Restaurant(
    ownerId: json["ownerId"],
    restaurantName: json["restaurantName"],
    //to parse Timestamp(Datastructure from Firebase) to Datetime
    creationDate:  DateTime.fromMillisecondsSinceEpoch(
       (json["creationDate"] as Timestamp).seconds *1000)
    );
}