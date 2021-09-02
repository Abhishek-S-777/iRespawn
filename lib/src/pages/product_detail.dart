
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/Counters/cartitemcounter.dart';
import 'package:irespawn/src/Counters/wishlisttitemcounter.dart';
import 'package:irespawn/src/model/item.dart';
import 'package:irespawn/src/productComments/testme.dart';
import 'package:irespawn/src/productComments/testmecopy.dart';
import 'package:irespawn/src/themes/light_color.dart';
import 'package:irespawn/src/themes/theme.dart';
import 'package:irespawn/src/widgets/navigation_home_screen.dart';
import 'package:irespawn/src/widgets/title_text.dart';
import 'package:irespawn/src/widgets/extentions.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:provider/provider.dart';


class ProductDetailPage extends StatefulWidget {

  final ItemModel itemModel;
  ProductDetailPage({this.itemModel});
  // ProductDetailPage({Key key}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {

  ScrollController sController;
  bool fabIsVisible = true;

  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    //For hiding the cart button on default and make it visible on scoll forward...
    sController = ScrollController();
    handleScroll();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  void showFloationButton() {
    setState(() {
      fabIsVisible = true;
    });
  }

  void hideFloationButton() {
    setState(() {
      fabIsVisible = false;
    });
  }

  void handleScroll() async {
    sController.addListener(() {
      if (sController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        hideFloationButton();
      }
      if (sController.position.userScrollDirection ==
          ScrollDirection.forward) {
        showFloationButton();
      }
    });
  }


  @override
  void dispose() {
    controller.dispose();
    sController.removeListener(() {});
    super.dispose();
  }

  bool isLiked = false;

  bool isSizeSelected1=false;
  bool isSizeSelected2=true;
  bool isSizeSelected3=false;
  bool isSizeSelected4=false;

  bool isColorSelected1=false;
  bool isColorSelected2=false;
  bool isColorSelected3=true;
  bool isColorSelected4=false;
  bool isColorSelected5=false;

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: 15,
            padding: 12,
            isOutLine: true,
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => NavigationHomeScreen());
              Navigator.push(context, route);
              // Navigator.of(context).pop();
            },
          ),
          _icon(isLiked || respawn.sharedPreferences.getStringList(respawn.userWishList).contains(widget.itemModel.shortInfo) ? Icons.favorite : Icons.favorite_border ,
              color: isLiked || respawn.sharedPreferences.getStringList(respawn.userWishList).contains(widget.itemModel.shortInfo) ? LightColor.red : LightColor.red,
              size: 15,
              padding: 12,
              isOutLine: true,
              onPressed: () {
                 setState(() {
                   isLiked = !isLiked;
                 });
                 if(isLiked==true){
                   checkItemInWishlist(widget.itemModel.shortInfo,context);
                 }
                 else if(isLiked==false){
                   removeItemFromUserWishlist(widget.itemModel.shortInfo);
                 }
          }),
        ],
      ),
    );
  }

  Widget _icon(
    IconData icon, {
    Color color = LightColor.iconColor,
    // Color color = Colors.red,
    double size = 20,
    double padding = 10,
    bool isOutLine = false,
    Function onPressed,
  }) {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(padding),
      // margin: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: isOutLine ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
            isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Color(0xfff8f8f8),
              blurRadius: 5,
              spreadRadius: 10,
              offset: Offset(5, 5)),
        ],
      ),
      child: Icon(icon, color: color, size: size),
    ).ripple(() {
      if (onPressed != null) {
        onPressed();
      }
    }, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _productImage() {
    return AnimatedBuilder(
      builder: (context, child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: animation.value,
          child: child,
        );
      },
      animation: animation,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         // image:NetworkImage(widget.itemModel.thumbnailUrl),
            //         // fit: BoxFit.cover
            //     )
            // ),
          ),
          // TitleText(
          //   text: "AIR",
          //   fontSize: 160,
          //   color: LightColor.lightGrey,
          // ),
          Image.network(widget.itemModel.thumbnailUrl)
          // Image.asset('assets/show_1.png')
        ],
      ),
    );
  }

  // Widget _categoryWidget() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 0),
  //     width: AppTheme.fullWidth(context),
  //     height: 80,
  //     child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children:
  //             AppData.showThumbnailList.map((x) => _thumbnail(x)).toList()),
  //   );
  // }

  ////product thumbnail for changing the images...

  // Widget _thumbnail(String image) {
  //   return AnimatedBuilder(
  //     animation: animation,
  //     //  builder: null,
  //     builder: (context, child) => AnimatedOpacity(
  //       opacity: animation.value,
  //       duration: Duration(milliseconds: 500),
  //       child: child,
  //     ),
  //     child: Container(
  //       margin: EdgeInsets.symmetric(horizontal: 10),
  //       child: Container(
  //         height: 40,
  //         width: 50,
  //         decoration: BoxDecoration(
  //           border: Border.all(
  //             color: LightColor.grey,
  //           ),
  //           borderRadius: BorderRadius.all(Radius.circular(13)),
  //           // color: Theme.of(context).backgroundColor,
  //         ),
  //         child: Image.asset(image),
  //       ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(13))),
  //     ),
  //   );
  // }

  Widget _detailWidget() {
    return SafeArea(
      child: DraggableScrollableSheet(
        maxChildSize: .8,
        initialChildSize: .53,
        minChildSize: .53,
        builder: (context, scrollController) {
          return Container(
            padding: AppTheme.padding.copyWith(bottom: 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                // color: Colors.grey.shade200
                color: Colors.white

            ),
            child: SingleChildScrollView(
              controller: scrollController,
              // controller: sController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 5),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                          color: LightColor.iconColor,
                          // color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TitleText(text: widget.itemModel.title, fontSize: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TitleText(
                                  text: "\₹ ",
                                  fontSize: 18,
                                  color: LightColor.red,
                                ),
                                TitleText(
                                  text: widget.itemModel.price.toString(),
                                  fontSize: 25,
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.star,
                                    color: LightColor.yellowColor, size: 17),
                                Icon(Icons.star,
                                    color: LightColor.yellowColor, size: 17),
                                Icon(Icons.star,
                                    color: LightColor.yellowColor, size: 17),
                                Icon(Icons.star,
                                    color: LightColor.yellowColor, size: 17),
                                Icon(Icons.star_border, size: 17),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _availableSize(),
                  SizedBox(
                    height: 20,
                  ),
                  _availableColor(),
                  SizedBox(
                    height: 20,
                  ),
                  _description(),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: TitleText(
                      text: "User Reviews",
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(
                    height: 17,
                  ),
                  Container(height: MediaQuery.of(context).size.height * 0.36,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 17),
                        child: TestMeNew(draggable: scrollController, prodID: widget.itemModel.productID,),
                      )
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _availableSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: TitleText(
            text: "Available Sizes",
            fontSize: 17,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _sizeWidget("15", isSizeSelected1 , onPressed: (){ print("isSelected1 value outside setstate  is"+isSizeSelected1.toString()); setState(() {
              print("isSelected1 value inside setstate  is"+isSizeSelected1.toString());
              // isSelected1 == false ? isSelected1=true : isSelected1 = false;
              isSizeSelected1=!isSizeSelected1;
              if(isSizeSelected1==true){
                isSizeSelected2=false;
                isSizeSelected3=false;
                isSizeSelected4=false;
              }

            }); } ),
            _sizeWidget("17", isSizeSelected2, onPressed: (){ print("17 pressed"); setState(() {
              isSizeSelected2 = !isSizeSelected2;
              if(isSizeSelected2==true){
                isSizeSelected1=false;
                isSizeSelected3=false;
                isSizeSelected4=false;
              }
            }); } ),
            _sizeWidget("21", isSizeSelected3, onPressed: (){ setState(() {
              isSizeSelected3 = !isSizeSelected3;
              if(isSizeSelected3==true){
                isSizeSelected1=false;
                isSizeSelected2=false;
                isSizeSelected4=false;
              }
            }); } ),
            _sizeWidget("24", isSizeSelected4, onPressed: (){ setState(() {
              isSizeSelected4 = !isSizeSelected4;
              if(isSizeSelected4==true){
                isSizeSelected1=false;
                isSizeSelected2=false;
                isSizeSelected3=false;
              }
            }); }),
          ],
        )
      ],
    );
  }

  Widget _sizeWidget(String text, bool isSelected,
      {Color color = LightColor.iconColor, Function onPressed}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: !isSelected ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
            isSelected ? LightColor.orange : Theme.of(context).backgroundColor,
      ),
      child: TitleText(
        text: text,
        fontSize: 16,
        color: isSelected ? LightColor.background : LightColor.titleTextColor,
      ),
    ).ripple(() {if (onPressed != null) {
      onPressed();
    }}, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _availableColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: TitleText(
            text: "Available Colors",
            fontSize: 17,
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _colorWidget(LightColor.yellowColor, isColorSelected1 , onPressed: (){setState(() {
              isColorSelected1=!isColorSelected1;
              if(isColorSelected1==true){
                isColorSelected2=false;
                isColorSelected3=false;
                isColorSelected4=false;
                isColorSelected5=false;
              }
            }); } ),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.lightBlue, isColorSelected2 , onPressed: (){setState(() {
              isColorSelected2=!isColorSelected2;
              if(isColorSelected2==true){
                isColorSelected1=false;
                isColorSelected3=false;
                isColorSelected4=false;
                isColorSelected5=false;
              }
            }); } ),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.black, isColorSelected3 , onPressed: (){setState(() {
              isColorSelected3=!isColorSelected3;
              if(isColorSelected3==true){
                isColorSelected1=false;
                isColorSelected2=false;
                isColorSelected4=false;
                isColorSelected5=false;
              }
            }); } ),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.red, isColorSelected4 , onPressed: (){setState(() {
              isColorSelected4=!isColorSelected4;
              if(isColorSelected4==true){
                isColorSelected1=false;
                isColorSelected2=false;
                isColorSelected3=false;
                isColorSelected5=false;
              }
            }); } ),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.skyBlue, isColorSelected5 , onPressed: (){setState(() {
              isColorSelected5=!isColorSelected5;
              if(isColorSelected5==true){
                isColorSelected1=false;
                isColorSelected2=false;
                isColorSelected3=false;
                isColorSelected4=false;
              }
            }); } ),
          ],
        )
      ],
    );
  }

  Widget _colorWidget(Color color, bool isSelected, {Function onPressed}) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: color.withAlpha(150),
      child: isSelected
          ? Icon(
              Icons.check_circle,
              color: color,
              size: 18,
            )
          : CircleAvatar(radius: 7, backgroundColor: color),
    ).ripple(() {if (onPressed != null) {
      onPressed();
    }});
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: TitleText(
            text: "Description",
            fontSize: 17,
          ),
        ),
        SizedBox(height: 20),
        Text(widget.itemModel.longDescription),
      ],
    );
  }


  void checkItemInCart(String shortInfoAsID, BuildContext context)
  {

    respawn.sharedPreferences.getStringList(respawn.userCartList).contains(shortInfoAsID)
        ? Fluttertoast.showToast(msg: "Item is already in Cart.")
        : addItemToCart(shortInfoAsID, context);
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

  FloatingActionButton _flotingButton() {
    return FloatingActionButton(
      onPressed: () {
        checkItemInCart(widget.itemModel.shortInfo, context);
      },
      // backgroundColor: LightColor.orange,
      backgroundColor: Colors.purpleAccent,
      // backgroundColor: Colors.greenAccent.shade400,
      // backgroundColor: Colors.blueAccent,
      child: Icon(
          Icons.shopping_basket,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 77),
          child: _flotingButton(),
        ),
        duration: Duration(milliseconds: 100),
        opacity: fabIsVisible ? 1: 0,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xfffbfbfb),
              Color(0xfff7f7f7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _appBar(),
                  _productImage(),
                  // _categoryWidget(),
                ],
              ),
              _detailWidget(),

            ],
          ),
        ),
      ),
    );
  }

  //For adding items to wishlist..
  void checkItemInWishlist(String shortInfoAsID, BuildContext context)
  {

    if(respawn.sharedPreferences.getStringList(respawn.userWishList).contains(shortInfoAsID)){
      flushbar(color: Colors.blueAccent,title: "Info", msg:"Item already in Cart.",duration: Duration(seconds: 1),icon: Icon(Icons.info_outline_rounded, color: Colors.white,));
      // Fluttertoast.showToast(msg: "Item is already in Cart.");
    }
    else if (respawn.sharedPreferences.getStringList(respawn.userWishList).length-1 > 8){
      flushbar(color: Colors.blueAccent,title: "Info", msg:"Cart cannot have more than 9 items",duration: Duration(seconds: 2),icon: Icon(Icons.info_outline_rounded, color: Colors.white,));
      // Fluttertoast.showToast(msg: "Cart cannot have more than 9 items");
    }
    else{
      addItemToWishlist(shortInfoAsID, context);
    }

  }


  addItemToWishlist(String shortInfoAsID, BuildContext context)
  {
    List tempWishList = respawn.sharedPreferences.getStringList(respawn.userWishList);
    tempWishList.add(shortInfoAsID);
    FirebaseFirestore.instance.collection(respawn.collectionUser)
        .doc(respawn.sharedPreferences.getString(respawn.userUID))
        .update({
      respawn.userWishList: tempWishList,
    }).then((v){
      flushbar(color: Colors.green,title: "Info", msg:"Item Added to Wishlist Successfully",duration: Duration(seconds: 1),icon: Icon(Icons.check_circle_outline, color: Colors.white,));

      respawn.sharedPreferences.setStringList(respawn.userWishList, tempWishList);

      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });
  }


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

  beginBuildingWishlist()
  {
    return SliverToBoxAdapter(
      child: Card(
        color: Theme.of(context).primaryColor.withOpacity(0.5),
        child: Container(
          height: 100.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_emoticon, color: Colors.white,),
              Text("Your Wishlist is empty."),
              Text("Start adding items to your wishlist."),
            ],
          ),
        ),
      ),
    );
  }



  //remove the item from user wishlist....
  removeItemFromUserWishlist(String shortInfoAsId)
  {
    // setState(() {
    //   isLiked= false;
    // });
    List tempWishList = respawn.sharedPreferences.getStringList(respawn.userWishList);
    tempWishList.remove(shortInfoAsId);

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
        duration: Duration(milliseconds: 1000),
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
          "Item removed from WishList Successfully!",
          style: TextStyle(fontSize: 15.0, color: Colors.white, fontFamily: "ShadowsIntoLightTwo"),
        ),
      )..show(context);

      respawn.sharedPreferences.setStringList(respawn.userWishList, tempWishList);


      Provider.of<WishlistItemCounter>(context, listen: false).displayResult();
      // Provider.of<CartItemCounter>(context, listen: false).displayResult();

      setState(() {
        isLiked=false;
      });

    });
  }


}

