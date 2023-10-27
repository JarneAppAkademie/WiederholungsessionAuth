import 'package:cloud_firestore/cloud_firestore.dart';

class Restaurant{
  final String restaurantId;
  String ownerId;
  String restaurantName;
  final Timestamp creationDate;
  

  Restaurant({required this.ownerId, required this.restaurantName,required this.creationDate, required this.restaurantId});

  factory Restaurant.fromJson(Map<String,dynamic> json, String restaurantId) => 
    Restaurant(
    ownerId: json["ownerId"],
    restaurantName: json["restaurantName"],
    //to parse Timestamp(Datastructure from Firebase) to Datetime
    creationDate:
       json["creationDate"],
       restaurantId: restaurantId
    );
}