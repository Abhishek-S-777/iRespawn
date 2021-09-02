import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:irespawn/src/Admin/adminUpdateonepointone.dart';
import 'package:irespawn/src/model/item.dart';
import 'package:irespawn/src/widgets/loadingWidget.dart';
import 'package:irespawn/src/widgets/searchBox.dart';

double width;
class UpdateProducts extends StatefulWidget {
  const UpdateProducts({Key key}) : super(key: key);

  @override
  _UpdateProductsState createState() => _UpdateProductsState();
}

class _UpdateProductsState extends State<UpdateProducts> {

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
        body:SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverPersistentHeader(pinned:true,delegate: SearchBoxDelegate()),
              SliverToBoxAdapter(
                child: Container(
                  // height: MediaQuery.of(context).size.height - 210,
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    dragStartBehavior: DragStartBehavior.down,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // _search(),
                        // _search1(),
                        // ProductList(products: productsnew,),
                        // _categoryWidget(),
                        // _productWidget(),
                      ],
                    ),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                // stream: FirebaseFirestore.instance.collection("products").limit(15).orderBy("publishedDate", descending: true).snapshots(),
                stream: FirebaseFirestore.instance.collection("products").orderBy("publishedDate", descending: true).snapshots(),
                builder: (context, dataSnapshot)
                {
                  return !dataSnapshot.hasData
                      ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
                      : SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 2,
                    staggeredTileBuilder: (c) => StaggeredTile.fit(2),
                    itemBuilder: (context, index)
                    {
                      ItemModel model = ItemModel.fromJson(dataSnapshot.data.docs[index].data());
                      return sourceInfo(model, context);
                    },
                    itemCount: dataSnapshot.data.docs.length,
                  );
                },
              ),
            ],
          ),
        )

    );
  }

  //This code is for delete and updating the products..
  //logic first we display all the products.. and then when clicked on each product
  //we display all its details in an editable textview and then
  //two floating action buttons...one for update and one for delete....

  //product card widget....
  Widget sourceInfo(ItemModel model, BuildContext context,
      {Color background, removeCartFunction}) {
    return SafeArea(
      child: InkWell(
        onTap: ()
        {
          Route route = MaterialPageRoute(builder: (c) => UpdateProductOnePointOne(model));
          Navigator.push(context, route);
        },
        splashColor: Colors.orangeAccent,
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Container(
            height: 190.0,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Image.network(model.thumbnailUrl, width: 120.0, height: 120.0,),
                SizedBox(width: 4.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30.0,),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(model.title, style: TextStyle(color: Colors.black, fontSize: 17.0),),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5.0,),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(model.shortInfo, style: TextStyle(color: Colors.black54, fontSize: 12.0),),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.pink,
                            ),
                            alignment: Alignment.topLeft,
                            width: 40.0,
                            height: 43.0,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "50%", style: TextStyle(fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.normal),
                                  ),
                                  Text(
                                    "OFF", style: TextStyle(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 0.0),
                                child: Row(
                                  children: [
                                    Text(
                                      r"Origional Price: ₹ ",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    Text(
                                      (model.price + model.price).toString(),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      r"New Price: ",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      "₹ ",
                                      style: TextStyle(color: Colors.red, fontSize: 16.0),
                                    ),
                                    Text(
                                      (model.price).toString(),
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),

                      Flexible(
                        child: Container(),
                      ),

                      // //to implement the cart item aad/remove feature
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: removeCartFunction == null
                      //       ? IconButton(
                      //     icon: Icon(Icons.add_shopping_cart, color: Colors.pinkAccent,),
                      //     onPressed: ()
                      //     {
                      //       checkItemInCart(model.shortInfo, context);
                      //     },
                      //   )
                      //       : IconButton(
                      //     icon: Icon(Icons.delete, color: Colors.pinkAccent,),
                      //     onPressed: ()
                      //     {
                      //       removeCartFunction();
                      //       Route route = MaterialPageRoute(builder: (c) => MyHomePage());
                      //       Navigator.pushReplacement(context, route);
                      //     },
                      //   ),
                      // ),

                      Divider(
                        height: 5.0,
                        color: Colors.pink,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }





}
