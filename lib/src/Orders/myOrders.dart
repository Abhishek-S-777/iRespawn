import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/widgets/orderCard.dart';
import '../Widgets/loadingWidget.dart';


class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}


class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
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
              // gradient: new LinearGradient(
              //   colors: [Colors.pink, Colors.lightGreenAccent],
              //   begin: const FractionalOffset(0.0, 0.0),
              //   end: const FractionalOffset(1.0, 0.0),
              //   stops: [0.0, 1.0],
              //   tileMode: TileMode.clamp,
              // ),
            ),
          ),
          centerTitle: true,
          title: Text("My Orders", style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_drop_down_circle, color: Colors.white,),
              onPressed: ()
              {
                SystemNavigator.pop();
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(respawn.collectionUser)
              .doc(respawn.sharedPreferences.getString(respawn.userUID))
              .collection(respawn.collectionOrders)
              .orderBy("orderTime",descending: true)
              .snapshots(),
          
          builder: (c, snapshot)
          {
            return snapshot.hasData 
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (c, index){
                      return FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection("products")
                            .where("shortInfo", whereIn: snapshot.data.docs[index].data()[respawn.productID],)
                            .get(),

                        builder: (c, snap)
                        {
                          return snap.hasData
                              ? OrderCard(
                                  itemCount: snap.data.docs.length,
                                  data: snap.data.docs,
                                  orderID: snapshot.data.docs[index].id,
                                )
                              : Center(child: circularProgress(),);
                        },
                      );
                    },
                  ) 
                : Center(child: circularProgress(),);
          },
        ),
      ),
    );
  }
}
