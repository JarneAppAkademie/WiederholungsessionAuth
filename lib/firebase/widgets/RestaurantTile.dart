import 'package:firebasetest/firebase/models/Restaurant.dart';
import 'package:flutter/material.dart';

class RestaurantTile extends StatelessWidget {
  const RestaurantTile({super.key, required this.restaurant});
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Row(children: [
        Column(
          children: [
            Text(restaurant.restaurantName),
            Text(restaurant.creationDate.toString()),
          ],
        ),
        SizedBox(width: 15,),
        ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, '/rewiewPage',arguments: restaurant.restaurantId);
        }, child: Text("show Rewiews"))
      ]),
    );
  }
}
