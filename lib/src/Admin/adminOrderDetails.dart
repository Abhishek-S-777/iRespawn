import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:irespawn/src/Address/address.dart';
import 'package:irespawn/src/InvoicePDF/api/pdf_api.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/model/addressmodel.dart';
import 'package:irespawn/src/widgets/loadingWidget.dart';
import 'package:irespawn/src/widgets/orderCard.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:mailer/mailer.dart';

import 'dart:io';

import 'package:mailer/smtp_server.dart';


String getOrderId="";
class AdminOrderDetails extends StatelessWidget
{
  final String orderID;
  final String orderBy;
  final String addressID;

  AdminOrderDetails({Key key, this.orderID, this.orderBy, this.addressID,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection(respawn.collectionOrders)
                .doc(getOrderId)
                .get(),
            builder: (c, snapshot)
            {
              Map dataMap;
              if(snapshot.hasData)
              {
                dataMap = snapshot.data.data();
              }
              return snapshot.hasData
                  ? Container(
                child: Column(
                  children: [
                    AdminStatusBanner(status: dataMap[respawn.isSuccess],),
                    SizedBox(height: 10.0,),
                    Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "₹ " + dataMap[respawn.totalAmount].toString(),
                          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child: Text("Order ID: " + getOrderId),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Ordered at: " + DateFormat("dd MMMM, yyyy - hh:mm aa")
                            .format(DateTime.fromMillisecondsSinceEpoch(int.parse(dataMap["orderTime"]))),
                        style: TextStyle(color: Colors.grey, fontSize: 16.0),
                      ),
                    ),
                    Divider(height: 2.0,),
                    FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("products")
                          .where("shortInfo", whereIn: dataMap[respawn.productID])
                          .get(),
                      builder: (c, dataSnapshot)
                      {
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
                          .doc(orderBy)
                          .collection(respawn.subCollectionAddress)
                          .doc(addressID)
                          .get(),
                      builder: (c, snap)
                      {
                        return snap.hasData
                            ? AdminShippingDetails(model: AddressModel.fromJson(snap.data.data()), orderIDEmail: dataMap['userEmail'],)
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

class AdminStatusBanner extends StatelessWidget {
  final bool status;

  AdminStatusBanner({Key key, this.status}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    String msg;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? msg = "Successfully" : msg = "UnSuccessfully";

    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            begin: Alignment.bottomRight,
            colors: [
              Colors.deepOrangeAccent.withOpacity(.7),
              // Colors.deepPurpleAccent.withOpacity(.6),
              Colors.black.withOpacity(.4),
            ]
          // colors: [Colors.pink, Colors.lightGreenAccent],
          // begin: const FractionalOffset(0.0, 0.0),
          // end: const FractionalOffset(1.0, 0.0),
          // stops: [0.0, 1.0],
          // tileMode: TileMode.clamp,
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
            "Order Created " + msg,
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



class AdminShippingDetails extends StatefulWidget {
  final AddressModel model;
  final String orderIDEmail;

  AdminShippingDetails({Key key, this.model, this.orderIDEmail}) : super(key: key);

  @override
  _AdminShippingDetailsState createState() => _AdminShippingDetailsState();
}

class _AdminShippingDetailsState extends State<AdminShippingDetails> {

  bool isShipped = false;
  bool isDelivered = false;
  String _scanBarcode = 'Unknown';
  String userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance.collection("orders").doc(getOrderId).get().then((value) {
      setState(() {
        isShipped = value['shipmentStatus'];
      });
      print("new shipped: "+isShipped.toString());
    });
    FirebaseFirestore.instance.collection("orders").doc(getOrderId).get().then((value) {
      setState(() {
        isDelivered = value['isDelivered'];
      });
      print("new isDelivered: "+isDelivered.toString());
    });


  }

  @override
  Widget build(BuildContext context)
  {
    double screenWidth = MediaQuery.of(context).size.width;

    // FirebaseFirestore.instance.collection("orders").doc(getOrderId).get().then((value) {
    //   setState(() {
    //     userId = value['userId'];
    //     print("UserID from the orders collection in the build"+userId.toString());
    //   });
    // }) ;
    FirebaseFirestore.instance.collection("orders").doc(getOrderId).get().then((value) {
      userId = value['userId'];
      print("UserID from the orders collection in the build: "+userId.toString());
    }) ;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.0,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0,),
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
              onTap: isShipped ? null: onTapp ,
              child: Container(
                decoration: new BoxDecoration(
                  gradient: isShipped? LinearGradient(
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0,3.0],
                      // begin: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(.5),
                        // Colors.blue.withOpacity(.6),
                        Colors.blue.withOpacity(.4),
                      ]
                  ) : LinearGradient(
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
                    isShipped? "Order Shipped":"Confirm Order Shipped",
                    // "Confirm Order Shipped",
                    style: TextStyle(color: Colors.white, fontSize: 15.0,),
                  ),
                ),
              ),
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: isDelivered ? null: scanBarcodeNormal ,
              child: Container(
                decoration: new BoxDecoration(
                  gradient: isDelivered? LinearGradient(
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0,3.0],
                      // begin: Alignment.bottomRight,
                      colors: [
                        Colors.black.withOpacity(.5),
                        // Colors.blue.withOpacity(.6),
                        Colors.deepOrangeAccent.withOpacity(.4),
                      ]
                  ) : LinearGradient(
                      begin: const FractionalOffset(0.0, 0.0),
                      end: const FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0,3.0],
                      // begin: Alignment.bottomRight,
                      colors: [
                        Colors.redAccent.withOpacity(.7),
                        Colors.deepPurpleAccent.withOpacity(.6),
                        Colors.black.withOpacity(.4),
                      ]
                  ),
                ),
                width: MediaQuery.of(context).size.width - 40.0,
                height: 50.0,
                child: Center(
                  child: Text(
                    isDelivered? "Order Delivered":"Deliver Order/Scan Barcode",
                    // "Confirm Order Shipped",
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

  onTapp(){

    print("is shipped status: "+isShipped.toString());
    PdfApi.sendMailUser(widget.orderIDEmail,getOrderId,widget.model);
    setState(() {
      FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
        "shipmentStatus" : true,
      });
      isShipped = true;
      print("After Changing the shipment status"+isShipped.toString() );
    });

    // getOrderId = "";
    Fluttertoast.showToast(msg: "Order Shipped Successfully.");

    // confirmParcelShifted(context, getOrderId);
  }

  //qr code scanner.....

    Future<void> scanBarcodeNormal() async {
      String barcodeScanRes;
      print("user id from the orders inside scan is "+userId.toString());
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE
        );
        print(barcodeScanRes);
      } on PlatformException {
        barcodeScanRes = 'Failed to get platform version.';
      }
      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;
      setState(() {
        _scanBarcode = barcodeScanRes;
        print("barcode result is: "+_scanBarcode.toString());
        print("order is is: "+getOrderId.toString());
        if(_scanBarcode == getOrderId){
          print("is delivered status: "+isDelivered.toString());
          // PdfApi.sendMailUser(widget.orderIDEmail,getOrderId,widget.model);
          //to update the delivery status from the admin side
          FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
            "isDelivered" : true,
          });



          print("UserID outside the orders collection "+userId.toString());
          FirebaseFirestore.instance.collection("users").doc(userId).collection("orders").doc(getOrderId)
              .update({
            "isDelivered" : true,
          });

          isDelivered = true;
          print("After Changing the delivery status "+isDelivered.toString() );

          // getOrderId = "";
          Fluttertoast.showToast(msg: "Order Delivered Successfully.");
        }

        else{
          Fluttertoast.showToast(msg: "Barcode doesn't match with the Order ID",timeInSecForIos: 3);
        }
      });



    }


  confirmParcelShifted(BuildContext context, String mOrderId)
  {

    // isShipped = true;

    // setState(() {
    // });
    //// to delete the order document...
    // FirebaseFirestore.instance
    //     .collection("orders")
    //     .doc(mOrderId)
    //     .delete();

    getOrderId = "";

    // Route route = MaterialPageRoute(builder: (c) => UploadPage());
    // Navigator.pushReplacement(context, route);



    Fluttertoast.showToast(msg: "Order Shipped Successfully.");
  }
}



