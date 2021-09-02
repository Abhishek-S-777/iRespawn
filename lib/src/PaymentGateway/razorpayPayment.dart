import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:irespawn/src/Counters/cartitemcounter.dart';
import 'package:irespawn/src/InvoicePDF/page/pdf_page.dart';
import 'package:irespawn/src/constants/config.dart';
import 'package:irespawn/src/model/addressmodel.dart';
import 'package:irespawn/src/pages/cart.dart';
import 'package:irespawn/src/troubleshooting/instructions.dart';
import 'package:irespawn/src/widgets/navigation_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PayRazor extends StatefulWidget {

  final AddressModel model1;
  final String addressId;
  final double totalAmount;
  final bool isServiceOpted;

  PayRazor({Key key, this.model1,this.addressId, this.totalAmount,this.isServiceOpted}) : super(key: key);

  @override
  _PayRazorState createState() => _PayRazorState();
}

class _PayRazorState extends State<PayRazor> {
  Razorpay _razorpay = Razorpay();
  TextEditingController textEditingController = new TextEditingController();
  var options;
  Future payData() async {
    try {
      _razorpay.open(options);
    } catch (e) {
      print("errror occured here is ......................./:$e");
    }

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print("payment has succedded");
    if(widget.isServiceOpted==true){
      addOrderDetailsService(response);
      Fluttertoast.showToast(msg: "Your purchase was successful");
      FirebaseFirestore.instance.collection("users").doc(respawn.sharedPreferences.getString(respawn.userUID)).update({
        "isServicePaymentSuccess" : "true",
      });
      Route route = MaterialPageRoute(builder: (c) => Instructions(isPaymentSuccess: true,));
      Navigator.pushReplacement(context, route);
    }
    else if(widget.isServiceOpted==false){
      addOrderDetails(response);
      Route route = MaterialPageRoute(builder: (c) => NavigationHomeScreen());
      Navigator.push(context, route);
    }
    _razorpay.clear();

  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("payment has error");
    _razorpay.clear();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("payment has externalWallet");

    _razorpay.clear();
    // Do something when an external wallet is selected
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    options = {
      'key': "rzp_test_MYGOKQz4lwvkOv", // Enter the Key ID generated from the Dashboard

      'amount': widget.isServiceOpted? 199*100 : (widget.totalAmount)*100, //in the smallest currency sub-unit.
      'name': 'iRespawn',

      'currency': "INR",
      'theme.color': "#F37254",
      'buttontext': "Pay with Razorpay",
      'description': 'iRespawn Payment',
      'prefill': {
        'contact': '8217748586',
        'email': 'abhishek.sa780@gmail.com',
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    // print("razor runtime --------: ${_razorpay.runtimeType}");
    return Scaffold(
      appBar: AppBar(
        title: Text("iRespawn Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            TextField(
              enabled: false,
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: widget.isServiceOpted? "₹ 199.0" : "₹ "+widget.totalAmount.toString(),
              ),
            ),
            SizedBox(height: 12,),
            MaterialButton(
              color: Colors.blue,
              child: Text("Pay Now", style: TextStyle(
                  color: Colors.white
              ),),
              onPressed: (){
                payData();
              },
            )
          ],
        ),
      ),
    );
  }

  //for writng the details into the firebase database...
  addOrderDetails(PaymentSuccessResponse response)
  {
    print("userid is"+respawn.sharedPreferences.getString(respawn.userUID));
    String orderTime = DateTime.now().millisecondsSinceEpoch.toString();
    writeOrderDetailsForUser({

      respawn.addressID: widget.addressId,
      respawn.totalAmount: widget.totalAmount,
      "orderBy": respawn.sharedPreferences.getString(respawn.userUID),
      'createdDate' : DateFormat('dd-MM-yyyy').format(DateTime.now()),
      'userEmail' : respawn.sharedPreferences.getString(respawn.userEmail),
      'userId' : respawn.sharedPreferences.getString(respawn.userUID),
      respawn.productID: respawn.sharedPreferences.getStringList(respawn.userCartList),
      respawn.paymentDetails: "RazorPay",
      respawn.orderTime: orderTime,
      respawn.isSuccess: true,
      'shipmentStatus' : false,
      'isDelivered' : false,
      'razorPayPaymentID' : response.paymentId,
    });

    writeOrderDetailsForAdmin({

      respawn.addressID: widget.addressId,
      respawn.totalAmount: widget.totalAmount,
      "orderBy": respawn.sharedPreferences.getString(respawn.userUID),
      'createdDate' : DateFormat('dd-MM-yyyy').format(DateTime.now()),
      'userEmail' : respawn.sharedPreferences.getString(respawn.userEmail),
      'userId' : respawn.sharedPreferences.getString(respawn.userUID),
      respawn.productID: respawn.sharedPreferences.getStringList(respawn.userCartList),
      respawn.paymentDetails: "RazorPay",
      respawn.orderTime: orderTime,
      respawn.isSuccess: true,
      'shipmentStatus' : false,
      'isDelivered' : false,
      'razorPayPaymentID' : response.paymentId,
    }).whenComplete(() => {
      emptyCartNow()
    });
  }

  //for writng the service order details into the firebase database...
  addOrderDetailsService(PaymentSuccessResponse response)
  {
    String orderTime = DateTime.now().millisecondsSinceEpoch.toString();
    writeOrderDetailsForUser({
      'userId' : respawn.sharedPreferences.getString(respawn.userUID),
      respawn.totalAmount: 199,
      "orderBy": respawn.sharedPreferences.getString(respawn.userUID),
      'createdDate' : DateFormat('dd-MM-yyyy').format(DateTime.now()),
      'userEmail' : respawn.sharedPreferences.getString(respawn.userEmail),
      'serviceName': 'TroubleShooting Service',
      respawn.paymentDetails: "RazorPay",
      respawn.orderTime: orderTime,
      respawn.isSuccess: true,
      'razorPayPaymentID' : response.paymentId,
    });

    writeOrderDetailsForAdmin({
      'userId' : respawn.sharedPreferences.getString(respawn.userUID),
      respawn.totalAmount: 199,
      "orderBy": respawn.sharedPreferences.getString(respawn.userUID),
      'createdDate' : DateFormat('dd-MM-yyyy').format(DateTime.now()),
      'userEmail' : respawn.sharedPreferences.getString(respawn.userEmail),
      'serviceName': 'TroubleShooting Service',
      respawn.paymentDetails: "RazorPay",
      respawn.orderTime: orderTime,
      respawn.isSuccess: true,
      'razorPayPaymentID' : response.paymentId,
    });
  }

  emptyCartNow()
  {
    respawn.sharedPreferences.setStringList(respawn.userCartList, ["garbageValue"]);
    List tempList = respawn.sharedPreferences.getStringList(respawn.userCartList);

    FirebaseFirestore.instance.collection("users")
        .doc(respawn.sharedPreferences.getString(respawn.userUID))
        .update({
      respawn.userCartList: tempList,
    }).then((value)
    {
      respawn.sharedPreferences.setStringList(respawn.userCartList, tempList);
      Provider.of<CartItemCounter>(context, listen: false).displayResult();
    });

    Fluttertoast.showToast(msg: "Congratulations, your Order has been placed successfully.");

    ////Change the navigaton later...
    // Route route = MaterialPageRoute(builder: (c) => SplashScreen());
    // Navigator.pushReplacement(context, route);
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance.collection(respawn.collectionUser)
        .doc(respawn.sharedPreferences.getString(respawn.userUID))
        .collection(respawn.collectionOrders)
        .doc(respawn.sharedPreferences.getString(respawn.userUID) + data['orderTime'])
        .set(data);
  }

  Future writeOrderDetailsForAdmin(Map<String, dynamic> data) async
  {
    await FirebaseFirestore.instance
        .collection(respawn.collectionOrders)
        .doc(respawn.sharedPreferences.getString(respawn.userUID) + data['orderTime'])
        .set(data);
  }

}
