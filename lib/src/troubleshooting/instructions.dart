import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/Counters/cartitemcounter.dart';
import 'package:irespawn/src/PaymentGateway/razorpayPayment.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/themes/theme.dart';
import 'package:irespawn/src/troubleshooting/userchat/mainchatscreen.dart';
import 'package:provider/provider.dart';
import 'customIcons.dart';
import 'data.dart';
import 'dart:math';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class Instructions extends StatefulWidget {
  final bool isPaymentSuccess;

  Instructions({Key key,this.isPaymentSuccess}) : super(key: key);

  @override
  _InstructionsState createState() => _InstructionsState();
}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _InstructionsState extends State<Instructions> {
  int ServiceAmount=100;
  var currentPage = images.length - 1.0;
  bool fbServicePaymentSuccess;

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: images.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            // begin: const FractionalOffset(0.0, 0.2),
            // end: const FractionalOffset(1.0, 0.0),
            // stops: [0.0, 1.0],
              colors: [
                Colors.white,
                Colors.grey.withOpacity(.4),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.clamp)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 12.0, right: 12.0, top: 30.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // IconButton(
                    //   icon: Icon(
                    //     CustomIcons.menu,
                    //     color: Colors.white,
                    //     size: 30.0,
                    //   ),
                    //   onPressed: () {},
                    // ),
                    // IconButton(
                    //   icon: Icon(
                    //     Icons.search,
                    //     color: Colors.white,
                    //     size: 30.0,
                    //   ),
                    //   onPressed: () {},
                    // )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Prerequisite",
                        style: TextStyle(
                          color: Colors.black.withOpacity(.7),
                          fontSize: 46.0,
                          fontFamily: "Calibre-Semibold",
                          letterSpacing: 1.0,
                        )),
                    // IconButton(
                    //   icon: Icon(
                    //     CustomIcons.option,
                    //     size: 12.0,
                    //     color: Colors.white,
                    //   ),
                    //   onPressed: () {},
                    // )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: <Widget>[
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Color(0xFFff6e6e),
                    //     borderRadius: BorderRadius.circular(20.0),
                    //   ),
                    //   child: Center(
                    //     child: Padding(
                    //       padding: EdgeInsets.symmetric(
                    //           horizontal: 22.0, vertical: 6.0),
                    //       child: Text("Animated",
                    //           style: TextStyle(color: Colors.white)),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 15.0,
                    // ),
                    // Text("25+ Stories",
                    //     style: TextStyle(color: Colors.blueAccent))
                  ],
                ),
              ),
              Stack(
                children: <Widget>[
                  CardScrollWidget(currentPage),
                  Positioned.fill(
                    child: PageView.builder(
                      itemCount: images.length,
                      controller: controller,
                      reverse: true,
                      itemBuilder: (context, index) {
                        return Container();
                      },
                    ),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Text("Favourite",
                    //     style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 46.0,
                    //       fontFamily: "Calibre-Semibold",
                    //       letterSpacing: 1.0,
                    //     )),
                    // IconButton(
                    //   icon: Icon(
                    //     CustomIcons.option,
                    //     size: 12.0,
                    //     color: Colors.white,
                    //   ),
                    //   onPressed: () {},
                    // )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: <Widget>[
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.blueAccent,
                    //     borderRadius: BorderRadius.circular(20.0),
                    //   ),
                    //   child: Center(
                    //     child: Padding(
                    //       padding: EdgeInsets.symmetric(
                    //           horizontal: 22.0, vertical: 6.0),
                    //       child: Text("Latest",
                    //           style: TextStyle(color: Colors.white)),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 15.0,
                    // ),
                    // Text("9+ Stories",
                    //     style: TextStyle(color: Colors.blueAccent))
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Text("Help Links:",style:TextStyle(
                        color: Colors.black54,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: "SF-Pro-Text-Regular"),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 12,left: 18.0),
                    child: Text("Quick Assist Guide:",style:TextStyle(
                        color: Colors.black54,
                        fontSize: 17.0,
                        fontFamily: "SF-Pro-Text-Regular"),),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Linkify(
                      onOpen: _onOpen,
                      text: "https://cutt.ly/3nsknLH",
                      style: TextStyle(color: Colors.black54),
                      linkStyle: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(left: 18.0),
                    child: Text("TeamViewer download link:",style:TextStyle(
                        color: Colors.black54,
                        fontSize: 17.0,
                        fontFamily: "SF-Pro-Text-Regular"),),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Linkify(
                      onOpen: _onOpen,
                      text: "https://www.teamviewer.com/en-us/download/windows/",
                      style: TextStyle(color: Colors.black54),
                      linkStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: MaterialButton(
                        onPressed: (){
                          print("User id from inst is:"+respawn.sharedPreferences.getString(respawn.userUID));
                          FirebaseFirestore.instance
                              .collection('users').doc(respawn.sharedPreferences.getString(respawn.userUID))
                              .get()
                              .then((value) =>  fbServicePaymentSuccess = value.data()["isServicePaymentSuccess"]);
                          //
                          // if(widget.isPaymentSuccess==true){
                          //   final itemsRef = FirebaseFirestore.instance.collection("users");
                          //   itemsRef.doc(respawn.sharedPreferences.getString(respawn.fbuserID)).update({
                          //     "servicePurchased" : true,
                          //   });
                          // }
                          if(widget.isPaymentSuccess==true || respawn.sharedPreferences.getString(respawn.isServicePaymentSuccess)== "true" ){
                            // final itemsRef = FirebaseFirestore.instance.collection("users");
                            // itemsRef.doc(respawn.sharedPreferences.getString(respawn.fbuserID)).update({
                            //   "isServicePaymentSuccess" : true,
                            // }).whenComplete(() => respawn.sharedPreferences.setString(respawn.isServicePaymentSuccess,"true"));
                            respawn.sharedPreferences.setString(respawn.isServicePaymentSuccess,"true");
                            print("isservicepayment from shared"+respawn.sharedPreferences.getString(respawn.isServicePaymentSuccess).toString());

                            Route route = MaterialPageRoute(builder: (c) => MainChatScreen());
                            Navigator.push(context, route);
                          }
                          else if(widget.isPaymentSuccess==false || respawn.sharedPreferences.getString(respawn.isServicePaymentSuccess)== "false"){
                            Route route = MaterialPageRoute(builder: (c) => PayRazor(isServiceOpted:true));
                            Navigator.push(context, route);
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  colors: [
                                    Colors.deepOrangeAccent.withOpacity(.6),
                                    Colors.deepPurpleAccent,
                                    // Colors.white,
                                  ]
                              )
                          ),
                          child: Center(
                            child: Text(widget.isPaymentSuccess || respawn.sharedPreferences.getString(respawn.isServicePaymentSuccess) == "true"? "Go to Chat!" : "Book a Service!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        )
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  )
                  // Padding(
                  //   padding: EdgeInsets.only(left: 18.0),
                  //   child: ClipRRect(
                  //     borderRadius: BorderRadius.circular(20.0),
                  //     child: Image.asset("assets/image_02.jpg",
                  //         width: 296.0, height: 222.0),
                  //   ),
                  // )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

// //for booking the service....
// void checkItemInCart(String shortInfoAsID, BuildContext context)
// {
//   if(respawn.sharedPreferences.getStringList(respawn.userCartList).contains(shortInfoAsID)){
//     Fluttertoast.showToast(msg: "Item is already in Cart.");
//   }
//   else if (respawn.sharedPreferences.getStringList(respawn.userCartList).length-1 > 8){
//     Fluttertoast.showToast(msg: "Cart cannot have more than 9 items");
//   }
//   else{
//     addItemToCart(shortInfoAsID, context);
//   }
// }
//
//
// addItemToCart(String shortInfoAsID, BuildContext context)
// {
//   List tempCartList = respawn.sharedPreferences.getStringList(respawn.userCartList);
//   tempCartList.add(shortInfoAsID);
//   FirebaseFirestore.instance.collection(respawn.collectionUser)
//       .doc(respawn.sharedPreferences.getString(respawn.userUID))
//       .update({
//     respawn.userCartList: tempCartList,
//   }).then((v){
//     Fluttertoast.showToast(msg: "Item Added to Cart Successfully.");
//
//     respawn.sharedPreferences.setStringList(respawn.userCartList, tempCartList);
//
//     Provider.of<CartItemCounter>(context, listen: false).displayResult();
//   });
// }



}

// ignore: must_be_immutable
class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var padding = 20.0;
  var verticalInset = 20.0;

  CardScrollWidget(this.currentPage);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < images.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = padding +
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: padding + verticalInset * max(-delta, 0.0),
            // top: 10.0,
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(3.0, 6.0),
                      blurRadius: 10.0)
                ]),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(images[i], fit: BoxFit.cover),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Text(title[i],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17.0,
                                      fontFamily: "SF-Pro-Text-Regular")
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12.0, bottom: 12.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 22.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Text("Scroll",
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }

}
