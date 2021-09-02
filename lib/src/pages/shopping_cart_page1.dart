import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/Counters/cartitemcounter.dart';
import 'package:irespawn/src/Counters/totalMoney.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/model/data.dart';
import 'package:irespawn/src/model/product.dart';
import 'package:irespawn/src/themes/light_color.dart';
import 'package:irespawn/src/themes/theme.dart';
import 'package:irespawn/src/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:irespawn/src/Address/address.dart';

class ShoppingCartPage1 extends StatefulWidget {
  const ShoppingCartPage1({Key key}) : super(key: key);

  @override
  _ShoppingCartPage1State createState() => _ShoppingCartPage1State();
}

class _ShoppingCartPage1State extends State<ShoppingCartPage1> {
  double totalAmount;

  @override
  void initState(){
    super.initState();
    totalAmount=0;
    Provider.of<TotalAmount>(context,listen: false).display(0);
  }

  Widget _cartItems() {
    return Column(children: AppData.cartList.map((x) => _item(x)).toList());
  }

  Widget _item(Product model) {
    return Container(
      height: 80,
      child: Row(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.2,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 70,
                    width: 70,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                color: LightColor.lightGrey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: -20,
                  child: Image.asset(model.image),
                )
              ],
            ),
          ),
          Expanded(
              child: ListTile(
                  title: TitleText(
                    text: model.name,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      TitleText(
                        text: '\₹ ',
                        color: LightColor.red,
                        fontSize: 12,
                      ),
                      TitleText(
                        text: model.price.toString(),
                        fontSize: 14,
                      ),
                    ],
                  ),
                  //this displays amount of products chosen from the cart....
                  trailing: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: LightColor.lightGrey.withAlpha(150),
                        borderRadius: BorderRadius.circular(10)),
                    child: TitleText(
                      text: 'x${model.id}',
                      fontSize: 12,
                    ),
                  )))
        ],
      ),
    );
  }

  Widget _price() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TitleText(
          text: '${AppData.cartList.length} Items',
          color: LightColor.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        TitleText(
          text: '\$${getPrice()}',
          fontSize: 18,
        ),
      ],
    );
  }

  // double getPrice() {
  //   double price = 0;
  //   AppData.cartList.forEach((x) {
  //     price += x.price * x.id;
  //   });
  //   return price;
  // }  
  getPrice() {
    Consumer2<TotalAmount, CartItemCounter>(
      builder: (context, amountProvider, cartProvider, c) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: cartProvider.count == 0
                ? Container()
                : Text(
                    "Total Price: ₹ ${amountProvider.totalAmount.toString()}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500),
                  ),
          ),
        );
      },
    );
  }

  Widget _submitButton(BuildContext context) {
    return MaterialButton(
      elevation: 3,
        onPressed: ()
        {
          if(respawn.sharedPreferences.getStringList(respawn.userCartList).length == 1)
          {
            Fluttertoast.showToast(msg: "your Cart is empty.");
          }
          else
          {
            Route route = MaterialPageRoute(builder: (c) => Address(totalAmount: totalAmount));
            Navigator.pushReplacement(context, route);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: LightColor.orange,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          width: AppTheme.fullWidth(context) * .7,
          child: TitleText(
            text: 'Next',
            color: LightColor.background,
            fontWeight: FontWeight.w500,
          ),
        ));
  }

  //new build code....
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: AppTheme.padding,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _cartItems(),
                  Divider(
                    thickness: 1,
                    height: 70,
                  ),
                  _price(),
                  SizedBox(height: 30),
                  _submitButton(context),
                ],
              ),
            ),
          ),
        )
      ],

    );
  }
  // //old build code for backup if anything goes wrong.
  // @override
  // Widget build(BuildContext context) {
  //   return Container(
  //     padding: AppTheme.padding,
  //     child: SingleChildScrollView(
  //       child: Column(
  //         children: <Widget>[
  //           _cartItems(),
  //           Divider(
  //             thickness: 1,
  //             height: 70,
  //           ),
  //           _price(),
  //           SizedBox(height: 30),
  //           _submitButton(context),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
