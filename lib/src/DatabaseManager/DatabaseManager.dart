import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:irespawn/main.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseManager {
  final CollectionReference profileList = FirebaseFirestore.instance.collection('users');


  // Future<void> createUserData(
  //     String name, String gender, int score, String uid) async {
  //   return await profileList.doc(uid).set({'name': name, 'gender': gender, 'score': score});
  //   // return await profileList.document(uid).setData({'name': name, 'gender': gender, 'score': score});
  // }
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String deviceTokenn;

  _getToken(){
    _firebaseMessaging.getToken().then((deviceToken){
      print("Device Token: $deviceToken");
      deviceTokenn= deviceToken;
      // return deviceTokenn;
    });
  }


  Future<void> createUserData(String name, String email, String password, String phno, String uImageUrl, String uid) async {
    await _getToken();
    await respawn.sharedPreferences.setString(respawn.isServicePaymentSuccess, "false");
    await respawn.sharedPreferences.setString(respawn.userUID, uid);
    await respawn.sharedPreferences.setString(respawn.userName, name);
    await respawn.sharedPreferences.setString(respawn.userEmail, email);
    await respawn.sharedPreferences.setString(respawn.userPassword, password);
    await respawn.sharedPreferences.setString(respawn.userPhno, phno);
    await respawn.sharedPreferences.setString(respawn.userAvatarUrl, uImageUrl);
    await respawn.sharedPreferences.setStringList(respawn.userCartList, ["garbageValue"]);
    await respawn.sharedPreferences.setStringList(respawn.userWishList, ["garbageValue"]);
    print("Database manager userwishlist is"+respawn.sharedPreferences.getStringList(respawn.userWishList).toString());
    return await profileList.doc(uid).set({
      'name': name,
      'email': email,
      'password': password,
      'phoneNumber': phno,
      'url': uImageUrl,
      'deviceIDToken' : deviceTokenn,
      'createdDate' : DateFormat('dd-MM-yyyy').format(DateTime.now()),
      respawn.isServicePaymentSuccess : "false",
      respawn.userCartList : ["garbageValue"],
      respawn.userWishList : ["garbageValue"],
    });
    // return await profileList.document(uid).setData({'name': name, 'gender': gender, 'score': score});
  }


  Future updateUserList(String name, String email, String password, String phno, String uImageUrl,String uid) async {
    return await profileList.doc(uid).update({
      'name': name, 'email': email, 'password': password, 'phoneNumber': phno, 'usrImgURL': uImageUrl
      // 'name': name, 'gender': gender, 'score': score
    });
  }

  Future getUsersList() async {
    List itemsList = [];
    try {
      await profileList.get().then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          itemsList.add(element.data);
        });
      });
      return itemsList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
