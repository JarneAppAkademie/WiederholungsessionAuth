import 'package:flutter/material.dart';


class UserFirebase{
  String name;
  String userImage;
  String userId;
  String email;
  

  UserFirebase({required this.name,required this.email,required this.userId,required this.userImage});

  Map<String,dynamic> JsonFromUser(){
    return  {
        'userId': userId,
        'userImage': userImage,
        'name': name,
        'email': email
      };
  }

  factory UserFirebase.fromJson(Map<String,dynamic> json) => 
    UserFirebase(
    name: json["name"],
    userImage: json["userImage"],
    userId:  json["userId"],
    email: json["email"]);
}
