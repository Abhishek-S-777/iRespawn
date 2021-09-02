
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/ReportPDF/api/pdf_api_new.dart';
import 'package:irespawn/src/ReportPDF/api/pdf_report_api.dart';
import 'package:irespawn/src/ReportPDF/model/admin_info.dart';
import 'package:irespawn/src/ReportPDF/model/report.dart';
import 'package:irespawn/src/ReportPDF/model/supplierr.dart';
import 'package:irespawn/src/ReportPDF/widget/button_widget.dart';
import 'package:irespawn/src/ReportPDF/widget/title_widget.dart';

// ignore: must_be_immutable
class ReportPdfPage extends StatefulWidget {


  final String date1;
  final String date2;
  final int users;
  final int products;
  final int oReceived;
  final int oShipped;
  final int oPending;
  final String title;
  final bool isOverall;

  var totRevenue;
  var totProfit;

  ReportPdfPage({Key key,this.date1,this.date2,this.isOverall,this.title,this.users,this.products,this.oReceived,this.oShipped,this.oPending,this.totRevenue,this.totProfit}) : super(key: key);

  @override
  _ReportPdfPageState createState() => _ReportPdfPageState();
}

class _ReportPdfPageState extends State<ReportPdfPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      title: Text("iRespawn"),
      centerTitle: true,
    ),
    body: Container(
      padding: EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleWidget(
              icon: Icons.picture_as_pdf,
              text: 'Report',
            ),
            const SizedBox(height: 48),
            ButtonWidget(
              text: 'Download Report PDF',
              onClicked: () async {
                final date = DateTime.now();
                final dueDate = date.add(Duration(days: 7));

                final report = Report(
                  admin: AdminInfo(
                    name: 'Abhishek S',
                    contact: 'Signet, K.R.C Road, Bangalore-77'
                  ),
                  supplierr: Supplierr(
                    heading: 'Admin Info:',
                    name: 'Abhishek S',
                    address: 'Bangalore,\nirespawn777@gmail.com',
                    paymentInfo: 'RazorPay Payment Gateway',
                  ),
                  info: ReportInfo(
                    date: date,
                    dueDate: dueDate,
                    description: 'Enjoy your purchase, Thank you!',
                    number: '${DateTime.now().year}',
                  ),
                  // items: widget.orderItems3 != null ? widget.orderItems3 : null,
                  // InvoiceItem(
                  //   description: 'Coffee',
                  //   date: DateTime.now(),
                  //   quantity: 1,
                  //   vat: 0.0,
                  //   unitPrice: 5.99,
                  // ),
                  // InvoiceItem(
                  //   description: 'Water',
                  //   date: DateTime.now(),
                  //   quantity: 8,
                  //   vat: 0.19,
                  //   unitPrice: 0.99,
                  // ),
                  // InvoiceItem(
                  //   description: 'Orange',
                  //   date: DateTime.now(),
                  //   quantity: 3,
                  //   vat: 0.19,
                  //   unitPrice: 2.99,
                  // ),
                  // InvoiceItem(
                  //   description: 'Apple',
                  //   date: DateTime.now(),
                  //   quantity: 8,
                  //   vat: 0.19,
                  //   unitPrice: 3.99,
                  // ),
                  // InvoiceItem(
                  //   description: 'Mango',
                  //   date: DateTime.now(),
                  //   quantity: 1,
                  //   vat: 0.19,
                  //   unitPrice: 1.59,
                  // ),
                  // InvoiceItem(
                  //   description: 'Blue Berries',
                  //   date: DateTime.now(),
                  //   quantity: 5,
                  //   vat: 0.19,
                  //   unitPrice: 0.99,
                  // ),
                  // InvoiceItem(
                  //   description: 'Lemon',
                  //   date: DateTime.now(),
                  //   quantity: 4,
                  //   vat: 0.19,
                  //   unitPrice: 1.29,
                  // ),

                );

                // print("invoice object pdf page is: $invoice");
                // print("order id pdf page is: "+widget.orderID);
                // print("order items pdf page is: "+widget.orderItems3.toString());
                // print("address pdf page is: "+widget.model2.flatNumber);
                final pdfFile = await PdfReportApi.generate(widget.date1,widget.date2,widget.isOverall, widget.title,report,widget.users,widget.products,widget.oReceived,widget.oShipped,widget.oPending,widget.totRevenue,widget.totProfit);
                ReportApi.openFile(pdfFile);
                ReportApi.sendMail2(pdfFile,'178863544677333');
                Fluttertoast.showToast(msg: "A copy of the generated report has been sent to your mail\nand saved to Downloads.\nThank You. ",timeInSecForIos: 3);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
