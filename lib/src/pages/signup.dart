import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:irespawn/src/Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/DialogueBoxes/errorDialog.dart';
import 'package:irespawn/src/DialogueBoxes/spinners.dart';
import 'package:irespawn/src/config/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:irespawn/src/Services/AuthenticationService.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/model/user.dart';


// void main() => runApp(
//   MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: HomePage(),
//   )
// );



class Signup extends StatefulWidget {

	//Text controllers to save the typed data..
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
	final TextEditingController _unameController = new TextEditingController();

	final TextEditingController _uemailController = new TextEditingController();

	final TextEditingController _uphnoController = new TextEditingController();

	final TextEditingController _passcontroller = TextEditingController();
	final TextEditingController _confirmPasscontroller = TextEditingController();

	File _imageFile;

	String userImageUrl="";

	final AuthenticationService _authservice =  AuthenticationService();

	final UserID _uiddd = UserID();

	final _formKey = GlobalKey<FormState>();
	bool _hasBeenPressed = false;
	String _username,_email,_password= "",_phno;

	FocusNode _usernameFocusNode = FocusNode();
	FocusNode _emailFocusNode = FocusNode();

	FocusNode _phnoFocusNode = FocusNode();

	FocusNode _passwordFocusNode = FocusNode();

	FocusNode _confirmpasswordFocusNode = FocusNode();

	//for the spinkit loader...
	bool isLoading=false;

	//to check if the image is uploaded...
	bool isUploaded=false;


	void _saveForm() {
		final isValid = _formKey.currentState.validate();
		if (!isValid) {
			return;
		}
	}

	void fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
		currentFocus.unfocus();
		FocusScope.of(context).requestFocus(nextFocus);
	}

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
		double _screenWidth = MediaQuery.of(context).size.width, _screenHeight=MediaQuery.of(context).size.height;
    return isLoading ? Loading() : Form(
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
	                    left: 30,
	                    width: 80,
	                    height: 200,
	                    child: FadeAnimation(1, Container(
	                      decoration: BoxDecoration(
	                        image: DecorationImage(
	                          image: AssetImage('assets/light-1.png')
	                        )
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
	                        child: Text("Signup", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
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
	                      	//for the circle avatar for uploading user picture...
													Container(
														padding: EdgeInsets.all(8.0),
														// decoration: BoxDecoration(
														// 		border: Border(bottom: BorderSide(color: Colors.grey[100]))
														// ),
														child: InkWell(
															onTap:() {
																_selectAndPickImage();
																print('you complete me');
															},
														  child: Center(
														    child: CircleAvatar(
														    	radius: _screenWidth * 0.15,
														    	backgroundColor: Colors.black12,
														    	backgroundImage: _imageFile==null ? null : FileImage(_imageFile),
														    	child: _imageFile==null
														    			? Icon(Icons.add_a_photo,size: _screenWidth * 0.15 , color: Colors.grey,) : null,
														    ),
														  ),
														)
													),

	                        Container(
	                          padding: EdgeInsets.all(8.0),
	                          decoration: BoxDecoration(
	                            border: Border(bottom: BorderSide(color: Colors.grey[100]))
	                          ),
	                          child: TextFormField(
															controller: _unameController,
															focusNode: _usernameFocusNode,
															// autofocus: true,
															validator: (text) {
																if (! (text.length >= 5) && text.isNotEmpty) {
																	return "Username should be between 5 and 15 characters!";
																}
																else if(text.length>15){
																	return "Username too long!";
																}
																else if(text.isEmpty){
																	return "Invalid username!";
																}
																return null;
															},
															// onChanged: (text){
															// 	if(_formKey.currentState.validate()){
															// 		_formKey.currentState.save();
															// 	}
															// },
															onSaved: (text)=> _username = text,
															onFieldSubmitted: (_){
																fieldFocusChange(context, _usernameFocusNode, _emailFocusNode);

															},

	                            decoration: InputDecoration(
																prefixIcon: Icon(Icons.person, color: Colors.grey),
	                              border: InputBorder.none,
	                              hintText: "Username",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        ),
	                         Container(
	                          padding: EdgeInsets.all(8.0),
	                          decoration: BoxDecoration(
	                            border: Border(bottom: BorderSide(color: Colors.grey[100]))
	                          ),
	                          child: TextFormField(
															controller: _uemailController,
															focusNode: _emailFocusNode,
															validator: (email)=>EmailValidator.validate(email)? null:"Invalid Email ID",
															onSaved: (email)=> _email = email,
															// onChanged: (text){
															// 	if(_formKey.currentState.validate()){
															// 		_formKey.currentState.save();
															// 	}
															// },
															onFieldSubmitted: (_){
																fieldFocusChange(context, _emailFocusNode, _phnoFocusNode);
															},

	                            decoration: InputDecoration(
																prefixIcon: Icon(Icons.mail_outline_rounded, color: Colors.grey),
	                              border: InputBorder.none,
	                              hintText: "Email",
	                              hintStyle: TextStyle(color: Colors.grey[400]),
	                            ),
	                          ),
	                        ),
	                        Container(
	                          padding: EdgeInsets.all(8.0),
	                          decoration: BoxDecoration(
	                            border: Border(bottom: BorderSide(color: Colors.grey[100]))
	                          ),
	                          child: TextFormField(
															controller: _uphnoController,
															focusNode: _phnoFocusNode,
															validator: (number) {
																if (((number.length > 10) || (number.length<10))|| number.isEmpty) {
																	return "Enter a valid 10 digit phone number!";
																}
																return null;
															},
															onSaved: (number)=> _phno = number,
															// onChanged: (text){
															// 	if(_formKey.currentState.validate()){
															// 		_formKey.currentState.save();
															// 	}
															// },
															onFieldSubmitted: (_){
																fieldFocusChange(context, _phnoFocusNode, _passwordFocusNode);
															},

	                            decoration: InputDecoration(
																prefixIcon: Icon(Icons.phone_in_talk_outlined, color: Colors.grey),
	                              border: InputBorder.none,
	                              hintText: "Phone Number",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        ),
	                        Container(
	                          padding: EdgeInsets.all(8.0),
														decoration: BoxDecoration(
																border: Border(bottom: BorderSide(color: Colors.grey[100]))
														),
	                          child: TextFormField(
															obscureText: true,
															focusNode: _passwordFocusNode,
															controller: _passcontroller,
															validator: (password){
																//Minimum eight characters, at least one uppercase letter, one lowercase letter, one number and one special character:
																Pattern pattern =
																		r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
																RegExp regex = new RegExp(pattern);
																if (!regex.hasMatch(password))
																	return 'Invalid password:\n-Minimum eight characters.\n-At least one uppercase letter.\n-One number and \n-One special character. ';
																else
																	return null;
															},
															onSaved: (password)=> _username = password,
															// onChanged: (text){
															// 	if(_formKey.currentState.validate()){
															// 		_formKey.currentState.save();
															// 	}
															// },
															onFieldSubmitted: (_){
																fieldFocusChange(context, _passwordFocusNode, _confirmpasswordFocusNode);
															},

	                            decoration: InputDecoration(
																prefixIcon: Icon(Icons.lock_open, color: Colors.grey),
	                              border: InputBorder.none,
	                              hintText: "Password",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        ),
	                      Container(
	                          padding: EdgeInsets.all(8.0),
	                          child: TextFormField(
															obscureText: true,
															focusNode: _confirmpasswordFocusNode,
	                            controller: _confirmPasscontroller,
																validator: (val){
																	if(val.isEmpty)
																		return 'Confirm password cannot be Empty!';
																	if(val != _passcontroller.text)
																		return 'Password mismatch!';
																	return null;
																},
															// onChanged: (text){
															// 	if(_formKey.currentState.validate()){
															// 		_formKey.currentState.save();
															// 	}
															// },
	                            decoration: InputDecoration(
																prefixIcon: Icon(Icons.lock_open, color: Colors.redAccent),
	                              border: InputBorder.none,
	                              hintText: "Confirm Password",
	                              hintStyle: TextStyle(color: Colors.grey[400])
	                            ),
	                          ),
	                        )
	                      ],
	                    ),
	                  )),
	                  SizedBox(height: 30,),
	                  MaterialButton(
											//the minwidth, height, padding property is to make the button width fit the container
											minWidth: 0,
											height: 0,
											padding: EdgeInsets.zero,
											//onpressed event for the form validation..
											onPressed: (){
												_hasBeenPressed=true;
												if(_formKey.currentState.validate()){
													setState(() {
														isLoading=true;
													});
													_formKey.currentState.save();
													_uploadAndSaveImage();
													// createUser();

												}
											},
	                    child: FadeAnimation(2, Container(
	                      height: 50,
	                      decoration: BoxDecoration(
	                        borderRadius: BorderRadius.circular(10),
	                        gradient: LinearGradient(
	                          colors: [
	                            Color.fromRGBO(143, 148, 251, 1.0),
	                            Color.fromRGBO(143, 148, 251, .6),
	                            Color.fromRGBO(84, 220, 220, 0.6),
	                            // Color.fromRGBO(148, 53, 173, 0.6),
	                          ]
	                        )
	                      ),

	                      child: Center(
	                        child: Text("Sign me Up!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
	                      ),
	                    )),
	                  ),
	                  SizedBox(height: 15,),
	                  InkWell(
											onTap:  () {
												Navigator.pushNamed(context, 'Login');
											},
	                    child: FadeAnimation(1.5, Text("Already a member? Sign in", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),
										),
	                  ),
	                ],
	              ),
	            )
	          ],
	        ),
	      ),
        )
      ),
    );
  }

	void createUser() async {
		// print('imageurl is:'+userImageUrl);
		dynamic result = await _authservice.createNewUser(
				_unameController.text, _uemailController.text, _passcontroller.text,_uphnoController.text,userImageUrl);
		// print("The result is = "+result.toString());
		if (result == null) {
			print("The result if is  = "+result.toString());
			showDialog(
					context: context,
					builder: (c) {
						return ErrorAlertDialog(
							message: 'This Email ID already exists!',
						);
					});
			setState(() {
			  isLoading=false;
			});
			// print('Email is not valid');
		}
		else{
			print("The result else is"+result.toString());
			toastMessage("You signed up successfully!");
			Navigator.pushNamed(context, 'Login');
			_unameController.clear();
			_uemailController.clear();
			_passcontroller.clear();
			_uphnoController.clear();
			setState(() {
				isLoading=false;
			});

		}
		// else if(result== 'The account already exists for that email.'){
		// 	print('result is 2  =' + result.toString());
    //   showDialog(
    //       context: context,
    //       builder: (c) {
    //         return ErrorAlertDialog(
    //           message: 'The account already exists for that email.',
    //         );
    //       });
    //   respawn.message='';
    //   setState(() {
		// 		isLoading=false;
		// 	});
		// }

	}


	Future<void> _uploadAndSaveImage() async{
		if(_imageFile==null){
			showDialog(
					context: context,
					builder: (c) {
						return ErrorAlertDialog(
							message: ('Please choose an image!'),
						);
					});
			setState(() {
				isLoading=false;
			});
		}
		else{
			_uploadToStorage();
		}
	}

	_uploadToStorage() async{
		print('Authenticating to firestore storage');
		String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
		//May not be needed as we are creating the instance of the storage directly here below in the reference variable...
		FirebaseStorage storage = FirebaseStorage.instance;
		//fb storage reference...
		Reference storageReference = FirebaseStorage.instance.ref().child(imageFileName);
		//Upload task..
		UploadTask uploadTask = storageReference.putFile(_imageFile);
		// TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
		var ImageUrl= await (await uploadTask).ref.getDownloadURL();
		print(ImageUrl);
		userImageUrl=ImageUrl.toString();
		createUser();

		// print(userImageUrl);
		//if image uploaded successfully..
		// if(userImageUrl == null){
		// 	isUploaded=false;
		// 	setState(() {
		// 	  isLoading=false;
		// 	});
		// }
		// else{
		// createUser();
		// 	//calling createuser function after uploading the image and getting the url..otherwise the url will not be updated....
		// }


	}


	// ////old imagepicker codee....
	// Future<void> _selectAndPickImage() async{
	// 	File imgFile = await ImagePicker.pickImage(source: ImageSource.gallery);
	// 	setState(() {
	// 		_imageFile=imgFile;
	// 	});
	// }

	//new imagepicker codee...
	Future<void> _selectAndPickImage() async{
		final picker = ImagePicker();
		PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
		_imageFile = File(pickedFile.path);
	}


}