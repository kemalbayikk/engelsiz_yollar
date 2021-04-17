import 'package:cloud_firestore/cloud_firestore.dart';

class UserFromFirebase {
  final String uid;

  UserFromFirebase({this.uid});
}

class UserData {
  final String uid;
  final String email;
  final String name;
  final String surname;

  UserData(
      {this.uid,
      this.email,
      this.name,
      this.surname});

  factory UserData.fromDocument(DocumentSnapshot doc) {
    return UserData(
        uid: doc['uid'],
        email: doc['email'],
        name: doc['name'],
        surname: doc['surname'],);
  }
}
