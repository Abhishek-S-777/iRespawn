import 'package:flutter/foundation.dart';
import 'package:irespawn/src/constants/config.dart';

class WishlistItemCounter extends ChangeNotifier
{
  int _counter1 = respawn.sharedPreferences.getStringList(respawn.userWishList).length-1;
  int get count1 => _counter1;

  Future<void> displayResult() async
  {
    int _counter1 = respawn.sharedPreferences.getStringList(respawn.userWishList).length-1;

    await Future.delayed(const Duration(milliseconds: 100), (){
      notifyListeners();
    });
  }
}