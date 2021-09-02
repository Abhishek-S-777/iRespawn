// import 'package:e_shop/Widgets/customAppBar.dart';
// import 'package:e_shop/Widgets/myDrawer.dart';
// import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
// import 'package:e_shop/Store/storehome.dart';
import 'package:irespawn/src/model/item.dart';
// import 'package:irespawn/src/themes/app_theme.dart';
import 'package:irespawn/src/themes/theme.dart';
import 'package:irespawn/src/themes/light_color.dart';
import 'package:irespawn/src/widgets/customAppBar.dart';
import 'package:irespawn/src/widgets/extentions.dart';


class ProductPage extends StatefulWidget 
{
  final ItemModel itemModel;
  ProductPage({this.itemModel});
  
  @override
  _ProductPageState createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage> 
{
  int quantityOfItems = 1;
  
  @override
  Widget build(BuildContext context)
  {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        // appBar: MyAppBar(),
        // drawer: MyDrawer(),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(15.0),
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(widget.itemModel.thumbnailUrl),
                      ),
                      Container(
                        color: Colors.grey[300],
                        child: SizedBox(
                          height: 1.0,
                          width: double.infinity,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            widget.itemModel.title,
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),

                          Text(
                            widget.itemModel.longDescription,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),

                          Text(
                            "₹ " + widget.itemModel.price.toString(),
                            style: boldTextStyle,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Center(
                      child: InkWell(
                        // onTap: ()=> checkItemInCart(widget.itemModel.shortInfo, context),
                        child: Container(
                          decoration: new BoxDecoration(
                            gradient: new LinearGradient(
                              colors: [Colors.pink, Colors.lightGreenAccent],
                              begin: const FractionalOffset(0.0, 0.0),
                              end: const FractionalOffset(1.0, 0.0),
                              stops: [0.0, 1.0],
                              tileMode: TileMode.clamp,
                            ),
                          ),
                          width: MediaQuery.of(context).size.width - 40.0,
                          height: 50.0,
                          child: Center(
                            child: Text("Add to Cart", style: TextStyle(color: Colors.white),),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // //Custom App bar
  // Widget _appBar() {
  //   return Container(
  //     padding: AppTheme.padding,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: <Widget>[
  //         _icon(
  //           Icons.arrow_back_ios,
  //           color: Colors.black54,
  //           size: 15,
  //           padding: 12,
  //           isOutLine: true,
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //         _icon(isLiked ? Icons.favorite : Icons.favorite_border,
  //             color: isLiked ? LightColor.red : LightColor.lightGrey,
  //             size: 15,
  //             padding: 12,
  //             isOutLine: false,
  //             onPressed: () {
  //               setState(() {
  //                 isLiked = !isLiked;
  //               });
  //             }),
  //       ],
  //     ),
  //   );
  // }
  //
  // //Icon for custom app bar..
  // Widget _icon(
  //     IconData icon, {
  //       Color color = LightColor.iconColor,
  //       double size = 20,
  //       double padding = 10,
  //       bool isOutLine = false,
  //       Function onPressed,
  //     }) {
  //   return Container(
  //     height: 40,
  //     width: 40,
  //     padding: EdgeInsets.all(padding),
  //     // margin: EdgeInsets.all(padding),
  //     decoration: BoxDecoration(
  //       border: Border.all(
  //           color: LightColor.iconColor,
  //           style: isOutLine ? BorderStyle.solid : BorderStyle.none),
  //       borderRadius: BorderRadius.all(Radius.circular(13)),
  //       color:
  //       isOutLine ? Colors.transparent : Theme.of(context).backgroundColor,
  //       boxShadow: <BoxShadow>[
  //         BoxShadow(
  //             color: Color(0xfff8f8f8),
  //             blurRadius: 5,
  //             spreadRadius: 10,
  //             offset: Offset(5, 5)),
  //       ],
  //     ),
  //     child: Icon(icon, color: color, size: size),
  //   ).ripple(() {
  //     if (onPressed != null) {
  //       onPressed();
  //     }
  //   }, borderRadius: BorderRadius.all(Radius.circular(13)));
  // }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
