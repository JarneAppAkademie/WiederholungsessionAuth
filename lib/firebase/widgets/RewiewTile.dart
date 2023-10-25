import 'package:firebasetest/firebase/models/Review.dart';
import 'package:flutter/material.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({super.key, required this.review});
  final Review review;
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
            ElevatedButton(onPressed: (){}, child: Text("edit"))
          ]
          ),
          Text(review.description)
        ],
      ),
    );
  }
}