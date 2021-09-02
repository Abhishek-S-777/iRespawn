import 'package:flutter/foundation.dart';
import 'package:irespawn/src/constants/config.dart';

class CartItemCounter extends ChangeNotifier
{
  int _counter = respawn.sharedPreferences.getStringList(respawn.userCartList).length-1;
  int get count => _counter;

  Future<void> displayResult() async
  {
    int _counter = respawn.sharedPreferences.getStringList(respawn.userCartList).length-1;

    await Future.delayed(const Duration(milliseconds: 100), (){
      notifyListeners();
    });
  }
}