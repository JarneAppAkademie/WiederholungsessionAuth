# Wiederholungssession Auth und firebase

Hier die ersten Regeln die wir heute erstellt haben.
Denkt dran das die Namen vielleicht bei euch anders sind(atribute und collections)

rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
		match /Restaurants/{restaurantId}{
    	allow read: if request.auth.uid != null;
      allow create: if request.auth.uid != null;
      allow update: if request.auth.uid == resource.data.ownerId &&
      									request.resource.data.creationDate == resource.data.creationDate &&
                        request.resource.data.restaurantName is string &&
                        request.resource.data.restaurantName.size() >= 3 &&
                        request.resource.data.restaurantName.size() <= 50;
      allow delete: if request.auth.uid != null && request.auth.uid == resource.data.ownerId;
                        
    	match /reviews/{reviewId}{
      	allow read: if request.auth.uid != null;
      	allow create: if request.auth.uid != null && request.resource.data.score >= 1 &&
        								request.resource.data.score <= 5 &&
                        request.resource.data.score is number;
        allow update: if request.auth.uid != null && request.auth.uid == resource.data.authorId && request.resource.data.score >= 1 &&
        								request.resource.data.score <= 5 &&
                        request.resource.data.score is number;
         allow delete: if request.auth.uid != null && request.auth.uid == resource.data.authorId
         									|| get(/databases/$(database)/documents/Restaurants/$(restaurantId)).data.ownerId == request.auth.uid||
                          get(/databases/$(database)/documents/Users/$(request.auth.uid)).data.admin == true;
                          
      }
                        
                        
    }
    match /Users/{userId}{
    	allow read: if true;
      allow write: if true;
                        
                        
    }
    
  }
}
