import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:irespawn/src/Admin/adminReport.dart';
import 'package:irespawn/src/Admin/adminShiftOrders.dart';
import 'package:irespawn/src/troubleshooting/userchat/mainchatscreen.dart';


class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  final List<String> _listItem1 = [
    'assets/images/ab1.jpg',
    'assets/images/ab6.jpg',
    'assets/images/ab9.jpg',
    'assets/images/ab7.jpg',
  ];

  final List<String> _listItemtext = [
    'View Orders!',
    'Manage Products!',
    'Service Chats!',
    'Report!',
  ];

  //map for storing and retrieving admin name...
  Map data = {};

  //toast message function...
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

  @override
  Widget build(BuildContext context) {
    data=ModalRoute.of(context).settings.arguments;
    print("admin id: "+data['adminID']);
    if (data['adminID']=='The Prince'){
      AssetsAudioPlayer.newPlayer().open(
        Audio("assets/music/Thagedheleeffect.mp3"),
        autoStart: true,
        // showNotification: true,
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        title: Text(
            "Admin Home",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              width: 36,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10)
              ),
              child: InkWell(
                onTap: (){
                  setState(() {
                    toastMessage(data['adminName']+" logged out successfully!");
                    Navigator.pushReplacementNamed(context, 'AdminLogin1');
                  });
                },
                child: Center(
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 20.0,
                  ),
                //     child: Text(
                //     "0",
                //   style: TextStyle(color: Colors.white),
                // ),
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/images/one.jpg'),
                    fit: BoxFit.cover
                  )
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors: [
                        Colors.deepPurpleAccent.withOpacity(.4),
                        Colors.black.withOpacity(.2),
                      ]
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Center(
                        child: Text(
                          "Welcome "+data['adminName']+" !",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                      ),
                      SizedBox(height: 100,),
                      // Container(
                      //   height: 50,
                      //   margin: EdgeInsets.symmetric(horizontal: 40),
                      //   decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(10),
                      //     color: Colors.white
                      //   ),
                      //   child: Center(child: Text("Shop Now", style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),)),
                      // ),
                      // SizedBox(height: 30,),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 55,),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(4, (index) => Card(
                    color: Colors.transparent,
                    elevation: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //     begin: Alignment.topLeft,
                        //     end: Alignment.bottomRight,
                        //     colors: [Colors.black,Colors.white]
                        // ),
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          // image: AssetImage('assets/images/one.jpg'),
                          image: AssetImage(_listItem1[index]),
                          fit: BoxFit.cover
                        )
                      ),
                      child: InkWell(
                        onTap: (){
                          if(index==0){
                            Navigator.pushNamed(context, 'AdminShiftOrders');
                            print("You tapped index: "+index.toString());
                          }
                          else if(index==1){
                            Navigator.pushNamed(context, 'ManageProducts');
                            print("You tapped index: "+index.toString());
                          }
                          else if(index==2){
                            print("You tapped service chats");
                            Route route = MaterialPageRoute(builder: (c) => MainChatScreen());
                            Navigator.push(context, route);
                          }
                          else if(index==3){
                            Route route = MaterialPageRoute(builder: (c) => AdminReport());
                            Navigator.push(context, route);
                          }

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                                begin: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(.3),
                                  Colors.black.withOpacity(.1),
                                ]
                            )
                          ),
                          child: Center(
                            child: Text(
                              _listItemtext[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // child: Transform.translate(
                          //   offset: Offset(50, -50),
                          //   child: Container(
                          //
                          //     margin: EdgeInsets.symmetric(horizontal: 65, vertical: 63),
                          //     decoration: BoxDecoration(
                          //
                          //       borderRadius: BorderRadius.circular(10),
                          //       color: Colors.white
                          //     ),
                          //     child: Icon(Icons.bookmark_border, size: 15,),
                          //   ),
                          // ),

                        ),
                      ),

                    ),
                    )
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
