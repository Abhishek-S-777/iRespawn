import 'package:irespawn/src/constants/config.dart';
// import 'package:irespawn/src/Store/cart.dart';
import 'package:irespawn/src/Counters/cartitemcounter.dart';
import 'package:flutter/material.dart';
import 'package:irespawn/src/themes/light_color.dart';
import 'package:provider/provider.dart';


class MyAppBar extends StatelessWidget with PreferredSizeWidget
{
  final PreferredSizeWidget bottom;
  MyAppBar({this.bottom});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      flexibleSpace: Container(
        decoration: new BoxDecoration(
          color: LightColor.lightGrey.withAlpha(100),
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
      title: Text(
        "Search Products",
        style: TextStyle(fontSize: 25.0, color: Colors.black.withOpacity(0.7), fontFamily: "Signatra"),
      ),
      bottom: bottom,
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.black,),
              onPressed: ()
              {
                // Route route = MaterialPageRoute(builder: (c) => CartPage());
                // Navigator.pushReplacement(context, route);
              },
            ),
            Positioned(
              left: 25.0,
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 20.0,
                    color: Colors.deepOrangeAccent,
                  ),
                  Positioned(
                    top: 3.0,
                    bottom: 4.0,
                    left: 4.0,
                    child: Consumer<CartItemCounter>(
                      builder: (context, counter, _)
                      {
                        return Text(
                          (respawn.sharedPreferences.getStringList(respawn.userCartList).length-1).toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }


  Size get preferredSize => bottom==null?Size(56,AppBar().preferredSize.height):Size(56, 80+AppBar().preferredSize.height);
}
