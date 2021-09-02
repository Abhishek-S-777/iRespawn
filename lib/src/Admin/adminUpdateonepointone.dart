import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:irespawn/src/model/item.dart';
import 'package:irespawn/src/widgets/loadingWidget.dart';

class UpdateProductOnePointOne extends StatefulWidget {

  final ItemModel itemmodel;

  UpdateProductOnePointOne(this.itemmodel);

  @override
  _UpdateProductOnePointOneState createState() => _UpdateProductOnePointOneState();
}

class _UpdateProductOnePointOneState extends State<UpdateProductOnePointOne> {
  @override
  //to check if we are displaying from the local file or from the image url...
  String _imageUrl;
  File _imageFile;
  bool uploading = false;
  File file;

  final _formKey = GlobalKey<FormState>(); //for storing form state.

  Widget build(BuildContext context) {
    _imageUrl=widget.itemmodel.thumbnailUrl;
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: new BoxDecoration(
                color: Colors.white
            ),
          ),
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed:(){
            // clearFormInfo();
          } ,),
          title: Text("Edit Products",style: TextStyle(color: Colors.black,fontSize: 24.0,fontWeight: FontWeight.bold,),),
          actions: [
            MaterialButton(
                onPressed: (){
                  // uploading ? null : uploadImageAndSaveItemInfo();
                },
                child: Text("Update",style: TextStyle(color: Colors.black,fontSize: 16.0,fontWeight: FontWeight.bold,),)
            )
          ],
        ),
        body: ListView(
          children: [
            uploading ? linearProgress() : Text(""),
            _showImage(),

            Padding(padding: EdgeInsets.only(top: 12.0)),
            ListTile(
              leading: Icon(Icons.perm_device_info,color: Colors.black,),
              title: Container(
                width: 250.0,
                child: TextFormField(
                  initialValue: widget.itemmodel.title,
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  // controller: _titleTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Product Title",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                  onSaved: (String value){
                    widget.itemmodel.title=value;
                  },
                ),
              ),
            ),
            Divider(color: Colors.black,),

            ListTile(
              leading: Icon(Icons.perm_device_info,color: Colors.black,),
              title: Container(
                width: 250.0,
                child: TextFormField(
                  initialValue: widget.itemmodel.category,
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  // controller: _productCategoryTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Product Category",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                  onSaved: (String value){
                    widget.itemmodel.category=value;
                  },
                ),
              ),
            ),
            Divider(color: Colors.black,),

            ListTile(
              leading: Icon(Icons.perm_device_info,color: Colors.black,),
              title: Container(
                width: 250.0,
                child: TextFormField(
                  initialValue: widget.itemmodel.shortInfo,
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  // controller: _shortInfoTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Product Short Info",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                  onSaved: (String value){
                    widget.itemmodel.shortInfo=value;
                  },
                ),
              ),
            ),
            Divider(color: Colors.black,),

            ListTile(
              leading: Icon(Icons.perm_device_info,color: Colors.black,),
              title: Container(
                width: 250.0,
                child: TextFormField(
                  initialValue: widget.itemmodel.longDescription,
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  // controller: _descriptionTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Product Description",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                  onSaved: (String value){
                    widget.itemmodel.longDescription=value;
                  },
                ),
              ),
            ),
            Divider(color: Colors.black,),

            ListTile(
              leading: Icon(Icons.perm_device_info,color: Colors.black,),
              title: Container(
                width: 250.0,
                child: TextFormField(
                  initialValue: widget.itemmodel.status,
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  // controller: _descriptionTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Product Status",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                  onSaved: (String value){
                    widget.itemmodel.status=value;
                  },
                ),
              ),
            ),
            Divider(color: Colors.black,),

            ListTile(
              leading: Icon(Icons.perm_device_info,color: Colors.black,),
              title: Container(
                width: 250.0,
                child: TextFormField(
                  initialValue: widget.itemmodel.price.toString(),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  // controller: _priceTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Product Price",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                  onSaved: (String value){
                    widget.itemmodel.price= int.parse(value) ;
                  },
                ),
              ),
            ),
            Divider(color: Colors.black,),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: 'button1',
              onPressed: () {
                uploadImageAndSaveItemInfo();
                Fluttertoast.showToast(msg: "Product Updated Successfully!",timeInSecForIos: 3);
                print("You pressed edit button");
                // saveProductInfo();
              },
              child: Icon(Icons.edit),
              foregroundColor: Colors.white,
            ),
            SizedBox(height: 20),
            FloatingActionButton(
              heroTag: 'button2',
              onPressed: () {
                deleteProductInfo();
                Fluttertoast.showToast(msg: "Product Deleted Successfully!",timeInSecForIos: 3);

              },
              child: Icon(Icons.delete),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  //getting to show the image either from the localstorage or from the url.....
  _showImage(){
    _imageUrl= widget.itemmodel.thumbnailUrl;
    if (_imageFile == null && _imageUrl == null) {
      return Text("image placeholder");
    }

    else if(_imageFile!=null){
      return Container(
        height: 230.0,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
          child: AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(_imageFile),
                      fit: BoxFit.cover
                  )
              ),
              child: Container(
                // color: Colors.redAccent,
                height: 20.0,
                width: 20.0,
                child: MaterialButton(
                  padding: EdgeInsets.all(16),
                  color: Colors.black54,
                  child: Text(
                    'Change Image',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
                  ),
                  onPressed: () {
                    setState(() {
                      // pickPhotoFromGallery();
                      getImage(context);
                    });
                    // pickPhotoFromGallery();
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }

    else if(_imageUrl!= null){
      return Container(
        height: 230.0,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
          child: AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(widget.itemmodel.thumbnailUrl),
                      fit: BoxFit.cover
                  )
              ),
              child: MaterialButton(
                padding: EdgeInsets.all(16),
                color: Colors.black54,
                child: Text(
                  'Change Image',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
                ),
                onPressed: () {
                  setState(() {
                    // pickPhotoFromGallery();
                    getImage(context);
                  });
                  // pickPhotoFromGallery();
                },
              ),
            ),
          ),
        ),
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
      Reference storageReference = FirebaseStorage.instance.refFromURL(widget.itemmodel.thumbnailUrl);
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
    String prodID= widget.itemmodel.productID;
    final Reference storageReference = FirebaseStorage.instance.ref().child("Products");
    //Upload task..
    UploadTask uploadTask = storageReference.child("product_$prodID.jpg").putFile(mFileImage);
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
        _imageFile= null;
        uploading=false;
      });

      print(widget.itemmodel.title);
      final itemsRef = FirebaseFirestore.instance.collection("products");
      itemsRef.doc(widget.itemmodel.productID).update({
        "category" : widget.itemmodel.category,
        "shortInfo" : widget.itemmodel.shortInfo,
        "longDescription" : widget.itemmodel.longDescription,
        "price" :widget.itemmodel.price,
        "UpdatedDate": DateTime.now(),
        // "publishedDate" : DateTime.now(),
        "status" : widget.itemmodel.status,
        "thumbnailUrl" : downloadURL!=null? downloadURL : widget.itemmodel.thumbnailUrl,
        "title" : widget.itemmodel.title,
        // "title" : "R7777",
      });
      Navigator.pop(context);
    }
  }

  deleteProductInfo() async {

    setState(() {
      uploading=true;
    });
    //to delete the existing product image...and replace it with the new one
    if(widget.itemmodel.thumbnailUrl!=null){
      Reference storageReference = FirebaseStorage.instance.refFromURL(widget.itemmodel.thumbnailUrl);
      print(storageReference.fullPath);
      await storageReference.delete();
    }

    await FirebaseFirestore.instance.collection('products').doc(widget.itemmodel.productID).delete();
    Navigator.pop(context);

  }

}
