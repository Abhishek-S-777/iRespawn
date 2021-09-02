
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:irespawn/src/Address/address.dart';
import 'package:irespawn/src/InvoicePDF/page/pdf_page.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/model/addressmodel.dart';
import 'package:irespawn/src/widgets/loadingWidget.dart';
import 'package:irespawn/src/widgets/orderCard.dart';
import 'package:irespawn/src/widgets/qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

String getOrderId="";
class OrderDetails extends StatefulWidget
{
  final String orderID;

  OrderDetails({Key key, this.orderID,}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List<DocumentSnapshot> orderItems1;

  @override
  Widget build(BuildContext context)
  {
    getOrderId = widget.orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future:  FirebaseFirestore.instance
                    .collection(respawn.collectionUser)
                    .doc(respawn.sharedPreferences.getString(respawn.userUID))
                    .collection(respawn.collectionOrders)
                    .doc(widget.orderID)
                    .get(),
            builder: (c, snapshot)
            {
              num totalamt;
              Map dataMap;
              if(snapshot.hasData)
              {
                dataMap = snapshot.data.data();
                totalamt = dataMap[respawn.totalAmount];
              }

              return snapshot.hasData
                  ? Container(
                      child: Column(
                        children: [
                          StatusBanner(status: dataMap[respawn.isSuccess],),
                          SizedBox(height: 15.0,),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "₹ " + dataMap[respawn.totalAmount].toString(),
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text("Order ID: " + getOrderId),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Ordered On: " + DateFormat("dd MMMM, yyyy - hh:mm aa")
                                  .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                              style: TextStyle(color: Colors.grey, fontSize: 16.0),
                            ),
                          ),
                          Divider(height: 2.0,),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("products")
                                .where("shortInfo", whereIn: dataMap[respawn.productID])
                                .snapshots(),
                            builder: (c, dataSnapshot)
                            {
                              if(dataSnapshot.hasData){
                                orderItems1 = dataSnapshot.data.docs;
                                print("Order items inside listt");
                                print(orderItems1);
                              }
                              return dataSnapshot.hasData
                                  ? OrderCard(
                                      itemCount: dataSnapshot.data.docs.length,
                                      data: dataSnapshot.data.docs,
                                    )
                                  : Center(child: circularProgress(),);
                            },
                          ),
                          Divider(height: 2.0,),
                          FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance
                                .collection(respawn.collectionUser)
                                .doc(respawn.sharedPreferences.getString(respawn.userUID))
                                .collection(respawn.subCollectionAddress)
                                .doc(dataMap[respawn.addressID])
                                .get(),

                            builder: (c, snap)
                            {
                              print("orderitems1 again $orderItems1");
                              return snap.hasData && orderItems1!=null
                                  // ? ShippingDetails(model: AddressModel.fromJson(snap.data.data()), orderItems2: orderItems1, totamt: totalamt,orderID1: orderID,)
                                  ? ShippingDetails(orderItems1,model: AddressModel.fromJson(snap.data.data()), totamt: totalamt,orderID1: widget.orderID,)
                                  : Center(child: circularProgress(),);
                            },
                          ),
                        ],
                      ),
                    )
                  : Center(child: circularProgress(),);
            },
          ),
        ),
      ),
    );
  }
}

class StatusBanner extends StatelessWidget
{
  final bool status;

  StatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successfully" : msg = "UnSuccessful";

    return Container(
      decoration: new BoxDecoration(
        gradient: LinearGradient(
          // begin: const FractionalOffset(0.0, 0.0),
          // end: const FractionalOffset(1.0, 0.0),
          // stops: [0.0, 1.0,3.0],
            begin: Alignment.bottomRight,
            colors: [
              Colors.deepOrangeAccent.withOpacity(.7),
              // Colors.deepPurpleAccent.withOpacity(.6),
              Colors.black.withOpacity(.4),
            ]
        ),
      ),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: ()
            {
              SystemNavigator.pop();
            },
            child: Container(
              child: Icon(
                Icons.arrow_drop_down_circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 20.0,),
          Text(
            "Order Placed " + msg,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 5.0,),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.grey,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 14.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class ShippingDetails  extends StatefulWidget
{
  final AddressModel model;
  final List<DocumentSnapshot> orderItems2;
  final double totamt;
  final String orderID1;

  // ShippingDetails({Key key, this.model, this.orderItems2, this.totamt,this.orderID1}) : super(key: key);
  ShippingDetails(this.orderItems2,{Key key, this.model, this.totamt,this.orderID1}) : super(key: key);

  @override
  _ShippingDetailsState createState() => _ShippingDetailsState();
}

class _ShippingDetailsState extends State<ShippingDetails> {
  bool isDelivered=false;



  @override
  Widget build(BuildContext context)
  {
    FirebaseFirestore.instance
        .collection(respawn.collectionUser)
        .doc(respawn.sharedPreferences.getString(respawn.userUID))
        .collection(respawn.collectionOrders)
        .doc(getOrderId)
        .get().then((value) {
          setState(() {
            isDelivered = value['isDelivered'];
            print("isDelivered status isnide build: "+isDelivered.toString());
          });

      // setState(() {
      //     });
    });
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0,),
          child: Text(
            "Shipment Details:",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 90.0, vertical: 5.0),
          width: screenWidth,
          child: Table(
            children: [

              TableRow(
                  children: [
                    KeyText(msg: "Name",),
                    Text(widget.model.name),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "Phone Number",),
                    Text(widget.model.phoneNumber),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "Flat Number",),
                    Text(widget.model.flatNumber),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "City",),
                    Text(widget.model.city),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "State",),
                    Text(widget.model.state),
                  ]
              ),

              TableRow(
                  children: [
                    KeyText(msg: "Pin Code",),
                    Text(widget.model.pincode),
                  ]
              ),

            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap:  ()
              {
                //generating qr code...
                if(isDelivered==false){
                  Route route = MaterialPageRoute(builder: (c) => QRcode(msg: widget.orderID1,));
                  Navigator.pushReplacement(context, route);
                }
                else if(isDelivered==true){
                  print("isdelivered is true");
                  print(widget.orderItems2);
                  if(widget.orderItems2!=null){
                    print("printing order items: "+widget.orderItems2.toString());
                    Fluttertoast.showToast(msg:"orderitems is not null" );
                    print("orderitems is not null");
                    Route route = MaterialPageRoute(builder: (c) => PdfPage(model2: widget.model,orderItems3: widget.orderItems2, totamt1: widget.totamt,orderID: widget.orderID1,));
                    Navigator.pushReplacement(context, route);
                    confirmedUserOrderReceived(context, getOrderId);
                  }
                  else if(widget.orderItems2!=null){
                    print("Order Items is null, debug");
                    Fluttertoast.showToast(msg:"Order Items is null, debug");
                  }

                  // confirmedUserOrderReceived(context, getOrderId);
                  // Route route = MaterialPageRoute(builder: (c) => PdfPage(model2: model,orderItems3: orderItems2, totamt1: totamt,orderID: orderID1,));
                  // Navigator.pushReplacement(context, route);
                }


              },
              child: Container(
                decoration: new BoxDecoration(
                  gradient: isDelivered? LinearGradient(
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0,3.0],
                      // begin: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(.4),
                        Colors.orange.withOpacity(.6),
                        Colors.black.withOpacity(.4),
                      ]
                  )  : LinearGradient(
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0,3.0],
                      // begin: Alignment.bottomRight,
                      colors: [
                        Colors.blue.withOpacity(.7),
                        Colors.deepPurpleAccent.withOpacity(.6),
                        Colors.black.withOpacity(.4),
                      ]
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    isDelivered? "Product Received/Download Invoice":"Confirm Order Received",
                    style: TextStyle(color: Colors.white, fontSize: 15.0,),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  confirmedUserOrderReceived(BuildContext context, String mOrderId)
  {
    // FirebaseFirestore.instance
    //     .collection(respawn.collectionUser)
    //     .doc(respawn.sharedPreferences.getString(respawn.userUID))
    //     .collection(respawn.collectionOrders)
    //     .doc(mOrderId)
    //     .delete();

    // getOrderId = "";


    Fluttertoast.showToast(msg: "Order has been Received. Confirmed.");
  }
}



