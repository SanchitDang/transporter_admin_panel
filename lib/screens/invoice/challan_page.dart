import 'package:admin/screens/invoice/widget/button_widget.dart';
import 'package:flutter/material.dart';

import 'api/pdf_api.dart';
import 'api/pdf_challan_api.dart';
import 'model/challan.dart';
import 'model/customer.dart';
import 'model/supplier.dart';

class ChallanPage extends StatefulWidget {
  @override
  _ChallanPageState createState() => _ChallanPageState();
}

class _ChallanPageState extends State<ChallanPage> {
  final List<ChallanItem> items = [];

  final TextEditingController grNumberController = TextEditingController();
  final TextEditingController challanNumberController = TextEditingController();
  final TextEditingController branchNameController = TextEditingController();
  final TextEditingController challanDateController = TextEditingController();
  final TextEditingController consignorNameController = TextEditingController();
  final TextEditingController consigneeNameController = TextEditingController();
  final TextEditingController pkgController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController freightController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController truckNumberController = TextEditingController();
  final TextEditingController agentNameController = TextEditingController();
  final TextEditingController truckDestinationController =
      TextEditingController();
  final TextEditingController driverNameController = TextEditingController();
  final TextEditingController truckFreightController = TextEditingController();
  final TextEditingController advanceAmountController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();
  final TextEditingController crossingFreightController =
      TextEditingController();

  void _addItem() {
    setState(() {
      items.add(ChallanItem(
        challanNo: challanNumberController.text,
        grNo: grNumberController.text,
        branchName: branchNameController.text,
        // challanDate: DateTime.parse(challanDateController.text),
        challanDate: DateTime.now(),
        consignorName: consignorNameController.text,
        consigneeName: consigneeNameController.text,
        pkg: pkgController.text,
        weight: weightController.text,
        freight: freightController.text,
        destination: destinationController.text,
        truckNumber: truckNumberController.text,
        agentName: agentNameController.text,
        truckDestination: truckDestinationController.text,
        driverName: driverNameController.text,
        truckFreight: truckFreightController.text,
        advanceAmount: advanceAmountController.text,
        commission: commissionController.text,
        crossingFreight: crossingFreightController.text,
      ));

      // Clear all controllers after adding item
      grNumberController.clear();
      challanNumberController.clear();
      branchNameController.clear();
      challanDateController.clear();
      consignorNameController.clear();
      consigneeNameController.clear();
      pkgController.clear();
      weightController.clear();
      freightController.clear();
      destinationController.clear();
      truckNumberController.clear();
      agentNameController.clear();
      truckDestinationController.clear();
      driverNameController.clear();
      truckFreightController.clear();
      advanceAmountController.clear();
      commissionController.clear();
      crossingFreightController.clear();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Challan"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: grNumberController,
                      decoration: InputDecoration(labelText: 'G.R. Number'),
                    ),
                    TextField(
                      controller: challanNumberController,
                      decoration: InputDecoration(labelText: 'Challan Number'),
                    ),
                    TextField(
                      controller: branchNameController,
                      decoration: InputDecoration(labelText: 'Branch Name'),
                    ),
                    TextField(
                      controller: challanDateController,
                      decoration: InputDecoration(labelText: 'Challan Date'),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextField(
                      controller: consignorNameController,
                      decoration: InputDecoration(labelText: 'Consignor Name'),
                    ),
                    TextField(
                      controller: consigneeNameController,
                      decoration: InputDecoration(labelText: 'Consignee Name'),
                    ),
                    TextField(
                      controller: pkgController,
                      decoration: InputDecoration(labelText: 'Pkg'),
                    ),
                    TextField(
                      controller: weightController,
                      decoration: InputDecoration(labelText: 'Weight'),
                    ),
                    TextField(
                      controller: freightController,
                      decoration: InputDecoration(labelText: 'Freight'),
                    ),
                    TextField(
                      controller: destinationController,
                      decoration: InputDecoration(labelText: 'Destination'),
                    ),
                    TextField(
                      controller: truckNumberController,
                      decoration: InputDecoration(labelText: 'Truck Number'),
                    ),
                    TextField(
                      controller: agentNameController,
                      decoration: InputDecoration(labelText: 'Agent Name'),
                    ),
                    TextField(
                      controller: truckDestinationController,
                      decoration:
                          InputDecoration(labelText: 'Truck Destination'),
                    ),
                    TextField(
                      controller: driverNameController,
                      decoration: InputDecoration(labelText: 'Driver Name'),
                    ),
                    TextField(
                      controller: truckFreightController,
                      decoration: InputDecoration(labelText: 'Truck Freight'),
                    ),
                    TextField(
                      controller: advanceAmountController,
                      decoration: InputDecoration(labelText: 'Advance Amount'),
                    ),
                    TextField(
                      controller: commissionController,
                      decoration: InputDecoration(labelText: 'Commission'),
                    ),
                    TextField(
                      controller: crossingFreightController,
                      decoration:
                          InputDecoration(labelText: 'Crossing Freight'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _addItem,
                      child: Text('Add Item'),
                    ),
                    SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          title: Text(item.pkg),
                          subtitle: Text('Weight: ${item.weight}'),
                        );
                      },
                    ),
                  ],
                ),
              ),
              ButtonWidget(
                text: 'Invoice PDF',
                onClicked: () async {
                  final date = DateTime.now();
                  final dueDate = date.add(Duration(days: 7));

                  final invoice = Challan(
                    supplier: Supplier(
                      name: 'Sarah Field',
                      address: 'Sarah Street 9, Beijing, China',
                      paymentInfo: 'https://paypal.me/sarahfieldzz',
                    ),
                    customer: Customer(
                      name: 'Apple Inc.',
                      address: 'Apple Street, Cupertino, CA 95014',
                    ),
                    info: ChallanInfo(
                      date: date,
                      dueDate: dueDate,
                      description: 'My description...',
                      number: '${DateTime.now().year}-9999',
                    ),
                    items: items,
                  );

                  final pdfFile = await PdfInvoiceApi.generate(invoice);
                  PdfApi.openFile(pdfFile);
                },
              ),
            ],
          ),
        ),
      );
}
