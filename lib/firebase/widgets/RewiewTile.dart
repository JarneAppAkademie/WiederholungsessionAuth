import 'package:firebasetest/firebase/models/Restaurant.dart';
import 'package:firebasetest/firebase/models/Review.dart';
import 'package:flutter/material.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.review, required this.restaurant});
  final Review review;
  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 80,
      color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
            Text(review.score.toString()),
            ElevatedButton(onPressed: (){
              Navigator.pushNamed(context, '/editReviewPage',arguments: [review,restaurant]);
            }, child: Text("edit"))
          ]
          ),
          Text(review.description)
        ],
      ),
    );
  }
}