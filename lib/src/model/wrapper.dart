import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:irespawn/src/model/user.dart';
import 'package:irespawn/src/pages/login.dart';
import 'package:irespawn/src/pages/signup.dart';
import 'package:irespawn/src/pages/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:irespawn/src/widgets/navigation_home_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

class _WrapperState extends State<Wrapper> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      // if (notification != null && android != null) {
      //   showDialog(
      //       context: context,
      //       builder: (_) {
      //         return AlertDialog(
      //           title: Text(notification.title),
      //           content: SingleChildScrollView(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [Text(notification.body)],
      //             ),
      //           ),
      //         );
      //       });
      // }
    });

  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserID>(context);
    // print("My user id is "+user.uid);

    // _getToken();
    // either return the Home or Login widget
    if (user == null){
      return Login();
    } else {
      return NavigationHomeScreen();
    }

  }
}