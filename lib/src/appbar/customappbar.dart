import 'package:flutter/material.dart';
import 'package:irespawn/src/widgets/navigation_home_screen.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  CustomAppBar(
      this.title,
      { Key key,}) : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // return AppBar(
    //   title: Text(
    //     title,
    //     style: TextStyle(color: Colors.black),
    //   ),
    //   backgroundColor: Colors.white,
    //   leading: IconButton(
    //     icon: Icon(Icons.sort),
    //     // onPressed: () => Navigator.pop(context),
    //     onPressed: () => NavigationHomeScreen(),
    //     color: Colors.black,
    //   ),
    // );

    ////another codeee
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      automaticallyImplyLeading: true,
    );
  }
}