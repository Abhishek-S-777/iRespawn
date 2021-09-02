import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/model/commentmodel.dart';
import 'package:irespawn/src/productComments/productcomment.dart';
import 'package:flutter/material.dart';
import 'package:irespawn/src/widgets/loadingWidget.dart';

class TestMeNew extends StatefulWidget {
  final ScrollController draggable;
  final String prodID;
  TestMeNew({this.draggable,this.prodID});
  @override
  _TestMeNewState createState() => _TestMeNewState();
}

class _TestMeNewState extends State<TestMeNew> {


  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  final _controllerr = ScrollController();
  Stream _stream;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection("products")
        .doc(widget.prodID)
        .collection("comments").orderBy("publishedDate",descending: true)
        .snapshots();
  }

  // Backup code if anything goes wrong....
  Widget commentChild({data}) {
    return Container(
      // height: 130,
      child: StreamBuilder<QuerySnapshot>(
        stream: _stream,

        builder: (context, snapshot)
        {
          if(snapshot.hasData){
            print("Snapshot has data comments");
            if(snapshot.data.docs.length==0){
              noCommentCard();
            }
            else{
              return ListView.builder(
                // controller: widget.draggable,
                // controller: _controllerr,
                // itemCount: snapshot.data.docs.length,
                itemCount: 1,
                shrinkWrap: true,
                itemBuilder: (context, index)
                {
                  print("comment index is: "+index.toString());
                  return SizedBox(
                    height: 210,
                    child: ListView(
                      // controller: widget.draggable,
                      controller: _controllerr,
                      children: snapshot.data.docs.map((doc){
                        return ListTile(
                          // trailing: IconButton(
                          //   icon: Icon(Icons.delete_outline, color: Colors.deepOrange,),
                          //   onPressed: ()
                          //   {
                          //     print("comment index is: "+index.toString());
                          //     removeComment(widget.prodID);
                          //     // removeCartFunction();
                          //     // Route route = MaterialPageRoute(builder: (c) => MyHomePage());
                          //     // Navigator.pushReplacement(context, route);
                          //   },
                          // ),
                          leading: GestureDetector(
                            onTap: () async {
                              // Display the image in large form.
                              print("Comment Clicked");
                            },
                            child: Container(
                              height: 50.0,
                              // height: MediaQuery.of(context).size.height,
                              width: 50.0,
                              // width: MediaQuery.of(context).size.width,
                              decoration: new BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: new BorderRadius.all(Radius.circular(50))),
                              child: CircleAvatar(
                                  radius: 50,
                                  // backgroundImage: NetworkImage(doc.data()['profilePic'])),
                                  backgroundImage: NetworkImage(doc.data()['profilePic']??"Not Available")),
                            ),
                          ),
                          title: Text(
                            doc.data()['userName']?? "Not Available",
                            // "prince",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(doc.data()['comment']?? "Not Available"),
                          // subtitle: Text("Hiii"),
                        );
                      }).toList(),
                    ),
                  );
                },
              );
            }
          }
          else if(!snapshot.hasData){
            print("Snapshot has no comments");
          }
          return noCommentCard();

        },
      ),
    );
  }



  //No comment card
  noCommentCard() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))),
        color: Colors.black38,
        child: Container(
          height: 100.0,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, color: Colors.white,size: 50,),
              // Text("No Reviews posted yet.",style: TextStyle(fontWeight: FontWeight.bold),),
              Text("No Reviews posted yet.",style: TextStyle(color: Colors.white),),
              // Text("Be the first one to add a review....",style: TextStyle(fontWeight: FontWeight.bold),),
              Text("Be the first one to add a review....",style: TextStyle(color: Colors.white),),
            ],
          ),
        ),
      ),
    );
  }

  //Backup build function...
  @override
  Widget build(BuildContext context) {
    return CommentBox(
      userImage: respawn.sharedPreferences.getString(respawn.userAvatarUrl),
      child: commentChild(),
      labelText: 'Add a review...',
      errorText: 'Review cannot be blank',
      withBorder: false,
      sendButtonMethod: () {
        if (formKey.currentState.validate()) {
          if(_controllerr.hasClients){
            _controllerr.animateTo
              (
              _controllerr.position.minScrollExtent,
              duration: Duration(seconds: 2),
              curve: Curves.fastOutSlowIn,
            );
          }

          String commentID = DateTime.now().millisecondsSinceEpoch.toString();
          setState(() {
            //add comments to firestore
            FirebaseFirestore.instance.collection("products")
                .doc(widget.prodID)
                .collection("comments")
                .doc(commentID)
                .set(
                {
                  'commentID' : commentID,
                  'publishedDate' : DateTime.now(),
                  'userName': respawn.sharedPreferences.getString(respawn.userName),
                  'profilePic': respawn.sharedPreferences.getString(respawn.userAvatarUrl),
                  'comment': commentController.text,
                }).then((value){
              flushbar(color: Colors.teal,title: "Review", msg:"Review added successfully!",duration: Duration(seconds: 2));
              // Fluttertoast.showToast(msg: "New comment added successfully.");
              // final snack = SnackBar(content: Text("New Address added successfully."));
              // scaffoldKey.currentState.showSnackBar(snack);
              FocusScope.of(context).requestFocus(FocusNode());
              formKey.currentState.reset();
            });
          });

          print(commentController.text);
          commentController.clear();
          FocusScope.of(context).unfocus();
        } else {
          print("Not validated");
        }
      },
      formKey: formKey,
      commentController: commentController,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
    );
  }

  //remove comments function...

  removeComment(String productID, {String commentID})
  {
    // List tempCartList = respawn.sharedPreferences.getStringList(respawn.userCartList);
    // tempCartList.remove(shortInfoAsId);

    FirebaseFirestore.instance.collection("products")
        .doc(productID).collection("comments").doc()
        .delete().then((v){

      flushbar(color: Colors.deepOrange,title: "Info", msg:"Review Removed Successfully!.",duration: Duration(seconds: 1));

      // Fluttertoast.showToast(msg: "Item Removed Successfully.");
      //
      // respawn.sharedPreferences.setStringList(respawn.userCartList, tempCartList);

    });
  }

  //flushbar...
  flushbar({Color color, String msg, String title, Duration duration, Icon icon}){
    return Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: color,
      // boxShadows: [BoxShadow(color: Colors.redAccent, offset: Offset(0.0, 2.0), blurRadius: 3.0)],
      // backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
      isDismissible: true,
      duration: duration,
      // animationDuration: Duration(milliseconds: 1200),
      icon: Icon(
        Icons.info_outline_rounded,
        color: Colors.white,
      ),
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.blueGrey,
      titleText: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: Text(
        msg,
        style: TextStyle(fontSize: 15.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
      ),
    )..show(context);
  }
}
