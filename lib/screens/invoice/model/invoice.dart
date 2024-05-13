import 'package:admin/screens/invoice/model/supplier.dart';

import 'customer.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
  });
}

class InvoiceItem {
  final String grNo;
  final DateTime bookingDate;
  final String bookingBranch;
  final String destination;
  final String consignorName;
  final String consignorGST;
  final String consigneeName;
  final String consigneeGST;
  final double quantity;
  final String packing;
  final String desc;
  final String weight;
  final double unitPrice;

  const InvoiceItem({
    required this.grNo,
    required this.bookingDate,
    required this.bookingBranch,
    required this.destination,
    required this.consigneeName,
    required this.consigneeGST,
    required this.consignorName,
    required this.consignorGST,
    required this.quantity,
    required this.packing,
    required this.desc,
    required this.weight,
    required this.unitPrice,
  });
}
