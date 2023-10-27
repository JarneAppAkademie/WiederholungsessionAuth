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
            Text(restaurant.creationDate.toDate().toString(),
            style: TextStyle(fontSize: 10),),
          ],
        ),
        SizedBox(width: 15,),
        ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, '/rewiewPage',arguments: restaurant);
        }, child: Text("show Rewiews")),
        ElevatedButton(onPressed: (){
          Navigator.pushNamed(context, '/editRestaurantPage',arguments: restaurant);
        }, child: Text("edit"))
      ]),
    );
  }
}
