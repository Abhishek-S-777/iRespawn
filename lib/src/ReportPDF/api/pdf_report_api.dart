import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:irespawn/src/Admin/adminOrderDetails.dart';
import 'package:irespawn/src/InvoicePDF/api/pdf_api.dart';
import 'package:irespawn/src/InvoicePDF/model/customer.dart';
import 'package:irespawn/src/InvoicePDF/model/invoice.dart';
import 'package:irespawn/src/InvoicePDF/model/supplier.dart';
import 'package:irespawn/src/InvoicePDF/utils.dart';
import 'package:irespawn/src/ReportPDF/model/report.dart';
import 'package:irespawn/src/ReportPDF/model/supplierr.dart';
import 'package:irespawn/src/model/item.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfReportApi {

  String reportIDD = '178863544677333';
  static Future<File> generate(
      String date1,
      String date2,
      bool isOverall,
      String title,
      Report report,
      int users,
      int products,
      int oReceived,
      int oShipped,
      int oPending,
      var totRevenue,
      var totProfit,
      // String reportID
      ) async
  {
    final pdf = Document();
    final imagePNG = (await rootBundle.load('assets/signature/mysignature1.png')).buffer.asUint8List();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (context) => [
        buildHeader(report),
        SizedBox(height: 1.5 * PdfPageFormat.cm),
        buildTitle(date1,date2,users,isOverall,products,oReceived,oShipped,oPending,totRevenue,totProfit,report,title),
        // buildInvoice(invoice),
        Divider(),
        // buildTotal(invoice),
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
      footer: (context) => buildFooter(report),
    ));

    return PdfApi.saveDocument(name: 'Invoice 178863544677333 .pdf', pdf: pdf);
  }


  static Widget buildHeader(Report report) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 1 * PdfPageFormat.cm),
      buildSimpleText(title: "Report ID: ",value: '178863544677333'),
      buildSimpleText(title: "Report Date: ",value: DateFormat('dd-MM-yyyy').format(DateTime.now())),
      SizedBox(height: 1.1 * PdfPageFormat.cm),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildSupplierAddress(report.supplierr),
          Container(
            height: 50,
            width: 50,
            child: BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: "Thank you, report generated successfully",
            ),
          ),
          // buildCustomerAddress(invoice.customer),

        ],
      ),
      SizedBox(height: 1 * PdfPageFormat.cm),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

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

  static Widget buildSupplierAddress(Supplierr supplierr) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(supplierr.heading, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
      Text(supplierr.name, style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 1 * PdfPageFormat.mm),
      Text(supplierr.address),
    ],
  );

  static Widget buildTitle(
      String date1,
      String date2,
      int users,
      bool isOverall,
      int products,
      int oReceived,
      int oShipped,
      int oPending,
      var totRevenue,
      var totProfit,
      Report report,
      String title,
      ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      isOverall?Text(""):Text("For the Dates: $date1 to $date2 ",style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold) ),
      SizedBox(height: 1.5 * PdfPageFormat.cm),
      buildSimpleText2(title: "Total No of users: ",value: users.toString()),
      pw.SizedBox(height: 10),
      buildSimpleText2(title: "Total No of Products: ",value: products.toString()),
      pw.SizedBox(height: 10),
      buildSimpleText2(title: "Total No of Orders Received: ",value: oReceived.toString()),
      pw.SizedBox(height: 10),
      buildSimpleText2(title: "Total No of Orders Shipped: ",value: oShipped.toString()),
      pw.SizedBox(height: 10),
      buildSimpleText2(title: "Total No of Orders Pending: ",value: oPending.toString()),
      pw.SizedBox(height: 10),
      buildSimpleText2(title: "Total Revenue Generated: ",value: "Rs. "+ totRevenue.toString()),
      pw.SizedBox(height: 10),
      buildSimpleText2(title: "Total Profit Earned: ",value: "Rs. "+totProfit.toString()),
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

  static Widget buildFooter(Report report) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Divider(),
      SizedBox(height: 2 * PdfPageFormat.mm),
      buildSimpleText(title: 'Contact', value: "irespawn777@gmail.com"),
      SizedBox(height: 1 * PdfPageFormat.mm),
      buildSimpleText(title: 'Address', value: report.admin.contact),
      // SizedBox(height: 1 * PdfPageFormat.mm),
      // buildSimpleText(title: 'Payment Type', value: report.supplier.paymentInfo),
    ],
  );

  static buildSimpleText({String title, String value})
  {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
        // SizedBox(width: 1.9 * PdfPageFormat.mm),

      ],
    );
  }
  static buildSimpleText2({String title, String value,})
  {
    final style = TextStyle(fontWeight: FontWeight.bold,fontSize: 17);
    final style1 = TextStyle(fontSize: 17);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value,style: style1),
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
