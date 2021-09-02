import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:irespawn/src/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flashlight/flashlight.dart';
import 'package:irespawn/src/DialogueBoxes/errorDialog.dart';
import 'package:irespawn/src/DialogueBoxes/spinners.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/model/user.dart';
import 'package:irespawn/src/Services/AuthenticationService.dart';
import 'package:irespawn/src/pages/forgotpassword.dart';

// void main() => runApp(
//   MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: HomePage(),
//   )
// );


class Login extends StatefulWidget{
	@override
	_LoginState createState() => new _LoginState();
}


class _LoginState extends State<Login> {


	final TextEditingController _uemailController = new TextEditingController();
	final TextEditingController _upassController = new TextEditingController();

	final AuthenticationService _authservice = AuthenticationService();

	bool hasflashlight = false; //to set is there any flashlight ?
	bool isturnon = false; //to set if flash light is on or off

	//for the spinkit loader...
	bool isLoading=false;

	@override
	void initState() {
		Future.delayed(Duration.zero,() async {
			//we use Future.delayed because there is async function inside it.
			bool istherelight = await Flashlight.hasFlashlight;
			setState(() {
				hasflashlight = istherelight;
			});
		});
		super.initState();
	}

	double opacitylevel=0.0;
	bool hasBeenPressed = false; //for color change in button
	//function and declaration to turn light on and off..
	bool visibilityLight = false;
	int counter=1;
	void _changed(bool visibility, String field) {
		setState(() {
			if (field == "light"){
				visibilityLight = visibility;
			}
			// if (field == "obs"){
			// 	visibilityObs = visibility;
			// }
		});
	}

	String _myImage1 = "assets/light-1.png";
	String _myImage2 = "assets/light-1.4.png";

	double _heightt = 200.0;

	final _formKey = GlobalKey<FormState>(); //for storing form state.

	String _email,_password= "";

	FocusNode _emailFocusNode = FocusNode(); //defining the focusnode variables
	FocusNode _passwordFocusNode = FocusNode();

	//saving form after validation....
	void _saveForm() {
		final isValid = _formKey.currentState.validate();
		if (!isValid) {
			return;
		}
	}

	//to check the changed focus
	void fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
		currentFocus.unfocus();
		FocusScope.of(context).requestFocus(nextFocus);
	}

	//helper function for toast message
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
		double _heightt = 200.0;

		return isLoading? Loading() : Form(
			key: _formKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
        	child: Container(
	        child: Column(
	          children: <Widget>[
	            Container(
	              height: 400,
	              decoration: BoxDecoration(
	                image: DecorationImage(
	                  image: AssetImage('assets/background3.png'),
	                  fit: BoxFit.fill
	                )
	              ),
	              child: Stack(
	                children: <Widget>[
	                  Positioned(
	                    left: 30.0,
	                    width: 80.0,
	                    height: 200.0,
	                    child: FadeAnimation(1, Container(
	                      decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/light-1.png')
	                          // image: AssetImage(_myImage1)
	                        )
	                      ),
	                    )),
	                  ),

										//For the light reflection...
										Positioned(
											left: 24.0,
											width: 90.0,
											height: 490.0,
											child: FadeAnimation(1, InkWell(
													onTap: (){
														setState(() {
															counter=counter+1;
															print('you tapped meee only');
															if(counter%2==0 ){
																// opacitylevel=1.0;
																visibilityLight=true;
																Flashlight.lightOn();
															}
															else if(counter%2 != 0){
																// opacitylevel=0.0;
																visibilityLight=false;
																Flashlight.lightOff();
															}
															print(visibilityLight);
														});

													},
											  child: AnimatedOpacity(
													duration: Duration(seconds: 3),
											    opacity: visibilityLight? 1.0:0.0,
											    child: Container(
											    	decoration: BoxDecoration(
											    			image: DecorationImage(
											    					// image: AssetImage('assets/ylight3.png')
											    					image: AssetImage('assets/ylight_small1.1.png')
											    				// image: AssetImage(_myImage1)
											    			)
											    	),
											    ),
											  ),
											)),
										),

	                  Positioned(
	                    left: 140,
	                    width: 80,
	                    height: 150,
	                    child: FadeAnimation(1.3, Container(
	                      decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/light-2.png')
	                        )
	                      ),
	                    )),
	                  ),
	                  Positioned(
	                    right: 40,
	                    top: 40,
	                    width: 80,
	                    height: 150,
	                    child: FadeAnimation(1.5, Container(
	                      decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/repair2.png')
	                        )
	                      ),
	                    )),
	                  ),
	                  Positioned(
	                    child: FadeAnimation(1.6, Container(
	                      margin: EdgeInsets.only(top: 50),
	                      child: Center(
	                        child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
	                      ),
	                    )),
	                  )
	                ],
	              ),
	            ),
	            Padding(
	              padding: EdgeInsets.all(30.0),
	              child: Column(
	                children: <Widget>[
	                  FadeAnimation(1.8, Container(
	                    padding: EdgeInsets.all(5),
	                    decoration: BoxDecoration(
	                      color: Colors.white,
	                      borderRadius: BorderRadius.circular(10),
	                      boxShadow: [
	                        BoxShadow(
	                          color: Color.fromRGBO(143, 148, 251, .2),
	                          blurRadius: 20.0,
	                          offset: Offset(0, 10)
	                        )
	                      ]
	                    ),
	                    child: Column(
	                      children: <Widget>[
	                        Container(
	                          padding: EdgeInsets.all(8.0),
	                          decoration: BoxDecoration(
															// boxShadow:  [new BoxShadow(
															// 	color: Colors.black,
															// 	blurRadius: 5.0, // You can set this blurRadius as per your requirement
															// ),],
	                            border: Border(bottom: BorderSide(color: Colors.grey[100]))
	                          ),
	                          child: TextFormField(
															controller: _uemailController,
															focusNode: _emailFocusNode,
															// autofoscus: true,
															validator: (email)=>EmailValidator.validate(email)? null:"Invalid Email ID",
															onSaved: (text)=> _email = text,
															onFieldSubmitted: (_){
																fieldFocusChange(context, _emailFocusNode, _passwordFocusNode);

															},

	                            decoration: InputDecoration(
																prefixIcon: Icon(Icons.mail_outline_rounded, color: Colors.grey),
	                              border: InputBorder.none,
	                              // focusedBorder: OutlineInputBorder(
																// 	borderSide: BorderSide(color: Colors.deepPurple,width: 0.5)
																// ),
	                              hintText: "Email ID",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        ),
	                        Container(
	                          padding: EdgeInsets.all(8.0),
	                          child: TextFormField(
															obscureText: true,
															controller: _upassController,
															focusNode: _passwordFocusNode,
															validator: (password){
																if(password.isEmpty)
																	return 'Password cannot be Empty!';
																return null;
															},
															onSaved: (password)=> _password = password,

	                            decoration: InputDecoration(
																prefixIcon: Icon(Icons.lock_open, color: Colors.redAccent),
	                              border: InputBorder.none,
	                              hintText: "Password",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        )
	                      ],
	                    ),
	                  )),
	                  SizedBox(height: 30,),
	                  MaterialButton(
											minWidth: 0,
											height: 0,
											padding: EdgeInsets.zero,
											//onpressed event for the form validation..
											onPressed: (){
												hasBeenPressed=true;
												signInUser();
											},
	                    child: FadeAnimation(2, Container(
	                      height: 50,
	                      decoration: BoxDecoration(
	                        borderRadius: BorderRadius.circular(10),
	                        gradient: LinearGradient(
	                          colors: [
	                            Color.fromRGBO(143, 148, 251, 1),
	                            Color.fromRGBO(143, 148, 251, .6),
															Color.fromRGBO(84, 220, 220, 0.6),
	                          ]
	                        )
	                      ),
	                      child: Center(
	                        child: Text("Log me In!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
	                      ),
	                    )),
	                  ),
	                  SizedBox(height: 25,),
	                  InkWell(
											onTap:  () {
												Route route = MaterialPageRoute(builder: (c) => ForgotPassword());
												Navigator.push(context, route);
											},
	                    child:
											FadeAnimation(1.5,
													Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)),

	                  ),
	                SizedBox(height: 15,),
	                  InkWell(
											onTap:  () {
												Navigator.pushNamed(context, 'signup');
											},
	                    child:
											FadeAnimation(1.5,
													Text("Not a member? Register now", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),)),

	                  ),
	                 SizedBox(height: 90,),
	                  InkWell(
											onTap:  () {
												Navigator.pushNamed(context, 'AdminLogin1');
											},
	                    child:
											FadeAnimation(1.5,
													Text("I'm an Admin!", style: TextStyle(color: Color.fromRGBO(36, 39, 99, 1.0)),)),

	                  ),
	                ],
	              ),
	            )
	          ],
	        ),
	      ),
        ),
      ),
    );
  }
	void signInUser() async {
		if(_formKey.currentState.validate()){
			setState(() {
				isLoading=true;
			});
			_formKey.currentState.save();

		dynamic authResult =
		await _authservice.loginUser(_uemailController.text, _upassController.text);
		print("The auth result before if"+authResult.toString());
		if (authResult == null) {
			_uemailController.clear();
			_upassController.clear();
			setState(() {
			  isLoading=false;
			});
			showDialog(
					barrierDismissible: false,
					context: context,
					builder: (c)
					{
						return ErrorAlertDialog(message: "Could not sign-in with those credentials",);
					}
			);
			// print('Sign in error. could not be able to login');
		}
		else {
			// print("User Cartlist : "+respawn.userCartList);a
			_uemailController.clear();
			_upassController.clear();
			toastMessage("You Logged in successfully!");
			Navigator.pushReplacementNamed(context, 'navidrawer');
			setState(() {
				isLoading=false;
			});
			// readData(authResult).then((a){
			// 	print("auth result inside read data is:"+authResult.toString());
			//
			//
			// 	// Navigator.pushNamed(context, 'Main');
			// 	// Navigator.pushNamed(context, 'test');
			// });
		 }
		}
	}

	// //read data from the firebase for the current logged in user from the firestore database..
	// Future readData(UserID fuser) async
	// {
	// 	FirebaseFirestore.instance.collection("users").doc(fuser.toString()).get().then((dataSnapshot) async {
	// 		await respawn.sharedPreferences.setString("uid", dataSnapshot.data()[respawn.userUID]);
	// 		await respawn.sharedPreferences.setString(respawn.userName, dataSnapshot.data()[respawn.userName]);
	// 		await respawn.sharedPreferences.setString(respawn.userEmail, dataSnapshot.data()[respawn.userEmail]);
	// 		await respawn.sharedPreferences.setString(respawn.userPassword, dataSnapshot.data()[respawn.userPassword]);
	// 		await respawn.sharedPreferences.setString(respawn.userPhno, dataSnapshot.data()[respawn.userPhno]);
	// 		await respawn.sharedPreferences.setString(respawn.userAvatarUrl, dataSnapshot.data()[respawn.userAvatarUrl]);
	// 		List <String> cartList = dataSnapshot.data()[respawn.userCartList].cast<String>();
	// 		await respawn.sharedPreferences.setStringList(respawn.userCartList, cartList);
	//
	// 	});
	// }
}