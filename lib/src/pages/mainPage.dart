import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/Counters/cartitemcounter.dart';
import 'package:irespawn/src/appbar/customappbar.dart';
import 'package:irespawn/src/custom_drawer/drawer_user_controller.dart';
import 'package:irespawn/src/custom_drawer/home_drawer.dart';
import 'package:irespawn/src/pages/cart.dart';
import 'package:irespawn/src/pages/home_page.dart';
import 'package:irespawn/src/pages/shopping_cart_page.dart';
import 'package:irespawn/src/pages/wishlist.dart';
import 'package:irespawn/src/themes/light_color.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/themes/theme.dart';
import 'package:irespawn/src/troubleshooting/instructions.dart';
import 'package:irespawn/src/widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:irespawn/src/widgets/navigation_home_screen.dart';
import 'package:irespawn/src/widgets/title_text.dart';
import 'package:irespawn/src/widgets/extentions.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isHomePageSelected = true;
  bool isServicePageSelected = false;
  bool isWishlistPageSelected = false;

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
                      text: isHomePageSelected ? 'Our' : isServicePageSelected? 'Our' : isWishlistPageSelected? 'Your' : 'Shopping' ,
                      fontSize: 27,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                TitleText(
                  text: isHomePageSelected ? 'Products' : isServicePageSelected? 'Services' : isWishlistPageSelected? 'Wishlist' : 'Cart',
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            Spacer(),
            !isHomePageSelected && !isServicePageSelected
                ? InkWell(
              onTap: (){
                if(isWishlistPageSelected==true){
                  removeAllItemsFromUserWishList();
                  Route route = MaterialPageRoute(builder: (c) => NavigationHomeScreen());
                  Navigator.push(context, route);
                }
                else{
                  removeAllItemsFromUserCart();
                  Route route = MaterialPageRoute(builder: (c) => NavigationHomeScreen());
                  Navigator.push(context, route);
                }

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

  //old button pressed for backup
  void onBottomIconPressed(int index) {
    if (index == 0) {
      setState(() {
        isHomePageSelected = true;
        isServicePageSelected= false;
        isWishlistPageSelected=false;
      });
    } else if(index == 2) {
      setState(() {
        isHomePageSelected = false;
        isServicePageSelected= false;
        isWishlistPageSelected=false;

      });
    }
    else if(index == 1){
      setState(() {
        isServicePageSelected = true;
        isHomePageSelected = false;
        isWishlistPageSelected=false;
      });
    }
    else if(index == 3){
      setState(() {
        isWishlistPageSelected=true;
        isHomePageSelected = false;
        isServicePageSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: Text(''),
      //     backgroundColor: Color(0xfff7f7f7),
      // ),
      // drawer: NavigationHomeScreen(),
      // appBar: CustomAppBar('why'),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                height: AppTheme.fullHeight(context) - 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xfffbfbfb),
                      // Color(0xff342f2f),
                      Color(0xfff7f7f7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // _appBar(),
                    _appBar1(),
                    _title(),
                    // NavigationHomeScreen(),
                    ////previously the container widget was an expanded widget, to set the height i changed it to container
                    ////any error or bug occurs change it back to Expanded widget and remove the height property....
                    Container(
                      // height: 640.0,
                      height: MediaQuery.of(context).size.height * 0.74,
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        switchInCurve: Curves.easeInToLinear,
                        switchOutCurve: Curves.easeOutBack,
                        child: isHomePageSelected ? MyHomePage() : isServicePageSelected? Instructions(isPaymentSuccess:false) : isWishlistPageSelected? WishlistPage() : Align(
                          alignment: Alignment.topCenter,
                          child: CartPage(),
                        ),
                        // child:isHomePageSelected
                        //     ? MyHomePage()
                        //     : Align(
                        //         alignment: Alignment.topCenter,
                        //         child: CartPage(),
                        //       ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CustomBottomNavigationBar(
                onIconPresedCallback: onBottomIconPressed,
              ),
            )
          ],
        ),
      ),
    );
  }

  // //Implementing remove all items from the user cart...
  removeAllItemsFromUserCart()
  {
    List tempCartList = respawn.sharedPreferences.getStringList(respawn.userCartList);
    int listLen = tempCartList.length;
    tempCartList.removeRange(1, listLen);

    FirebaseFirestore.instance.collection(respawn.collectionUser)
        .doc(respawn.sharedPreferences.getString(respawn.userUID))
        .update({
      respawn.userCartList: tempCartList,
    }).then((v){

      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.deepOrangeAccent.withOpacity(.9),
        boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)],
        // backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
        isDismissible: true,
        duration: Duration(seconds: 2),
        // animationDuration: Duration(milliseconds: 1200),
        icon: Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.blueGrey,
        titleText: Text(
          "Success",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
        ),
        messageText: Text(
          "All items removed from cart!",
          style: TextStyle(fontSize: 15.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
        ),
      )..show(context);


      // Fluttertoast.showToast(msg: "Item Removed Successfully.");

      respawn.sharedPreferences.setStringList(respawn.userCartList, tempCartList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
  }

  // //Implementing remove all items from the user wishlist...
  removeAllItemsFromUserWishList()
  {
    List tempWishList = respawn.sharedPreferences.getStringList(respawn.userWishList);
    int listLen = tempWishList.length;
    tempWishList.removeRange(1, listLen);

    FirebaseFirestore.instance.collection(respawn.collectionUser)
        .doc(respawn.sharedPreferences.getString(respawn.userUID))
        .update({
      respawn.userWishList: tempWishList,
    }).then((v){

      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        reverseAnimationCurve: Curves.decelerate,
        forwardAnimationCurve: Curves.elasticOut,
        backgroundColor: Colors.deepOrangeAccent.withOpacity(.9),
        boxShadows: [BoxShadow(color: Colors.red[800], offset: Offset(0.0, 2.0), blurRadius: 3.0)],
        // backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
        isDismissible: true,
        duration: Duration(seconds: 2),
        // animationDuration: Duration(milliseconds: 1200),
        icon: Icon(
          Icons.error_outline,
          color: Colors.white,
        ),
        showProgressIndicator: true,
        progressIndicatorBackgroundColor: Colors.blueGrey,
        titleText: Text(
          "Success",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
        ),
        messageText: Text(
          "All items removed from WishList!",
          style: TextStyle(fontSize: 15.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
        ),
      )..show(context);


      // Fluttertoast.showToast(msg: "Item Removed Successfully.");

      respawn.sharedPreferences.setStringList(respawn.userWishList, tempWishList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
  }

}
