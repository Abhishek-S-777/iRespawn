import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:irespawn/src/constants/config.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage> with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>(); //for storing form state.

  String _imageUrl;
  File _imageFile;
  bool uploading = false;
  File file;

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _imageUrl=respawn.sharedPreferences.getString(respawn.userAvatarUrl);
    print("Current user id is"+respawn.sharedPreferences.getString(respawn.userUID));
    return Form(
      key: _formKey,
      child: new Scaffold(
          body: new Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  height: 250.0,
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 20.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // new Icon(
                              //   Icons.arrow_back_ios,
                              //   color: Colors.black,
                              //   size: 22.0,
                              // ),
                              Padding(
                                padding: EdgeInsets.only(left: 140.0),
                                child: Center(
                                  child: new Text('PROFILE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          fontFamily: 'sans-serif-light',
                                          color: Colors.black,
                                      ),
                                  textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: new Stack(fit: StackFit.loose, children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _showImage(),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 25.0,
                                    child:  InkWell(
                                      onTap:(){
                                        getImage(context);
                                        print("Change the image");
                                      },
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
                new Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Personal Information',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    _status ? _getEditIcon() : new Container(),
                                  ],
                                )
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Name',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    decoration: const InputDecoration(
                                      hintText: "Enter Your Name",
                                    ),
                                    enabled: !_status,
                                    autofocus: !_status,
                                    initialValue: respawn.sharedPreferences.getString(respawn.userName),
                                    onSaved: (String value){
                                      respawn.sharedPreferences.setString(respawn.userName,value);
                                    },
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Email ID',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: "Enter Email ID"),
                                    enabled: !_status,
                                    initialValue: respawn.sharedPreferences.getString(respawn.userEmail),
                                    onSaved: (String value){
                                      respawn.sharedPreferences.setString(respawn.userEmail,value);
                                    },
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 25.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Mobile',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 2.0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                new Flexible(
                                  child: new TextFormField(
                                    decoration: const InputDecoration(
                                        hintText: "Enter Mobile Number"),
                                    enabled: !_status,
                                    initialValue: respawn.sharedPreferences.getString(respawn.userPhno),
                                    onSaved: (String value){
                                      respawn.sharedPreferences.setString(respawn.userPhno,value);
                                    },
                                  ),
                                ),
                              ],
                            )),
                        // Padding(
                        //     padding: EdgeInsets.only(
                        //         left: 25.0, right: 25.0, top: 25.0),
                        //     child: new Row(
                        //       mainAxisSize: MainAxisSize.max,
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: <Widget>[
                        //         Expanded(
                        //           child: Container(
                        //             child: new Text(
                        //               'Pin Code',
                        //               style: TextStyle(
                        //                   fontSize: 16.0,
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //           ),
                        //           flex: 2,
                        //         ),
                        //         Expanded(
                        //           child: Container(
                        //             child: new Text(
                        //               'State',
                        //               style: TextStyle(
                        //                   fontSize: 16.0,
                        //                   fontWeight: FontWeight.bold),
                        //             ),
                        //           ),
                        //           flex: 2,
                        //         ),
                        //       ],
                        //     )
                        // ),
                        // Padding(
                        //     padding: EdgeInsets.only(
                        //         left: 25.0, right: 25.0, top: 2.0),
                        //     child: new Row(
                        //       mainAxisSize: MainAxisSize.max,
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: <Widget>[
                        //         Flexible(
                        //           child: Padding(
                        //             padding: EdgeInsets.only(right: 10.0),
                        //             child: new TextField(
                        //               decoration: const InputDecoration(
                        //                   hintText: "Enter Pin Code"),
                        //               enabled: !_status,
                        //             ),
                        //           ),
                        //           flex: 2,
                        //         ),
                        //         Flexible(
                        //           child: new TextField(
                        //             decoration: const InputDecoration(
                        //                 hintText: "Enter State"),
                        //             enabled: !_status,
                        //           ),
                        //           flex: 2,
                        //         ),
                        //       ],
                        //     )),
                        !_status ? _getActionButtons() : new Container(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Update"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  uploadImageAndSaveItemInfo();
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  //Edit user profile..

  //getting to show the image either from the localstorage or from the url.....
  _showImage(){
    _imageUrl= respawn.sharedPreferences.getString(respawn.userAvatarUrl);
    if (_imageFile == null && _imageUrl == null) {
      return Text("image placeholder");
    }

    else if(_imageFile!=null){
      return Container(
          width: 140.0,
          height: 140.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              image: FileImage(_imageFile),
              fit: BoxFit.cover,
            ),
          )
      );
    }

    else if(_imageUrl!= null){
      return Container(
          width: 140.0,
          height: 140.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
              image: new NetworkImage(
                  respawn.sharedPreferences.getString(respawn.userAvatarUrl)
              ),
              fit: BoxFit.cover,
            ),
          )
      );
    }
  }

  //for getting the image from the user..for updating the product...
  getImage(mContext)
  {
    return showDialog(
        context: mContext,
        builder: (con)
        {
          return SimpleDialog(
            title: Text(
              "Add Product Image",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 22),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Capture image with camera",
                  style: TextStyle(color: Colors.blueAccent,fontSize: 18),
                ),
                onPressed:(){
                  captureImageWithCamera();
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Select image from Gallery",
                  style: TextStyle(color: Colors.blueAccent,fontSize: 18),
                ),
                onPressed:(){
                  pickPhotoFromGallery();
                },
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.blueAccent,fontSize: 18),
                ),
                onPressed: ()
                {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  pickPhotoFromGallery()async
  {
    Navigator.pop(context);
    final picker1 = ImagePicker();
    PickedFile pickedFile1 = await picker1.getImage(source: ImageSource.gallery);
    setState(() {
      _imageFile=File(pickedFile1.path);
    });
  }

  //Not working for picking an image directly from the camera...
  // works with latest version of image picker...
  captureImageWithCamera()async
  {
    retrieveLostData();
    Navigator.pop(context);
    final ImagePicker _picker = ImagePicker();
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
    setState(() {
      _imageFile=File(pickedFile.path);
    });
  }

  //for checking if the imagepicker closes the main activity..
  Future<void> retrieveLostData() async {
    final ImagePicker _picker = ImagePicker();
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        // isVideo = true;
        // await _playVideo(response.file);
      } else {
        // isVideo = false;
        setState(() {
          _imageFile = File(response.file.path);
        });
      }
    } else {
      // _retrieveDataError = response.exception!.code;
    }
  }

  //save the product info...
  uploadImageAndSaveItemInfo() async
  {
    setState(() {
      uploading = true;
    });
    if(_imageFile!=null){
      //to delete the existing product image...and replace it with the new one
      Reference storageReference = FirebaseStorage.instance.refFromURL(respawn.sharedPreferences.getString(respawn.userAvatarUrl));
      print(storageReference.fullPath);
      await storageReference.delete();

      String imageDownloadURL = await uploadItemImage(_imageFile);
      saveProductInfo(downloadURL: imageDownloadURL);
    }
    else{
      saveProductInfo();
    }

  }
  //uplaod image to firebase storage..
  Future <String> uploadItemImage(mFileImage) async
  {
    String userID= respawn.sharedPreferences.getString(respawn.userUID) ;
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageReference = FirebaseStorage.instance.ref().child(imageFileName);
    //Upload task..
    UploadTask uploadTask = storageReference.putFile(mFileImage);
    // TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    var ImageUrl= await (await uploadTask).ref.getDownloadURL();
    print(ImageUrl);
    String productImageUrl=ImageUrl.toString();
    return productImageUrl;
  }

  saveProductInfo({String downloadURL})
  {
    if(_formKey.currentState.validate()){
      setState(() {
        _formKey.currentState.save();
        // _imageFile= null;
        // uploading=false;
      });

      // print(widget.itemmodel.title);
      final itemsRef = FirebaseFirestore.instance.collection("users");
      itemsRef.doc(respawn.sharedPreferences.getString(respawn.userUID)).update({
        "name" : respawn.sharedPreferences.getString(respawn.userName),
        "email" : respawn.sharedPreferences.getString(respawn.userEmail),
        "phoneNumber" : respawn.sharedPreferences.getString(respawn.userPhno),
        "url" : downloadURL!=null? downloadURL : respawn.sharedPreferences.getString(respawn.userAvatarUrl),
        // "longDescription" : widget.itemmodel.longDescription,
      });
      // Navigator.pop(context);
    }
  }
}
