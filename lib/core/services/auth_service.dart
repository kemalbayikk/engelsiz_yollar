import 'package:engelsiz_yollar/core/models/user.dart';
import 'package:engelsiz_yollar/core/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User currentUser;
  AuthService(this._firebaseAuth);
  UserFromFirebase _userFromFirebaseUser(User user) {
    return user != null ? UserFromFirebase(uid: user.uid) : null;
  }

    Future signInWith(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWith(String email, String password, String name, String surname) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      currentUser = user;
      await DatabaseService(uid: user.uid).updateUserData(
          email,
          name,
          surname);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}