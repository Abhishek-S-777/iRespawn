import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/Counters/cartitemcounter.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget
{
  final String addressId;
  final double totalAmount;

  PaymentPage({Key key, this.addressId, this.totalAmount,}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.pink, Colors.lightGreenAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.asset("images/cash.png"),
              ),
              SizedBox(height: 10.0,),
              FlatButton(
                color: Colors.pinkAccent,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                splashColor: Colors.deepOrange,
                onPressed: ()=> addOrderDetails(),
                child: Text("Place Order", style: TextStyle(fontSize: 30.0),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  addOrderDetails()
  {
    writeOrderDetailsForUser({
      respawn.addressID: widget.addressId,
      respawn.totalAmount: widget.totalAmount,
      "orderBy": respawn.sharedPreferences.getString(respawn.userUID),
      respawn.productID: respawn.sharedPreferences.getStringList(respawn.userCartList),
      respawn.paymentDetails: "RazorPay",
      respawn.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      respawn.isSuccess: true,
    });

    writeOrderDetailsForAdmin({
      respawn.addressID: widget.addressId,
      respawn.totalAmount: widget.totalAmount,
      "orderBy": respawn.sharedPreferences.getString(respawn.userUID),
      respawn.productID: respawn.sharedPreferences.getStringList(respawn.userCartList),
      respawn.paymentDetails: "RazorPay",
      respawn.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      respawn.isSuccess: true,
    }).whenComplete(() => {
      emptyCartNow()
    });
  }

  emptyCartNow()
  {
    respawn.sharedPreferences.setStringList(respawn.userCartList, ["garbageValue"]);
    List tempList = respawn.sharedPreferences.getStringList(respawn.userCartList);

    FirebaseFirestore.instance.collection("users")
        .doc(respawn.sharedPreferences.getString(respawn.userUID))
        .update({
      respawn.userCartList: tempList,
    }).then((value)
    {
      respawn.sharedPreferences.setStringList(respawn.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });

    Fluttertoast.showToast(msg: "Congratulations, your Order has been placed successfully.");

    ////Change the navigaton later...
    // Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    // Navigator.pushReplacement(context, route);
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance.collection(respawn.collectionUser)
        .doc(respawn.sharedPreferences.getString(respawn.userUID))
        .collection(respawn.collectionOrders)
        .doc(respawn.sharedPreferences.getString(respawn.userUID) + data['orderTime'])
        .set(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
        .collection(respawn.collectionOrders)
        .doc(respawn.sharedPreferences.getString(respawn.userUID) + data['orderTime'])
        .set(data);
  }
}
