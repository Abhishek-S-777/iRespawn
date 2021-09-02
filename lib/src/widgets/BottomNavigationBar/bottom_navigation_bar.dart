import 'package:flutter/material.dart';
import 'package:irespawn/src/Services/AuthenticationService.dart';
import 'package:irespawn/src/themes/light_color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/widgets/BottomNavigationBar/bottom_curved_Painter.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int) onIconPresedCallback;
  CustomBottomNavigationBar({Key key, this.onIconPresedCallback})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {

  final AuthenticationService _authservice = AuthenticationService();

  void toastMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        // timeInSecForIosWeb: 2,
        timeInSecForIos: 2,
        fontSize: 16.0
    );
  }

  int _selectedIndex = 0;

  AnimationController _xController;
  AnimationController _yController;
  @override
  void initState() {
    _xController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);
    _yController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);

    Listenable.merge([_xController, _yController]).addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _xController.value =
        _indexToPosition(_selectedIndex) / MediaQuery.of(context).size.width;
    _yController.value = 1.0;

    super.didChangeDependencies();
  }

  double _indexToPosition(int index) {
    // Calculate button positions based off of their
    // index (works with `MainAxisAlignment.spaceAround`)
    const buttonCount = 5.0;
    final appWidth = MediaQuery.of(context).size.width;
    final buttonsWidth = _getButtonContainerWidth();
    final startX = (appWidth - buttonsWidth) / 2;
    return startX +
        index.toDouble() * buttonsWidth / buttonCount +
        buttonsWidth / (buttonCount * 2.0);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }

  Widget _icon(IconData icon, bool isEnable, int index) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(50)),
        onTap: () async {
          //adding it newly 20-04-2021
          if(index==4){
            await _authservice.signOut().then((result) {
              toastMessage('User Logged out successfully..');
              Navigator.pushNamed(context, 'Login');
              // Navigator.of(context).pop(true);
            });
          }
          _handlePressed(index);
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          alignment: isEnable ? Alignment.topCenter : Alignment.center,
          child: AnimatedContainer(
              height: isEnable ? 30 : 20,
              duration: Duration(milliseconds: 200),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: isEnable ? LightColor.orange : Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: isEnable ? Color(0xfffeece2) : Colors.white,
                      blurRadius: 10,
                      spreadRadius: 5,
                      offset: Offset(5, 5),
                    ),
                  ],
                  shape: BoxShape.circle),
              child: Opacity(
                opacity: isEnable ? _yController.value : 1,
                child: Icon(icon,
                    color: isEnable
                        ? LightColor.background
                        : Theme.of(context).iconTheme.color),
              )),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    final inCurve = ElasticOutCurve(0.38);
    return CustomPaint(
      painter: BackgroundCurvePainter(
          _xController.value * MediaQuery.of(context).size.width,
          Tween<double>(
            begin: Curves.easeInExpo.transform(_yController.value),
            end: inCurve.transform(_yController.value),
          ).transform(_yController.velocity.sign * 0.5 + 0.5),
          Theme.of(context).backgroundColor),
    );
  }

  double _getButtonContainerWidth() {
    double width = MediaQuery.of(context).size.width;
    if (width > 400.0) {
      width = 400.0;
    }
    return width;
  }

  void _handlePressed(int index) {
    if (_selectedIndex == index || _xController.isAnimating) return;
    widget.onIconPresedCallback(index);
    setState(() {
      _selectedIndex = index;
    });

    _yController.value = 1.0;
    _xController.animateTo(
        _indexToPosition(index) / MediaQuery.of(context).size.width,
        duration: Duration(milliseconds: 620));
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        _yController.animateTo(1.0, duration: Duration(milliseconds: 1000));
      },
    );
    _yController.animateTo(0.0, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    final height = 60.0;
    return SafeArea(
      child: Container(
        width: appSize.width,
        height: 60,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              width: appSize.width,
              height: height - 10,
              child: _buildBackground(),
            ),
            Positioned(
              left: (appSize.width - _getButtonContainerWidth()) / 2,
              top: 0,
              width: _getButtonContainerWidth(),
              height: height,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _icon(Icons.home, _selectedIndex == 0, 0),
                  _icon(Icons.miscellaneous_services_sharp, _selectedIndex == 1, 1),
                  _icon(Icons.shopping_cart_outlined, _selectedIndex == 2, 2),
                  _icon(Icons.favorite_border, _selectedIndex == 3, 3),
                  _icon(Icons.logout, _selectedIndex == 4, 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
