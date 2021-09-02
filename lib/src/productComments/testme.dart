import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/model/commentmodel.dart';
import 'package:irespawn/src/productComments/productcomment.dart';
import 'package:flutter/material.dart';
import 'package:irespawn/src/widgets/loadingWidget.dart';

class TestMe extends StatefulWidget {
  final ScrollController draggable;
  final String prodID;
  TestMe({this.draggable,this.prodID});
  @override
  _TestMeState createState() => _TestMeState();
}

class _TestMeState extends State<TestMe> {


  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();
  List filedata = [
    {
      'name': 'Chuks Okwuenu',
      'pic': 'https://chuksokwuenu.com/img/pic.jpg',
      'message': 'I love to code'
    },
    {
      'name': 'Biggi Man',
      'pic':
          'https://event.chuksokwuenu.com/images/IMG_20200522_122853_521~2.jpg',
      'message': 'Very cool'
    },
    {
      'name': 'Tunde Martins',
      'pic':
          'https://lh3.googleusercontent.com/gXjdVvgHcgJphBYJ_yxPyQF7gf2k4Ze4wYUj7lA9ObWYIUNBeD16H3RF6ylEGrjpbmBNVlcuSSkMa3NN=w768-h768-n-o-v1',
      'message': 'Very cool'
    },
    {
      'name': 'Biggi Man',
      'pic': 'https://picsum.photos/300/30',
      'message': 'Very cool'
    },
  ];

  // Widget commentChild(CommentModel model) {
  //   return ListView(
  //     controller: widget.draggable,
  //     children: [
  //       for (var i = 0; i < data.length; i++)
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
  //           child: ListTile(
  //             leading: GestureDetector(
  //               onTap: () async {
  //                 // Display the image in large form.
  //                 print("Comment Clicked");
  //               },
  //               child: Container(
  //                 height: 50.0,
  //                 width: 50.0,
  //                 decoration: new BoxDecoration(
  //                     color: Colors.blue,
  //                     borderRadius: new BorderRadius.all(Radius.circular(50))),
  //                 child: CircleAvatar(
  //                     radius: 50,
  //                     backgroundImage: NetworkImage(data[i]['pic'])),
  //               ),
  //             ),
  //             title: Text(
  //               data[i]['name'],
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             ),
  //             subtitle: Text(data[i]['message']),
  //           ),
  //         )
  //     ],
  //   );
  // }

  // Backup code if anything goes wrong....
  Widget commentChild(data) {
    return ListView(
      controller: widget.draggable,
      children: [
        for (var i = 0; i < data.length; i++)
          Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
            child: ListTile(
              leading: GestureDetector(
                onTap: () async {
                  // Display the image in large form.
                  print("Comment Clicked");
                },
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                  child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(data[i]['pic'])),
                ),
              ),
              title: Text(
                data[i]['name'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(data[i]['message']),
            ),
          )
      ],
    );
  }

  //
  // @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //       child: StreamBuilder<QuerySnapshot>(
  //         // stream: FirebaseFirestore.instance.collection("products").limit(15).orderBy("publishedDate", descending: true).snapshots(),
  //         stream: FirebaseFirestore.instance.collection("products").doc(widget.prodID).collection("comments").snapshots(),
  //         builder: (context, dataSnapshot)
  //         {
  //           return !dataSnapshot.hasData
  //               ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
  //               : ListView.builder(
  //             itemBuilder: (context, index)
  //             {
  //               CommentModel model = CommentModel.fromJson(dataSnapshot.data.docs[index].data());
  //               return sourceInfo(model, context);
  //             },
  //             itemCount: dataSnapshot.data.docs.length,
  //           );
  //         },
  //       ),
  //
  //   )
  //     CommentBox(
  //     userImage: respawn.sharedPreferences.getString(respawn.userAvatarUrl),
  //     child: commentChild(filedata),
  //     labelText: 'Write a comment...',
  //     errorText: 'Comment cannot be blank',
  //     withBorder: false,
  //     sendButtonMethod: () {
  //       if (formKey.currentState.validate()) {
  //         String commentID = DateTime.now().millisecondsSinceEpoch.toString();
  //         //add comments to firestore
  //         FirebaseFirestore.instance.collection("products")
  //             .doc(widget.prodID)
  //             .collection("comments")
  //             .doc(commentID)
  //             .set(
  //           {
  //             'commentID' : commentID,
  //             'userName': respawn.sharedPreferences.getString(respawn.userName),
  //             'profilePic': respawn.sharedPreferences.getString(respawn.userAvatarUrl),
  //             'comment': commentController.text,
  //           }).then((value){
  //           Fluttertoast.showToast(msg: "New comment added successfully.");
  //           // final snack = SnackBar(content: Text("New Address added successfully."));
  //           // scaffoldKey.currentState.showSnackBar(snack);
  //           FocusScope.of(context).requestFocus(FocusNode());
  //           formKey.currentState.reset();
  //         });
  //         print(commentController.text);
  //         setState(() {
  //           var value = {
  //             'name': respawn.sharedPreferences.getString(respawn.userName),
  //             'pic': respawn.sharedPreferences.getString(respawn.userAvatarUrl),
  //             'message': commentController.text
  //           };
  //           filedata.insert(0, value);
  //         });
  //         commentController.clear();
  //         FocusScope.of(context).unfocus();
  //       } else {
  //         print("Not validated");
  //       }
  //     },
  //     formKey: formKey,
  //     commentController: commentController,
  //     backgroundColor: Colors.grey,
  //     textColor: Colors.white,
  //     sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
  //   );
  // }


  //Backup build function...
  @override
  Widget build(BuildContext context) {
    return CommentBox(
      userImage: respawn.sharedPreferences.getString(respawn.userAvatarUrl),
      child: commentChild(filedata),
      labelText: 'Write a comment...',
      errorText: 'Comment cannot be blank',
      withBorder: false,
      sendButtonMethod: () {
        if (formKey.currentState.validate()) {
          String commentID = DateTime.now().millisecondsSinceEpoch.toString();
          //add comments to firestore
          FirebaseFirestore.instance.collection("products")
              .doc(widget.prodID)
              .collection("comments")
              .doc(commentID)
              .set(
              {
                'commentID' : commentID,
                'userName': respawn.sharedPreferences.getString(respawn.userName),
                'profilePic': respawn.sharedPreferences.getString(respawn.userAvatarUrl),
                'comment': commentController.text,
              }).then((value){
            Fluttertoast.showToast(msg: "New comment added successfully.");
            // final snack = SnackBar(content: Text("New Address added successfully."));
            // scaffoldKey.currentState.showSnackBar(snack);
            FocusScope.of(context).requestFocus(FocusNode());
            formKey.currentState.reset();
          });
          print(commentController.text);
          setState(() {
            var value = {
              'name': respawn.sharedPreferences.getString(respawn.userName),
              'pic': respawn.sharedPreferences.getString(respawn.userAvatarUrl),
              'message': commentController.text
            };
            filedata.insert(0, value);
          });
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
}
