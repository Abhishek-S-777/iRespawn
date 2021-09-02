import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:irespawn/src/Admin/Linechart.dart';
import 'package:irespawn/src/Admin/Barchart.dart';
import 'package:irespawn/src/ReportPDF/page/report_pdf_page.dart';
import 'package:irespawn/src/model/orderModel.dart';
import 'package:irespawn/src/model/reportVariables.dart';
import 'package:irespawn/src/widgets/button_widget.dart';

class AdminReport extends StatefulWidget {
  const AdminReport({Key key}) : super(key: key);

  @override
  _AdminReportState createState() => _AdminReportState();
}

class _AdminReportState extends State<AdminReport> {
  //for overall reports......
  int users,products,ordersReceived, ordersShipped, ordersPending;
  var totProfit;
  var totRevenue;
  int sum=0;
  int finalRevenue;

  //for specific dates report....
  int users1,products1,ordersReceived1, ordersShipped1, ordersPending1;
  var totProfit1;
  var totRevenue1;
  int sum1=0;
  int finalRevenue1;

  String startDate;
  String endDate;

  bool isOverallVisible=true;
  bool isParticularVisible=false;
  DateTimeRange dateRange;

  List<DocumentSnapshot> orderItems;
  List<DocumentSnapshot> orderItems1;

  // List <ReportVariables> overallReport;
  // List <ReportVariables> specificReport;
  //
  // var oReport = [{'users': 2},{'products' : 10}];

  @override
  void initState() {

    super.initState();

    //for the overall reports....
    //****************************************************************************************************//
    
    //to get the total number of users registered....
    FirebaseFirestore.instance.collection("users").get().then((querySnapshot) {
      setState(() {
        users = querySnapshot.size;
      });
      // users = querySnapshot.size;
      print("Collection users size: "+ querySnapshot.size.toString());
    });

    //to get tge total number of products available in the database
    FirebaseFirestore.instance.collection("products").get().then((querySnapshot) {
      setState(() {
        products = querySnapshot.size;
      });
      print("Collection users size: "+ querySnapshot.size.toString());
    });

    //to get the total number of orders received...
    FirebaseFirestore.instance.collection("orders").get().then((querySnapshot) {
      setState(() {
        ordersReceived = querySnapshot.size;
      });
      print("Collection users size: "+ querySnapshot.size.toString());
    });

    //to get the total number of orders shipped.
    FirebaseFirestore.instance.collection("orders").where("shipmentStatus",isEqualTo: true).get().then((querySnapshot) {
      setState(() {
        ordersShipped = querySnapshot.size;

      });
      print("Collection users size: "+ querySnapshot.size.toString());
    });

    //tp get the total number of orders pending to ship.
    FirebaseFirestore.instance.collection("orders").where("shipmentStatus",isEqualTo: false).get().then((querySnapshot) {
      setState(() {
        ordersPending = querySnapshot.size;
      });
      print("Collection users size: "+ querySnapshot.size.toString());
    });

  }

  @override
  Widget build(BuildContext context) {

    // print("oReport"+oReport[1].toString());

    //for specific reports

    //to get the number of users..
    FirebaseFirestore.instance.collection("users").orderBy("createdDate").startAt([getFrom()]).endAt([getUntil()]).get().then((querySnapshot) {

      setState(() {
        users1 = querySnapshot.size;
      });
      // users = querySnapshot.size;
      print("Collection users size: "+ querySnapshot.size.toString());
    });

    //to get tge total number of products available in the database
    FirebaseFirestore.instance.collection("products").orderBy("createdDate").startAt([getFrom()]).endAt([getUntil()]).get().then((querySnapshot) {
      setState(() {
        products1 = querySnapshot.size;
      });
      print("Collection users size: "+ querySnapshot.size.toString());
    });

    //to get the total number of orders received...
    FirebaseFirestore.instance.collection("orders").orderBy("createdDate").startAt([getFrom()]).endAt([getUntil()]).get().then((querySnapshot) {
      setState(() {
        ordersReceived1 = querySnapshot.size;
      });
      print("Collection users size: "+ querySnapshot.size.toString());
    });

    //to get the total number of orders shipped.
    FirebaseFirestore.instance.collection("orders").where("shipmentStatus",isEqualTo: true).orderBy("createdDate").startAt([getFrom()]).endAt([getUntil()]).get().then((querySnapshot) {
      setState(() {
        ordersShipped1 = querySnapshot.size;
      });
      print("Collection users size: "+ querySnapshot.size.toString());
    });

    //to get the total number of orders pending to ship.
    FirebaseFirestore.instance.collection("orders").where("shipmentStatus",isEqualTo: false).orderBy("createdDate").startAt([getFrom()]).endAt([getUntil()]).get().then((querySnapshot) {
      setState(() {
        ordersPending1 = querySnapshot.size;
      });
      print("Collection users size: "+ querySnapshot.size.toString());
    });

    setState(() {

    });

      return Scaffold(
        backgroundColor: Colors.grey[100],
        // backgroundColor: Colors.grey[100],
        appBar: AppBar(
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("Admin Report",
            style: TextStyle(color: Colors.grey[800], fontSize: 20),),
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
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10,),
                  Center(
                    child: Text("Today's Report!", style: TextStyle(fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]),),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: <Widget>[
                      // Expanded(
                      //   child: InkWell(
                      //     onTap: () {
                      //
                      //     },
                      //     child: Container(
                      //       width: 100,
                      //       margin: EdgeInsets.only(right: 10),
                      //       decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           gradient: LinearGradient(
                      //               colors: [
                      //                 Colors.blue,
                      //                 Colors.blue.withOpacity(.7)
                      //               ]
                      //           )
                      //       ),
                      //       child: Padding(
                      //         padding: EdgeInsets.all(20.0),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: <Widget>[
                      //             Text("Add Products", style: TextStyle(
                      //                 color: Colors.white, fontSize: 30),
                      //               textAlign: TextAlign.center,),
                      //             // SizedBox(height: 20,),
                      //             // Text("3 500", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w100),),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Expanded(
                      //   child: InkWell(
                      //     onTap: () {
                      //
                      //     },
                      //     child: Container(
                      //       width: 100,
                      //       margin: EdgeInsets.only(left: 10),
                      //       decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           gradient: LinearGradient(
                      //               colors: [
                      //                 Colors.pink,
                      //                 Colors.red.withOpacity(.7)
                      //               ]
                      //           )
                      //       ),
                      //       child: Padding(
                      //         padding: EdgeInsets.all(20.0),
                      //         child: Column(
                      //           crossAxisAlignment: CrossAxisAlignment.start,
                      //           children: <Widget>[
                      //             Text("Delete Products", style: TextStyle(
                      //                 color: Colors.white, fontSize: 30),
                      //               textAlign: TextAlign.center,),
                      //             // SizedBox(height: 20,),
                      //             // Text("25 Min", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w100),),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),

                  SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        isOverallVisible=!isOverallVisible;
                      });
                    },
                    child: Text("Overall Report", style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Visibility(
                    visible: isOverallVisible? true : false,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]))
                              ),
                              child: Text("Total Users: "+users.toString(), style: TextStyle(color: Colors
                                  .grey[800], fontSize: 15, fontWeight: FontWeight
                                  .bold),),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]))
                              ),
                              child: Text("Total Products: "+products.toString(), style: TextStyle(color: Colors
                                  .grey[800], fontSize: 15, fontWeight: FontWeight
                                  .bold),),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]))
                              ),
                              child: Text("Total Orders Received: "+ordersReceived.toString(), style: TextStyle(color: Colors
                                  .grey[800], fontSize: 15, fontWeight: FontWeight
                                  .bold),),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]))
                              ),
                              child: Text("Total Orders Shipped: "+ordersShipped.toString(), style: TextStyle(color: Colors
                                  .grey[800], fontSize: 15, fontWeight: FontWeight
                                  .bold),),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]))
                              ),
                              child: Text("Total Orders Pending: "+ordersPending.toString(), style: TextStyle(color: Colors
                                  .grey[800], fontSize: 15, fontWeight: FontWeight
                                  .bold),),
                            ),

                            //to get the total revenue generated.
                            FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("orders")
                                  .get(),
                              builder: (c, dataSnapshot)
                              {
                                print("Inside the builder function");
                                if(dataSnapshot.hasData){
                                  print("snapshot has the data");
                                  orderItems= dataSnapshot.data.docs;
                                  print("Order items inside details");
                                  print("Order items"+orderItems.toString());
                                }
                                totRevenue = orderItems.map((amount){
                                  print("Inside the mappp");
                                  OrderModel orderModel = OrderModel.fromJson(amount.data());
                                  print("after the order model");
                                  return orderModel.totalAmount;
                                }).reduce((item1,item2) => item1 + item2 );

                                print("Total revenue is $totRevenue");
                                totProfit=(totRevenue)*(12/100);
                                print("Total profit is $totProfit");

                                return dataSnapshot.hasData ? Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(10),
                                      border: Border(bottom: BorderSide(
                                          color: Colors.grey[200]))
                                  ),
                                  child: Text("Total Revenue Generated:  ₹ $totRevenue", style: TextStyle(color: Colors
                                      .grey[800], fontSize: 15, fontWeight: FontWeight
                                      .bold),),
                                ) : Text("Null");
                              },
                            ),

                            //to get the total profit earned...
                            FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("orders")
                                  .get(),
                              builder: (c, dataSnapshot)
                              {
                                return dataSnapshot.hasData ? Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(10),
                                      border: Border(bottom: BorderSide(
                                          color: Colors.grey[200]))
                                  ),
                                  child: Text("Total Profit Earned:  ₹ $totProfit", style: TextStyle(color: Colors
                                      .grey[800], fontSize: 15, fontWeight: FontWeight
                                      .bold),),
                                ) : Text("Null");
                              },
                            ),
                            MaterialButton(
                              color: Colors.grey[400],
                                onPressed: (){
                                  Route route = MaterialPageRoute(builder: (c) => ReportPdfPage(users: users,products: products,oPending: ordersPending,oReceived: ordersReceived,oShipped: ordersShipped,totProfit: totProfit,totRevenue: totRevenue,title: 'iRESPAWN OVERALL REPORT', isOverall: true,));
                                  // Route route = MaterialPageRoute(builder: (c) => BarChartSample2());
                                  Navigator.push(context, route);
                                },
                              child: Center(child: Text("Download Report")),

                            ),
                          ]
                      ),
                    ),
                  ),
//------------------------------------------------------------------------------------------------//
                  //Specific reports....
                  SizedBox(height: 20,),
                  Center(
                    child: Text("Specific Reports!", style: TextStyle(fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]),),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      setState(() {
                        isParticularVisible=!isParticularVisible;
                      });
                    },
                    child: Text("Reports within a range of dates", style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 20,),
                  // Text("Select a range of dates below to view report:",style: TextStyle(fontSize: 15),),
                  // SizedBox(height: 15,),
                  Visibility(
                    visible: isParticularVisible? true : false,
                    child: HeaderWidget(
                      title: 'Select Date Range:',
                      child: Row(
                        children: [
                          Expanded(
                            child: ButtonWidget(
                              text: getFrom(),
                              onClicked: () => pickDateRange(context),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ButtonWidget(
                              text: getUntil(),
                              onClicked: () => pickDateRange(context),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Visibility(
                    visible: isParticularVisible? true : false,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]))
                              ),
                              child: Text("Total Users is: "+users1.toString(), style: TextStyle(color: Colors
                                  .grey[800], fontSize: 15, fontWeight: FontWeight
                                  .bold),),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]))
                              ),
                              child: Text("Total Products: "+products1.toString(), style: TextStyle(color: Colors
                                  .grey[800], fontSize: 15, fontWeight: FontWeight
                                  .bold),),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]))
                              ),
                              child: Text("Total Orders Received: "+ordersReceived1.toString(), style: TextStyle(color: Colors
                                  .grey[800], fontSize: 15, fontWeight: FontWeight
                                  .bold),),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]))
                              ),
                              child: Text("Total Orders Shipped: "+ordersShipped1.toString(), style: TextStyle(color: Colors
                                  .grey[800], fontSize: 15, fontWeight: FontWeight
                                  .bold),),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(10),
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]))
                              ),
                              child: Text("Total Orders Pending: "+ordersPending1.toString(), style: TextStyle(color: Colors
                                  .grey[800], fontSize: 15, fontWeight: FontWeight
                                  .bold),),
                            ),

                            //to get the total revenue generated.
                            FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("orders")
                                  .orderBy("createdDate").startAt([getFrom()]).endAt([getUntil()])
                                  .get(),
                              builder: (c, dataSnapshot)
                              {

                                  print("Inside the specific builder function");
                                  if(dataSnapshot.hasData){
                                    print("snapshot specific has the data");
                                    orderItems1= dataSnapshot.data.docs;
                                    print("Order items specific inside details");
                                    print("Order items specific"+orderItems1.toString());
                                  }
                                  print("After printing specific order details");

                                  if (orderItems1.isNotEmpty){
                                    print("order items  null");
                                    totRevenue1 = orderItems1.map((amount){
                                      print("Inside the mappp specific");
                                      OrderModel orderModel = OrderModel.fromJson(amount.data());
                                      print("after the order model specific");
                                      print("order totalam has amout");
                                      return orderModel.totalAmount;

                                    }).reduce((item1,item2) => item1 + item2 );

                                    print("Total revenue is $totRevenue1");
                                    totProfit1=(totRevenue1)*(12/100);
                                    print("Total profit is $totProfit1");

                                    return dataSnapshot.hasData ? Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(10),
                                          border: Border(bottom: BorderSide(
                                              color: Colors.grey[200]))
                                      ),
                                      child: Text("Total Revenue Generated:  ₹ $totRevenue1", style: TextStyle(color: Colors
                                          .grey[800], fontSize: 15, fontWeight: FontWeight
                                          .bold),),
                                    ) : Text("Null");
                                  }

                                  else{
                                    print("order items1 not null");
                                    return dataSnapshot.hasData ? Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(10),
                                          border: Border(bottom: BorderSide(
                                              color: Colors.grey[200]))
                                      ),
                                      child: Text("Total Revenue Generated:  ₹ 0", style: TextStyle(color: Colors
                                          .grey[800], fontSize: 15, fontWeight: FontWeight
                                          .bold),),
                                    ) : Text("Null");
                                  }


                              },
                            ),

                            //to get the total profit earned...
                            FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("orders")
                                  .orderBy("createdDate").startAt([getFrom()]).endAt([getUntil()])
                                  .get(),
                              builder: (c, dataSnapshot)
                              {

                                if(totProfit1==null){
                                  return Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(10),
                                        border: Border(bottom: BorderSide(
                                            color: Colors.grey[200]))
                                    ),
                                    child: Text("Total Profit Earned:  ₹ 0", style: TextStyle(color: Colors
                                        .grey[800], fontSize: 15, fontWeight: FontWeight
                                        .bold),),
                                  );
                                  // return CircularProgressIndicator();
                                }
                                else{
                                  return Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(10),
                                        border: Border(bottom: BorderSide(
                                            color: Colors.grey[200]))
                                    ),
                                    child: Text("Total Profit Earned:  ₹ $totProfit1", style: TextStyle(color: Colors
                                        .grey[800], fontSize: 15, fontWeight: FontWeight
                                        .bold),),
                                  );
                                }
                              },
                            ),

                            MaterialButton(
                              color: Colors.grey[400],
                              onPressed: (){
                                Route route = MaterialPageRoute(builder: (c) => ReportPdfPage(users: users1,products: products1,oPending: ordersPending1,oReceived: ordersReceived1,oShipped: ordersShipped1,totProfit: totProfit1,totRevenue: totRevenue1,title: 'iRESPAWN SPECIFIC REPORT',isOverall: false,date1: getFrom(), date2: getUntil(),));
                                // Route route = MaterialPageRoute(builder: (c) => BarChartSample2());
                                Navigator.push(context, route);
                              },
                              child: Center(child: Text("Download Report")),

                            ),
                          ]
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      );
  }

  //date picker function....
  String getFrom() {
    if (dateRange == null) {
      return 'From';
      // return DateFormat('dd-MM-yyyy').format(DateTime.now());
      // return '15-07-2021';
    } else {
      return DateFormat('dd-MM-yyyy').format(dateRange.start);
    }
  }

  String getUntil() {
    if (dateRange == null) {
      return 'Until';
      // return DateFormat('dd-MM-yyyy').format(DateTime( DateTime.now().day +4) );
      // return '17-07-2021';
    } else {
      return DateFormat('dd-MM-yyyy').format(dateRange.end);
    }
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange =
    DateTimeRange(
      start: DateTime.now(),
      end: DateTime.now().add(Duration(hours: 24 * 7)),
    );
    final newDateRange = await showDateRangePicker(
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.yellow,
            ),
            // dialogBackgroundColor:Colors.blue[900],
            dialogBackgroundColor:Colors.grey,
          ),
          child: child,
        );
      },
      context: context,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDateRange: dateRange ?? initialDateRange,
    );

    if (newDateRange == null) return;


    setState(() => dateRange = newDateRange);



  }

  // getUsers(){
  //   //to get the number of users..
  //   FirebaseFirestore.instance.collection("users").orderBy("createdDate").startAt([getFrom()]).endAt([getUntil()]).get().then((querySnapshot) {
  //     // users1 = querySnapshot.size;
  //     print("Collection users size: "+ querySnapshot.size.toString());
  //     // return querySnapshot.size;
  //     users1 = querySnapshot.size;
  //     print("users variable: "+ users1.toString());
  //   });
  //   return users1;
  // }
  //
  // getProducts(){
  //   //to get tge total number of products available in the database
  //   FirebaseFirestore.instance.collection("products").orderBy("createdDate").startAt([getFrom()]).endAt([getUntil()]).get().then((querySnapshot) {
  //     // products1 = querySnapshot.size;
  //     print("Collection products size: "+ querySnapshot.size.toString());
  //     products1 = querySnapshot.size;
  //   });
  //   return products1;
  //
  // }
  //
  // getTotalOrders(){
  //   //to get the total number of orders received...
  //   FirebaseFirestore.instance.collection("orders").orderBy("createdDate").startAt([getFrom()]).endAt([getUntil()]).get().then((querySnapshot) {
  //     // ordersReceived1 = querySnapshot.size;
  //     print("Collection totorders size: "+ querySnapshot.size.toString());
  //     ordersReceived1 = querySnapshot.size;
  //   });
  //   return ordersReceived1 ;
  // }
  //
  //
  // getOrdersShipped(){
  //   //to get the total number of orders shipped.
  //   FirebaseFirestore.instance.collection("orders").where("shipmentStatus",isEqualTo: true).orderBy("createdDate").startAt([getFrom()]).endAt([getUntil()]).get().then((querySnapshot) {
  //     // ordersShipped1 = querySnapshot.size;
  //     print("Collection ordersshipped size: "+ querySnapshot.size.toString());
  //     ordersShipped1 = querySnapshot.size;
  //   });
  //   return ordersShipped1;
  //
  // }
  //
  // getOrdersPending(){
  //   //to get the total number of orders pending to ship.
  //   FirebaseFirestore.instance.collection("orders").where("shipmentStatus",isEqualTo: false).orderBy("createdDate").startAt([getFrom()]).endAt([getUntil()]).get().then((querySnapshot) {
  //     // ordersPending1 = querySnapshot.size;
  //     print("Collection orderspending size: "+ querySnapshot.size.toString());
  //     // return querySnapshot.size;
  //     ordersPending1 = querySnapshot.size;
  //   });
  //   return ordersPending1;
  // }


}
