import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:irespawn/src/Admin/adminUpdateProducts.dart';
import 'package:irespawn/src/model/item.dart';
import 'package:irespawn/src/pages/home_page.dart';
import 'package:irespawn/src/widgets/capturecamera.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:irespawn/src/pages/home_page.dart';
import 'package:irespawn/src/widgets/orderCard.dart';
import '../pages/home_page.dart';
import 'package:irespawn/src/widgets/loadingWidget.dart';

class ManageProducts  extends StatefulWidget  {

  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState  extends State<ManageProducts>  with AutomaticKeepAliveClientMixin<ManageProducts> {

  MyHomePage home = MyHomePage();
  Map data1 = {};
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController = TextEditingController();
  TextEditingController _productCategoryTextEditingController = TextEditingController();
  TextEditingController _productStatusTextEditingController = TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  //for picking image from camera...
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build (BuildContext context) {
    super.build(context);
    data1=ModalRoute.of(context).settings.arguments;
    // file == null ? file=File("") : file=File(data1['imagePath']) ;
    // file=File(data1['imagePath']);
    // File file = File(data1['imagePath']);
    return file==null ? displayManageProductsScreen() : displayUploadFormScreen();
  }

  displayManageProductsScreen()
  {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Manage Products", style: TextStyle(color: Colors.grey[800], fontSize: 20),),
        actions: <Widget>[
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: CircleAvatar(
          //     backgroundImage: ExactAssetImage('assets/images/one.jpg'),
          //   ),
          // )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10,),
              Text("Today", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey[800]),),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        getImage(context);
                        print("You wanna add? then add ");
                      },
                      child: Container(
                        width: 100,
                        margin: EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.blue,
                                  Colors.blue.withOpacity(.7)
                                ]
                            )
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Add Products", style: TextStyle(color: Colors.white, fontSize: 30),textAlign: TextAlign.center,),
                              // SizedBox(height: 20,),
                              // Text("3 500", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w100),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Route route = MaterialPageRoute(builder: (c) => UpdateProducts());
                        Navigator.push(context, route);
                        // getImage(context);
                        // update();
                      },
                      child: Container(
                        width: 100,
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [
                                  Colors.pink,
                                  Colors.red.withOpacity(.7)
                                ]
                            )
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Update Products", style: TextStyle(color: Colors.white, fontSize: 30),textAlign: TextAlign.center,),
                              // SizedBox(height: 20,),
                              // Text("25 Min", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w100),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              ////not necessary at the moment....look into it later....

              // SizedBox(height: 40,),
              // Text("Health Categories", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold, fontSize: 20),),
              // SizedBox(height: 20,),
              // Container(
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       color: Colors.white
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Container(
              //           width: double.infinity,
              //           padding: EdgeInsets.all(20),
              //           decoration: BoxDecoration(
              //             // borderRadius: BorderRadius.circular(10),
              //             border: Border(bottom: BorderSide(color: Colors.grey[200]))
              //           ),
              //           child: Text("Activity", style: TextStyle(color: Colors.grey[800], fontSize: 15, fontWeight: FontWeight.bold),),
              //         ),
              //         Container(
              //           width: double.infinity,
              //           padding: EdgeInsets.all(20),
              //           decoration: BoxDecoration(
              //             // borderRadius: BorderRadius.circular(10),
              //             border: Border(bottom: BorderSide(color: Colors.grey[200]))
              //           ),
              //           child: Text("Activity", style: TextStyle(color: Colors.grey[800], fontSize: 15, fontWeight: FontWeight.bold),),
              //         ),
              //         Container(
              //           width: double.infinity,
              //           padding: EdgeInsets.all(20),
              //           decoration: BoxDecoration(
              //             // borderRadius: BorderRadius.circular(10),
              //             border: Border(bottom: BorderSide(color: Colors.grey[200]))
              //           ),
              //           child: Text("Activity", style: TextStyle(color: Colors.grey[800], fontSize: 15, fontWeight: FontWeight.bold),),
              //         ),
              //         Container(
              //           width: double.infinity,
              //           padding: EdgeInsets.all(20),
              //           decoration: BoxDecoration(
              //             // borderRadius: BorderRadius.circular(10),
              //             border: Border(bottom: BorderSide(color: Colors.grey[200]))
              //           ),
              //           child: Text("Activity", style: TextStyle(color: Colors.grey[800], fontSize: 15, fontWeight: FontWeight.bold),),
              //         ),
              //       ]
              //     ),
              // )
            ],
          ),
        ),
      ),
    );
  }

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
      file=File(pickedFile1.path);
    });
  }

  //Not working for picking an image directly from the camera...
  // works with latest version of image picker...
  captureImageWithCamera()async
  {
    retrieveLostData();
    Navigator.pop(context);
    // final picker = ImagePicker();
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);
    setState(() {
      file=File(pickedFile.path);
    });
  }

  //for checking if the imagepicker closes the main activity..
  Future<void> retrieveLostData() async {
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
          file = File(response.file.path);
        });
      }
    } else {
      // _retrieveDataError = response.exception!.code;
    }
  }


  // //trial 1......partially working...i.e only the capturing part not the display part....
  // captureImageWithCamera() async
  // {
  //
  //   Navigator.pop(context);
  //   // If the picture was taken, display it on a new screen.
  //   // Obtain a list of the available cameras on the device.
  //   final cameras = await availableCameras();
  //   // Get a specific camera from the list of available cameras.
  //   final firstCamera = cameras.first;
  //   Route route = MaterialPageRoute(builder: (c) => TakePictureScreen(camera:firstCamera ));
  //   Navigator.push(context, route);
  //
  //   setState(() {
  //     file= File(data1['imagePath']);
  //     // if(file!=null){
  //     //   displayUploadFormScreen();
  //     // }
  //   });
  // }


  // ////code for old version of image picker...
  // Future captureImageWithCamera() async
  // {
  //   Navigator.pop(context);
  //   File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
  //   // File imageFile = await ImagePicker.pickImage(source: ImageSource.camera,maxHeight: 680.0, maxWidth: 970.0);
  //   setState(() {
  //     file=imageFile;
  //   });
  // }
  //
  // pickPhotoFromGallery()async
  // {
  //   Navigator.pop(context);
  //   File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     file=imageFile;
  //   });
  // }





  displayUploadFormScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            color: Colors.white
          ),
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed:(){clearFormInfo();} ,),
        title: Text("Add new Product",style: TextStyle(color: Colors.black,fontSize: 24.0,fontWeight: FontWeight.bold,),),
        actions: [
          MaterialButton(
            onPressed: (){
              uploading ? null : uploadImageAndSaveItemInfo();
            },
              child: Text("Add",style: TextStyle(color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold,),)
          )
        ],
      ),
      body: ListView(
        children: [
          uploading ? linearProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16/9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(file),
                      fit: BoxFit.cover
                    )
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(Icons.perm_device_info,color: Colors.black,),
            title: Container(
              width: 250.0,
              child: TextFormField(
                // initialValue: model.title,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                  hintText: "Product Title",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.black,),

          ListTile(
            leading: Icon(Icons.perm_device_info,color: Colors.black,),
            title: Container(
              width: 250.0,
              child: TextFormField(
                // initialValue: model.category,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _productCategoryTextEditingController,
                decoration: InputDecoration(
                  hintText: "Product Category",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.black,),

          ListTile(
            leading: Icon(Icons.perm_device_info,color: Colors.black,),
            title: Container(
              width: 250.0,
              child: TextFormField(
                // initialValue: model.shortInfo,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shortInfoTextEditingController,
                decoration: InputDecoration(
                  hintText: "Product Short Info",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.black,),
          ListTile(
            leading: Icon(Icons.perm_device_info,color: Colors.black,),
            title: Container(
              width: 250.0,
              child: TextFormField(
                // initialValue: model.shortInfo,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _productStatusTextEditingController,
                decoration: InputDecoration(
                  hintText: "Product Status",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.black,),

          ListTile(
            leading: Icon(Icons.perm_device_info,color: Colors.black,),
            title: Container(
              width: 250.0,
              child: TextFormField(
                // initialValue: model.longDescription,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Product Description",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.black,),

          ListTile(
            leading: Icon(Icons.perm_device_info,color: Colors.black,),
            title: Container(
              width: 250.0,
              child: TextFormField(
                // initialValue: model.price.toString(),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _priceTextEditingController,
                decoration: InputDecoration(
                  hintText: "Product Price",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.black,),
        ],
      ),
    );
  }

  clearFormInfo()
  {
    setState(() {
      file = null;
      _priceTextEditingController.clear();
      _descriptionTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
      _productStatusTextEditingController.clear();
      _productCategoryTextEditingController.clear();
    });
  }

  //save the product info...
  uploadImageAndSaveItemInfo() async
  {
    setState(() {
      uploading = true;
    });
    String imageDownloadURL = await uploadItemImage(file);
    saveProductInfo(imageDownloadURL);
    Fluttertoast.showToast(msg: "Product Added Successfully.!!",timeInSecForIos: 2);
  }
  //uplaod image to firebase storage..
  Future <String> uploadItemImage(mFileImage) async
  {
    final Reference storageReference = FirebaseStorage.instance.ref().child("Products");
    //Upload task..
    UploadTask uploadTask = storageReference.child("product_$productId.jpg").putFile(mFileImage);
    // TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    var ImageUrl= await (await uploadTask).ref.getDownloadURL();
    print(ImageUrl);
    String productImageUrl=ImageUrl.toString();
    return productImageUrl;
  }

  saveProductInfo(String downloadUrl)
  {
    final itemsRef = FirebaseFirestore.instance.collection("products");
    itemsRef.doc(productId).set({
      "productID" : productId,
      "category" : _productCategoryTextEditingController.text.trim(),
      "shortInfo" : _shortInfoTextEditingController.text.trim(),
      "longDescription" : _descriptionTextEditingController.text.trim(),
      "price" :int.parse(_priceTextEditingController.text.trim()),
      "publishedDate" : DateTime.now(),
      "UpdatedDate": DateTime.now(),
      "createdDate" : DateFormat('dd-MM-yyyy').format(DateTime.now()),
      "status" : _productStatusTextEditingController.text.trim(),
      "thumbnailUrl" : downloadUrl,
      "title" : _titleTextEditingController.text.trim(),
    });

    setState(() {
      file= null;
      uploading=false;
      productId=DateTime.now().millisecondsSinceEpoch.toString();
      _productCategoryTextEditingController.clear();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
    });
  }

}