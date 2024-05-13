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
        challanDate: DateTime.parse(challanDateController.text),
        // challanDate: DateTime.now(),
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
          actions: [
            ElevatedButton(
              onPressed: _addItem,
              child: Text('+ Add Item'),
            ),
            SizedBox(width: 20),
          ],
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                controller: challanNumberController,
                                decoration: InputDecoration(
                                    labelText: 'Challan Number'),
                              ),
                              TextFormField(
                                controller: challanDateController,
                                decoration:
                                    InputDecoration(labelText: 'Challan Date'),
                                readOnly:
                                    true, // Ensure the field is read-only to prevent manual input
                                onTap: () async {
                                  // Show date picker and wait for the user to select a date
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );

                                  // Update the controller value if a date is selected
                                  if (pickedDate != null) {
                                    setState(() {
                                      challanDateController.text = pickedDate
                                          .toString(); // Update the text field with the selected date
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextField(
                            controller: branchNameController,
                            decoration:
                                InputDecoration(labelText: 'Branch Name'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: consignorNameController,
                            decoration:
                                InputDecoration(labelText: 'Consignor Name'),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextField(
                            controller: consigneeNameController,
                            decoration:
                                InputDecoration(labelText: 'Consignee Name'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: grNumberController,
                            decoration: InputDecoration(labelText: 'G.R. No'),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 70,
                          child: TextField(
                            controller: pkgController,
                            decoration: InputDecoration(labelText: 'Pkg'),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: weightController,
                            decoration: InputDecoration(labelText: 'Weight'),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: freightController,
                            decoration: InputDecoration(labelText: 'Freight'),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: destinationController,
                            decoration:
                                InputDecoration(labelText: 'Destination'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                controller: truckNumberController,
                                decoration:
                                    InputDecoration(labelText: 'Truck Number'),
                              ),
                              TextField(
                                controller: agentNameController,
                                decoration:
                                    InputDecoration(labelText: 'Agent Name'),
                              ),
                              TextField(
                                controller: truckDestinationController,
                                decoration: InputDecoration(
                                    labelText: 'Truck Destination'),
                              ),
                              TextField(
                                controller: driverNameController,
                                decoration:
                                    InputDecoration(labelText: 'Driver Name'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              TextField(
                                controller: truckFreightController,
                                decoration:
                                    InputDecoration(labelText: 'Truck Freight'),
                              ),
                              TextField(
                                controller: advanceAmountController,
                                decoration: InputDecoration(
                                    labelText: 'Advance Amount'),
                              ),
                              TextField(
                                controller: commissionController,
                                decoration:
                                    InputDecoration(labelText: 'Commission'),
                              ),
                              TextField(
                                controller: crossingFreightController,
                                decoration: InputDecoration(
                                    labelText: 'Crossing Freight'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                child: ButtonWidget(
                  text: 'Generate Challan PDF   ->',
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
              ),
            ],
          ),
        ),
      );
}
