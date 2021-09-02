
// import 'package:e_shop/Models/item.dart';
// import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/Admin/adminOrderCard.dart';
import 'package:irespawn/src/Counters/cartitemcounter.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/model/item.dart';
import 'package:irespawn/src/pages/home_page.dart';
import 'package:irespawn/src/pages/product_detail.dart';
import 'package:irespawn/src/themes/light_color.dart';
import 'package:irespawn/src/themes/theme.dart';
import 'package:irespawn/src/widgets/customAppBar.dart';
import 'package:irespawn/src/widgets/title_text.dart';
import 'package:provider/provider.dart';

// import '../Widgets/customAppBar.dart';



class SearchProduct extends StatefulWidget {
  @override
  _SearchProductState createState() => new _SearchProductState();
}



class _SearchProductState extends State<SearchProduct>
{
  Future<QuerySnapshot> docList;

  bool isHomePageSelected = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(bottom: PreferredSize(child: searchWidget(), preferredSize: Size(56.0, 56.0)),),
        body: FutureBuilder<QuerySnapshot>(
          future: docList,
          builder: (context, snap)
          {
            return snap.hasData
                ? ListView.builder(
                    itemCount: snap.data.docs.length,
                    itemBuilder: (context, index)
                    {
                      ItemModel model = ItemModel.fromJson(snap.data.docs[index].data());
                      return sourceInfo(model, context);
                    },
                  )
                : Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text("Search for the items you want to purchase!",style: TextStyle(fontSize: 16),),
                  ),
                );
          },
        ),
      ),
    );
  }

  Widget searchWidget()
  {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 70.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.grey, Colors.grey],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.search, color: Colors.blueGrey,),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (value)
                  {
                    startSearching(value);
                  },
                  decoration: InputDecoration.collapsed(hintText: "Search here..."),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future startSearching(String query) async
  {
    docList = FirebaseFirestore.instance.collection("products")
        .where("shortInfo", isGreaterThanOrEqualTo: query)
        .get();
  }

  Widget sourceInfo(ItemModel model, BuildContext context,
      {Color background, removeCartFunction}) {
    return SafeArea(
      child: InkWell(
        onTap: ()
        {
          Route route = MaterialPageRoute(builder: (c) => ProductDetailPage(itemModel: model));
          // Route route = MaterialPageRoute(builder: (c) => ProductPage(itemModel: model));
          Navigator.push(context, route);
        },
        splashColor: Colors.orangeAccent,
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Container(
            height: 190.0,
            width: width,
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
                      //to implement the cart item aad/remove feature
                      Align(
                        alignment: Alignment.centerRight,
                        child: removeCartFunction == null
                            ? IconButton(
                          icon: Icon(Icons.add_shopping_cart, color: Colors.pinkAccent,),
                          onPressed: ()
                          {
                            checkItemInCart(model.shortInfo, context);
                          },
                        )
                            : IconButton(
                          icon: Icon(Icons.delete, color: Colors.pinkAccent,),
                          onPressed: ()
                          {
                            removeCartFunction();
                            Route route = MaterialPageRoute(builder: (c) => MyHomePage());
                            Navigator.pushReplacement(context, route);
                          },
                        ),
                      ),
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

  void checkItemInCart(String shortInfoAsID, BuildContext context)
  {
    if(respawn.sharedPreferences.getStringList(respawn.userCartList).contains(shortInfoAsID)){
      Fluttertoast.showToast(msg: "Item is already in Cart.");
    }
    else if (respawn.sharedPreferences.getStringList(respawn.userCartList).length-1 > 8){
      Fluttertoast.showToast(msg: "Cart cannot have more than 9 items");
    }
    else{
      addItemToCart(shortInfoAsID, context);
    }
  }


  addItemToCart(String shortInfoAsID, BuildContext context)
  {
    List tempCartList = respawn.sharedPreferences.getStringList(respawn.userCartList);
    tempCartList.add(shortInfoAsID);
    FirebaseFirestore.instance.collection(respawn.collectionUser)
        .doc(respawn.sharedPreferences.getString(respawn.userUID))
        .update({
      respawn.userCartList: tempCartList,
    }).then((v){
      Fluttertoast.showToast(msg: "Item Added to Cart Successfully.");

      respawn.sharedPreferences.setStringList(respawn.userCartList, tempCartList);

      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
  }

  //For the page design...
  Widget _appBar1()  {
    return Stack(
      children: [
        Container(
          child: Positioned(
            top: 10,
            left: 325,
            bottom: 10,
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart_rounded,
                color: Colors.black,
                size: 25,
              ),
              onPressed: () {

                print("You pressed cart");
                setState(() {
                  isHomePageSelected=false;
                });
                // Navigator.pushNamed(context, 'CartPage');
              },
            ),
          ),
        ),

        Container(
          padding: AppTheme.padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(),
              Positioned(
                // left: 100.0,
                  child: InkWell(
                    onTap: ()
                    {
                      setState(() {
                        isHomePageSelected=false;
                      });
                      // Navigator.pushNamed(context, 'CartPage');
                    },
                    child: Stack(
                      children: [
                        Icon(
                          Icons.brightness_1,
                          size: 20.0,
                          color: Colors.deepOrangeAccent ,
                        ),
                        Positioned(
                          left: 3.0,
                          // right: 4.0,
                          top: 3.0,
                          bottom: 4.0,
                          child: Consumer <CartItemCounter>(
                            builder: (context, counter, _ )
                            {
                              // print(Provider.of<CartItemCounter>(context).displayResult().toString());
                              return Center (
                                child: Text (
                                  // "00000",
                                  // counter.count.toString(),
                                  // Provider.of<CartItemCounter>(context).count.toString(),
                                  // Provider.of<CartItemCounter>(context).displayResult().toString(),
                                  (respawn.sharedPreferences.getStringList(respawn.userCartList).length-1).toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w500),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )
              )

            ],
          ),
        ),
      ],
    );
  }

  //title widget...
  Widget _title() {
    return Container(
        margin: AppTheme.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                InkWell(
                  onTap: (){
                    print("its mee textbox");
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: TitleText(
                      text: 'Search' ,
                      fontSize: 27,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                TitleText(
                  text: 'Products!',
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Spacer(),
            !isHomePageSelected
                ? InkWell(
              onTap: (){
                // removeAllItemFromUserCart();
                // print("You tapped clear all");
              },
              child: Container(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.delete_outline,
                  color: LightColor.orange,
                ),
              ),
            )
                : SizedBox()
          ],
        ));
  }

}

