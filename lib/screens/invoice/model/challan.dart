import 'package:admin/screens/invoice/model/supplier.dart';

import 'customer.dart';

class Challan {
  final ChallanInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<ChallanItem> items;

  const Challan({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class ChallanInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const ChallanInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
  });
}

class ChallanItem {
  final String challanNo;
  final String grNo;
  final String branchName;
  final DateTime challanDate;
  final String consignorName;
  final String consigneeName;
  final String pkg;
  final String weight;
  final String freight;
  final String destination;
  final String truckNumber;
  final String agentName;
  final String truckDestination;
  final String driverName;
  final String truckFreight;
  final String advanceAmount;
  final String commission;
  final String crossingFreight;

  const ChallanItem({
    required this.challanNo,
    required this.grNo,
    required this.branchName,
    required this.challanDate,
    required this.consigneeName,
    required this.consignorName,
    required this.pkg,
    required this.weight,
    required this.freight,
    required this.destination,
    required this.truckNumber,
    required this.agentName,
    required this.truckDestination,
    required this.driverName,
    required this.truckFreight,
    required this.advanceAmount,
    required this.commission,
    required this.crossingFreight,
  });
}
