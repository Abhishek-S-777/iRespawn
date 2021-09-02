import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:irespawn/src/DatabaseManager/DatabaseManager.dart';
import 'package:irespawn/src/model/user.dart';
import 'package:irespawn/src/constants/config.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// registration with email and password

  Future createNewUser(String uname, String uemail, String upassword, String uphno, String uImageUrl) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: uemail, password: upassword);
      User user = result.user;

      // //for sending firebase authentication email....
      // User firebaseCurrentUser = FirebaseAuth.instance.currentUser;
      // firebaseCurrentUser.sendEmailVerification();


      await DatabaseManager().createUserData(
          uname, uemail, upassword, uphno, uImageUrl, user.uid);
      return _userFromFirebaseUser(user);
      // return user;
    }
    // }on FirebaseAuthException catch(e){
    //   if(e.code == 'email-already-in-use'){
    //     // respawn.message = 'The account already exists for that email.';
    //     return 'The account already exists for that email.';
    //   }
    //   return e.message;
    // }
    catch (e) {
      print(e.toString());
    }
  }

  // create user obj based on firebase user
  UserID _userFromFirebaseUser(User user) {
    return user != null ? UserID(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserID> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
    // onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
    // .map(_userFromFirebaseUser);
  }

// sign with email and password

  Future loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      readData(user);
      print("User id inside the auth service dart file"+user.uid);
      return _userFromFirebaseUser(user);

      // return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  //read data from the firebase for the current logged in user from the firestore database..
  Future readData(User fuser) async
  {
    FirebaseFirestore.instance.collection("users").doc(fuser.uid).get().then((dataSnapshot) async {
      print("User id inside the read data is "+fuser.uid);
      await respawn.sharedPreferences.setString(respawn.isServicePaymentSuccess, dataSnapshot.data()["isServicePaymentSuccess"]);
      // await respawn.sharedPreferences.setString(respawn.fbuserID, fuser.uid.toString());
      await respawn.sharedPreferences.setString(respawn.userUID, fuser.uid);
      await respawn.sharedPreferences.setString(respawn.userName, dataSnapshot.data()["name"]);
      await respawn.sharedPreferences.setString(respawn.userEmail, dataSnapshot.data()["email"]);
      await respawn.sharedPreferences.setString(respawn.userPassword, dataSnapshot.data()["password"]);
      await respawn.sharedPreferences.setString(respawn.userPhno, dataSnapshot.data()["phoneNumber"]);
      await respawn.sharedPreferences.setString(respawn.userAvatarUrl, dataSnapshot.data()["url"]);

      List <String> cartList = dataSnapshot.data()["userCart"].cast<String>();
      await respawn.sharedPreferences.setStringList(respawn.userCartList, cartList);

      List <String> wishList = dataSnapshot.data()["userWishlist"].cast<String>();
      await respawn.sharedPreferences.setStringList(respawn.userWishList, wishList);

      print("Wishlist is: "+wishList.toString());
      print("Shared preference cart list is: "+respawn.sharedPreferences.getStringList(respawn.userWishList).toString());
      print("Shared preference cart list 2 is: "+respawn.userWishList);

      // // List <String> cartList = dataSnapshot.data()["userCart"].cast<String>();
      // print("Cartlist is: "+cartList.toString());
      // print("Shared preference cart list is: "+respawn.sharedPreferences.getStringList(respawn.userCartList).toString());
      // print("Shared preference cart list 2 is: "+respawn.userCartList);
      //
      // print("Wishlist is: "+wishList.toString());
      // print("Shared preference cart list is: "+respawn.sharedPreferences.getStringList(respawn.userWishList).toString());
      // print("Shared preference cart list 2 is: "+respawn.userWishList);
    });
  }

// signout

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
