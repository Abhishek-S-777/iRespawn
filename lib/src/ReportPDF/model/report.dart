import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:irespawn/src/InvoicePDF/model/supplier.dart';
import 'package:irespawn/src/ReportPDF/model/supplierr.dart';
import 'admin_info.dart';

class Report {
  final ReportInfo info;
  final Supplierr supplierr;
  final AdminInfo admin;


  const Report({
    this.info,
    this.supplierr,
    this.admin,
  });
}

class ReportInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const ReportInfo({
    this.description,
    this.number,
    this.date,
    this.dueDate,
  });
}

class ReportItem {
  final String description;
  final DateTime date;
  final int quantity;
  final double vat;
  final double unitPrice;

  const ReportItem({
    this.description,
    this.date,
    this.quantity,
    this.vat,
    this.unitPrice,
  });
}
