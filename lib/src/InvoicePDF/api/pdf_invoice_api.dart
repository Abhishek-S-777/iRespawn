import 'dart:io';
import 'package:flutter/services.dart';
import 'package:irespawn/src/Admin/adminOrderDetails.dart';
import 'package:irespawn/src/InvoicePDF/api/pdf_api.dart';
import 'package:irespawn/src/InvoicePDF/model/customer.dart';
import 'package:irespawn/src/InvoicePDF/model/invoice.dart';
import 'package:irespawn/src/InvoicePDF/model/supplier.dart';
import 'package:irespawn/src/InvoicePDF/utils.dart';
import 'package:irespawn/src/model/item.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {

  static Future<File> generate(Invoice invoice, String OrderID) async {
    final pdf = Document();
    final imagePNG = (await rootBundle.load('assets/signature/mysignature1.png')).buffer.asUint8List();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        buildHeader(invoice,OrderID),
        SizedBox(height: 1.5 * PdfPageFormat.cm),
        buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
        Container(
            alignment: Alignment.centerRight,
            child: Column(
                children: [
                  SizedBox(height: 35.0),
                  Text("Authorized Signatory"),
                  SizedBox(height: 5.0),
                  Image(
                    MemoryImage(imagePNG),
                    width: 85.0,
                    height: 85.0,
                  ),
                ]
            )
        ),
      ],
      footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'Invoice $OrderID.pdf', pdf: pdf);
  }


  static Widget buildHeader(Invoice invoice, String OrderID1) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 1 * PdfPageFormat.cm),
      buildSimpleText2(title: "Invoice Number: ",value: OrderID1),
      buildSimpleText2(title: "Invoice Date: ",value: Utils.formatDate(DateTime.now())),
      SizedBox(height: 1.1 * PdfPageFormat.cm),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildSupplierAddress(invoice.supplier),
          buildCustomerAddress(invoice.customer),

        ],
      ),
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 50,
            width: 50,
            child: BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: "Thank you, "+invoice.customer.name+"\n"+ "your purchase is successful for the order ID: "+"\n"+OrderID1,
            ),
          ),
          // buildInvoiceInfo(invoice.info),
        ],
      ),
    ],
  );

  static Widget buildCustomerAddress(Customer customer) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(customer.heading, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
      Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
      Text(customer.address),
    ],
  );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      'Payment Terms:',
      'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(supplier.heading, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
      Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Text(supplier.address),
    ],
  );

  static Widget buildTitle(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'iRESPAWN PURCHASE INVOICE',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
      Text(invoice.info.description),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
    ],
  );

  static Widget buildInvoice(Invoice invoice) {
    final headerss = [
      'Product',
      'Date',
      'Qty',
      'Unit Price',
      'GST',
      'Total'
    ];

    final data = invoice.items.map((item) {
      ItemModel model = ItemModel.fromJson(item.data());
      final total = model.price;

      return [
        model.title,
        DateTime.now(),
        '${1}',
        'Rs. ${model.price}',
        '${0} %',
        'Rs. ${total.toStringAsFixed(2)}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headerss,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {

    // final netTotal = invoice.items
    //     .map((item) => item.unitPrice * item.quantity)
    //     .reduce((item1, item2) => item1 + item2);
    //
    // final netTotal = invoice.items.map((item){
    //   ItemModel model = ItemModel.fromJson(item.data());
    //   return model.price;}).reduce((item1, item2) => item1+item2);

    final netTotal=invoice.totalamout;
    final vatPercent = 0;
    final vat = netTotal * vatPercent;
    final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: Utils.formatPrice(netTotal),
                  unite: true,
                ),
                buildText(
                  title: 'GST ${vatPercent * 100} %',
                  value: Utils.formatPrice(vat),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'Grand Total',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: Utils.formatPrice(total),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
      buildSimpleText(title: 'Contact', value: "irespawn777@gmail.com"),
      SizedBox(height: 1 * PdfPageFormat.mm),
      // buildSimpleText(title: 'Address', value: invoice.supplier.address),
      // SizedBox(height: 1 * PdfPageFormat.mm),
      buildSimpleText(title: 'Payment Type', value: invoice.supplier.paymentInfo),
    ],
  );

  static buildSimpleText({String title, String value,})
  {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }
  static buildSimpleText2({String title, String value,})
  {
    final style = TextStyle(fontWeight: FontWeight.bold,fontSize: 15);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    String title,
    String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
