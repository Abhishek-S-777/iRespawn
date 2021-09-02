import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/model/addressmodel.dart';
import 'package:irespawn/src/pages/home_page.dart';
import 'package:irespawn/src/pages/mainPage.dart';
import 'package:irespawn/src/widgets/navigation_home_screen.dart';

class AddAddress extends StatelessWidget
{
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cStreet = TextEditingController();
  final cLandmark = TextEditingController();
  final cFlatHomeNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        // appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: ()
          {
            if(formKey.currentState.validate())
            {
              final model = AddressModel(
                name:  cName.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text,
                phoneNumber: cPhoneNumber.text,
                street: cStreet.text,
                landmark: cLandmark.text,
                flatNumber: cFlatHomeNumber.text,
                city: cCity.text.trim(),
              ).toJson();

              //add to firestore
              FirebaseFirestore.instance.collection(respawn.collectionUser)
                  .doc(respawn.sharedPreferences.getString(respawn.userUID))
                  .collection(respawn.subCollectionAddress)
                  .doc(DateTime.now().millisecondsSinceEpoch.toString())
                  .set(model)
                  .then((value){
                    Fluttertoast.showToast(msg: "New Address added successfully.");
                    // final snack = SnackBar(content: Text("New Address added successfully."));
                    // scaffoldKey.currentState.showSnackBar(snack);
                    FocusScope.of(context).requestFocus(FocusNode());
                    formKey.currentState.reset();
              });

              // Navigator.pop(context);
              Route route = MaterialPageRoute(builder: (c) => NavigationHomeScreen());
              Navigator.pushReplacement(context, route);
            }
          },
          label: Text("Done"),
          backgroundColor: Colors.pink,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      "Add New Address",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name",
                      controller: cName,
                    ),
                    MyTextField(
                      hint: "Phone Number",
                      controller: cPhoneNumber,
                    ),

                    MyTextField(
                      hint: "Street/Lane",
                      controller: cStreet,
                    ),

                    MyTextField(
                      hint: "Landmark",
                      controller: cLandmark,
                    ),
                    MyTextField(
                      hint: "Flat Number / House Number",
                      controller: cFlatHomeNumber,
                    ),
                    MyTextField(
                      hint: "City",
                      controller: cCity,
                    ),
                    MyTextField(
                      hint: "State / Country",
                      controller: cState,
                    ),
                    MyTextField(
                      hint: "Pin Code",
                      controller: cPinCode,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget
{
  final String hint;
  final TextEditingController controller;

  MyTextField({Key key, this.hint, this.controller,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15,bottom: 10,top: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val.isEmpty ? "Field can not be empty." : null,
      ),
    );
  }
}
