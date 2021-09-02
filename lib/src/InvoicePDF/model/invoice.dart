import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:irespawn/src/InvoicePDF/model/supplier.dart';
import 'customer.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<DocumentSnapshot> items ;
  final double totalamout;

  const Invoice({
    this.totalamout,
    this.info,
    this.supplier,
    this.customer,
    this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    this.description,
    this.number,
    this.date,
    this.dueDate,
  });
}

class InvoiceItem {
  final String description;
  final DateTime date;
  final int quantity;
  final double vat;
  final double unitPrice;

  const InvoiceItem({
    this.description,
    this.date,
    this.quantity,
    this.vat,
    this.unitPrice,
  });
}
