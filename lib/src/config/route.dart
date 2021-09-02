import 'package:flutter/material.dart';
import 'package:irespawn/src/Admin/adminHome.dart';
import 'package:irespawn/src/Admin/adminManageProducts.dart';
import 'package:irespawn/src/Admin/adminShiftOrders.dart';
import 'package:irespawn/src/Admin/adminlogin.dart';
import 'package:irespawn/src/model/wrapper.dart';
import 'package:irespawn/src/pages/cart.dart';
import 'package:irespawn/src/pages/home_page.dart';
import 'package:irespawn/src/pages/login.dart';
import 'package:irespawn/src/pages/mainPage.dart';
import 'package:irespawn/src/pages/product_detail.dart';
import 'package:irespawn/src/pages/shopping_cart_page.dart';
import 'package:irespawn/src/pages/signup.dart';
import 'package:irespawn/src/pages/test.dart';
import 'package:irespawn/src/widgets/capturecamera.dart';
import 'package:irespawn/src/widgets/navigation_home_screen.dart';
// import 'package:irespawn/src/pages/login.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{

      'signup': (context) => Signup(),
      'test':(context) => test(),
      'navidrawer':(context) => NavigationHomeScreen(),
      'Login': (context) => Login(),
      'AdminLogin1': (context) => AdminLogin1(),
      'AdminHome': (context) => AdminHome(),
      'ManageProducts': (context) => ManageProducts(),



      'AdminShiftOrders' : (context) => AdminShiftOrders(),
      'Shopping': (context) => ShoppingCartPage(),
      'Main': (context) => MainPage(),
      'Home': (context) => MyHomePage(),
      'detail': (context) => ProductDetailPage(),
      'CartPage': (context) => CartPage(),

      //making the first page as the wrapper page..
      // '/': (_) => Wrapper(),
      //// '/': (_) => MainPage() should not be included as the home property is specified in the main.dart file...
      // '/': (_) => MainPage(),
      // '/detail': (_) => ProductDetailPage()
    };
  }
}
