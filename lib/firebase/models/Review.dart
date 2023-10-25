class Review{
  String authorId;
  String description;
  int score;
  String documentId;

  Review({required this.authorId,required this.description,required this.score,required this.documentId});

  factory Review.fromJson(Map<String,dynamic> json,String documentId) => 
    Review(
    authorId: json["authorId"],
    description: json["description"],
    //to parse Timestamp(Datastructure from Firebase) to Datetime
    score:  json["score"],
    documentId: documentId);
}