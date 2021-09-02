
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:irespawn/src/InvoicePDF/api/pdf_api.dart';
import 'package:irespawn/src/InvoicePDF/api/pdf_invoice_api.dart';
import 'package:irespawn/src/InvoicePDF/model/customer.dart';
import 'package:irespawn/src/InvoicePDF/model/invoice.dart';
import 'package:irespawn/src/InvoicePDF/model/supplier.dart';
import 'package:irespawn/src/InvoicePDF/widget/button_widget.dart';
import 'package:irespawn/src/InvoicePDF/widget/title_widget.dart';
import 'package:irespawn/src/model/addressmodel.dart';

class PdfPage extends StatefulWidget {

  final AddressModel model2;
  final List<DocumentSnapshot> orderItems3;
  final double totamt1;
  final String orderID;
  PdfPage({Key key, this.model2, this.orderItems3,this.totamt1,this.orderID}) : super(key: key);


  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
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
              text: 'Invoice',
            ),
            const SizedBox(height: 48),
            ButtonWidget(
              text: 'Download Invoice PDF',
              onClicked: () async {
                final date = DateTime.now();
                final dueDate = date.add(Duration(days: 7));

                final invoice = Invoice(
                  totalamout: widget.totamt1,
                  supplier: Supplier(
                    heading: 'Retailer Info:',
                    name: 'Abhishek S',
                    address: 'Signet, No:122, K.R.C Road,\ndoddagubbi main road and post\nBangalore-560077',
                    paymentInfo: 'RazorPay Payment Gateway',
                  ),
                  customer: Customer(
                    heading: 'Customer Info:',
                    name: widget.model2.name,
                    address: widget.model2.flatNumber +","+ widget.model2.street.toString()+","+"\n"+widget.model2.landmark+","+"\n"+widget.model2.city+" - "+widget.model2.pincode,
                  ),
                  info: InvoiceInfo(
                    date: date,
                    dueDate: dueDate,
                    description: 'Enjoy your purchase, Thank you!',
                    number: '${DateTime.now().year}',
                  ),
                  items: widget.orderItems3 != null ? widget.orderItems3 : null,
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
                final pdfFile = await PdfInvoiceApi.generate(invoice,widget.orderID);
                PdfApi.openFile(pdfFile);
                PdfApi.sendMail(pdfFile,widget.orderID);
                Fluttertoast.showToast(msg: "A copy of your invoice has been sent to your registered mail\nand saved to Downloads ",timeInSecForIos: 3);
              },
            ),
          ],
        ),
      ),
    ),
  );
}
