import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/Animation/FadeAnimation.dart';
import 'package:irespawn/src/DialogueBoxes/errorDialog.dart';
import 'package:irespawn/src/DialogueBoxes/spinners.dart';
import 'package:irespawn/src/constants/config.dart';

class AdminLogin1 extends StatefulWidget {
  @override
  _AdminLogin1State createState() => _AdminLogin1State();
}

class _AdminLogin1State extends State<AdminLogin1> {

  final TextEditingController _adidController = new TextEditingController();
  final TextEditingController _adpassController = new TextEditingController();

  //for the spinkit loader...
  bool isLoading=false;

  final _formKey = GlobalKey<FormState>(); //for storing form state.

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
    final width = MediaQuery.of(context).size.width;
    return isLoading? Loading() : Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 400,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: -40,
                      height: 400,
                      width: width,
                      child: FadeAnimation(1, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/backgroundadmin.png'),
                                fit: BoxFit.fill
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      height: 400,
                      width: width+20,
                      child: FadeAnimation(1.3, Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/backgroundadmin2.png'),
                                fit: BoxFit.fill
                            )
                        ),
                      )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(1.5, Center(
                      child: Text(
                        "Admin Login",
                        style: TextStyle(color: Color.fromRGBO(49, 39, 79, 1), fontWeight: FontWeight.bold, fontSize: 30,),),
                    )),
                    SizedBox(height: 30,),
                    FadeAnimation(1.7, Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(196, 135, 198, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            )
                          ]
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                    color: Colors.grey[200]
                                ))
                            ),
                            child: TextFormField(
                              controller: _adidController,
                              validator: (adminid){
                                if(adminid.isEmpty)
                                  return 'Admin ID cannot be Empty!';
                                return null;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.perm_identity, color: Colors.grey),
                                  border: InputBorder.none,
                                  hintText: "Admin ID",
                                  hintStyle: TextStyle(color: Colors.grey)
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              obscureText: true,
                              controller: _adpassController,
                              validator: (adminpwd){
                                if(adminpwd.isEmpty)
                                  return ' Password cannot be Empty!';
                                return null;
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock_open, color: Colors.redAccent),
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey)
                              ),
                            ),
                          )
                        ],
                      ),
                    )),

                    ////forgot password is not necessary for admin..
                    // SizedBox(height: 20,),
                    // FadeAnimation(1.7, Center(child: Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(196, 135, 198, 1)),))),
                    SizedBox(height: 30,),
                    FadeAnimation(1.9, MaterialButton(
                      onPressed: () {
                        signInAdmin();
                      },
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(49, 39, 79, 1),
                        ),
                        child: Center(
                          child: Text("Login", style: TextStyle(color: Colors.white),),
                        ),
                      ),
                    )),

                    ////Create account is not necessary for admin..

                    // SizedBox(height: 30,),
                    // FadeAnimation(2, Center(child: Text("Create Account", style: TextStyle(color: Color.fromRGBO(49, 39, 79, .6)),))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void signInAdmin() async {
    if (_formKey.currentState.validate()) {
      FirebaseFirestore.instance.collection("admins").get().then((snapshot) {
        snapshot.docs.forEach((result) {

          print("Result admin: "+result.data()['id']);
          if (result.data()["id"] != _adidController.text) {
            toastMessage("Admin ID is incorrect");
            setState(() {
              isLoading = false;
            });
          }

          else if (result.data()["password"] != _adpassController.text) {
            toastMessage("Admin password is incorrect");
            setState(() {
              isLoading = false;
            });
          }

          else {
            toastMessage("Welcome " + result.data()["name"]);
            Navigator.pushReplacementNamed(context, 'AdminHome',arguments:{'adminName': result.data()["name"],'adminID': _adidController.text} );
            _adidController.text = "";
            _adpassController.text = "";
            setState(() {
              isLoading = false;
            });
          }
        });
      });
      setState(() {
        isLoading = true;
      });
      _formKey.currentState.save();


    }
  }
}
