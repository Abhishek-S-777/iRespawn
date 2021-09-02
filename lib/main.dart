import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:irespawn/src/Counters/ItemQuantity.dart';
import 'package:irespawn/src/Counters/cartitemcounter.dart';
import 'package:irespawn/src/Counters/wishlisttitemcounter.dart';
import 'package:irespawn/src/Counters/changeAddresss.dart';
import 'package:irespawn/src/Counters/totalMoney.dart';
import 'package:irespawn/src/Services/AuthenticationService.dart';
import 'package:irespawn/src/config/route.dart';
import 'package:irespawn/src/model/user.dart';
import 'package:irespawn/src/model/wrapper.dart';
import 'package:irespawn/src/pages/login.dart';
import 'package:irespawn/src/pages/mainPage.dart';
import 'package:irespawn/src/pages/product_detail.dart';
import 'package:irespawn/src/pages/shopping_cart_page.dart';
import 'package:irespawn/src/widgets/customRoute.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/themes/theme.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


//firebase cloud messaging ...
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

//initializing firebase cloud messaging ...
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

int initScreen;

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    // alert: true,
    badge: true,
    // sound: true,
  );

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  respawn.sharedPreferences = await SharedPreferences.getInstance();
  initScreen = await respawn.sharedPreferences.getInt("initScreen");
  await respawn.sharedPreferences.setInt("initScreen", 1);
  print('initScreen $initScreen');
  // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //new code for using the wrapper class to display the respective screen like signup or home..
    return MultiProvider(
      providers: [
        StreamProvider<UserID>.value( value: AuthenticationService().user),
        ChangeNotifierProvider(create: (c) => CartItemCounter()),
        ChangeNotifierProvider(create: (c) => WishlistItemCounter()),
        ChangeNotifierProvider(create: (c) => ItemQuantity()),
        ChangeNotifierProvider(create: (c) => AddressChanger()),
        ChangeNotifierProvider(create: (c) => TotalAmount()),
      ],
      child: MaterialApp(
        home: Wrapper(),
        title: 'iRespawn',
        theme: AppTheme.lightTheme.copyWith(
          textTheme: GoogleFonts.muliTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,

        routes: Routes.getRoute(),
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name.contains('detail')) {
            return CustomRoute<bool>(
                builder: (BuildContext context) => ProductDetailPage());
          } else {
            return CustomRoute<bool>(
                builder: (BuildContext context) => Login());
          }
        },
        // initialRoute: "MainPage",

      ),
    );


    ////Old code for the instructions.dart file...
    // return MaterialApp(
    //   title: 'iRespawn ',
    //   theme: AppTheme.lightTheme.copyWith(
    //     textTheme: GoogleFonts.muliTextTheme(
    //       Theme.of(context).textTheme,
    //     ),
    //   ),
    //   debugShowCheckedModeBanner: false,
    //   routes: Routes.getRoute(),
    //   onGenerateRoute: (RouteSettings settings) {
    //     if (settings.name.contains('detail')) {
    //       return CustomRoute<bool>(
    //           builder: (BuildContext context) => ProductDetailPage());
    //     } else {
    //       return CustomRoute<bool>(
    //           builder: (BuildContext context) => Login());
    //     }
    //   },
    //   initialRoute: "MainPage",
    // );
  }
}
