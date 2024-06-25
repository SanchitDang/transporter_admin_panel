import 'package:admin/screens/invoice/widget/button_widget.dart';
import 'package:flutter/material.dart';

import 'api/pdf_api.dart';
import 'api/pdf_invoice_api.dart';
import 'model/customer.dart';
import 'model/invoice.dart';
import 'model/supplier.dart';

class InvoicePage extends StatefulWidget {
  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  final List<InvoiceItem> items = [];

  final TextEditingController grNumberController = TextEditingController();
  final TextEditingController bookingDateController = TextEditingController();
  final TextEditingController bookingBranchController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController consignorNameController = TextEditingController();
  final TextEditingController consignorGSTController = TextEditingController();
  final TextEditingController consigneeNameController = TextEditingController();
  final TextEditingController consigneeGSTController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController packingController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController unitPriceController = TextEditingController();

  void _addItem() {
    setState(() {
      items.add(InvoiceItem(
        grNo: grNumberController.text,
        // bookingDate: DateTime.parse(bookingDateController.text),
        bookingDate: DateTime.now(),
        bookingBranch: bookingBranchController.text,
        destination: destinationController.text,
        consignorName: consignorNameController.text,
        consignorGST: consignorGSTController.text,
        consigneeName: consigneeNameController.text,
        consigneeGST: consigneeGSTController.text,
        quantity: double.parse(quantityController.text),
        packing: packingController.text,
        desc: descController.text,
        weight: weightController.text,
        unitPrice: double.parse(unitPriceController.text),
      ));

      // Clear all controllers after adding item
      grNumberController.clear();
      bookingDateController.clear();
      bookingBranchController.clear();
      destinationController.clear();
      consignorNameController.clear();
      consignorGSTController.clear();
      consigneeNameController.clear();
      consigneeGSTController.clear();
      quantityController.clear();
      packingController.clear();
      descController.clear();
      weightController.clear();
      unitPriceController.clear();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Invoice"),
          centerTitle: true,
          actions: [
            ElevatedButton(
              onPressed: _addItem,
              child: Text('+ Add Item'),
            ),
            SizedBox(width: 16),
          ],
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
                      children: [
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: grNumberController,
                            decoration: InputDecoration(labelText: 'G.R No'),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 120,
                          child: TextFormField(
                            controller: bookingDateController,
                            decoration:
                                InputDecoration(labelText: 'Challan Date'),
                            readOnly:
                                true, // Ensure the field is read-only to prevent manual input
                            onTap: () async {
                              // Show date picker and wait for the user to select a date
                              final DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );

                              // Update the controller value if a date is selected
                              if (pickedDate != null) {
                                setState(() {
                                  bookingDateController.text = pickedDate
                                      .toString(); // Update the text field with the selected date
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextField(
                            controller: bookingBranchController,
                            decoration:
                                InputDecoration(labelText: 'Booking Branch'),
                            keyboardType: TextInputType.datetime,
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
                            controller: descController,
                            decoration: InputDecoration(labelText: 'Description'),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextField(
                            controller: destinationController,
                            decoration: InputDecoration(labelText: 'Destination'),
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
                                controller: consignorNameController,
                                decoration:
                                    InputDecoration(labelText: 'Consignor Name'),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextField(
                                controller: consignorGSTController,
                                decoration:
                                    InputDecoration(labelText: 'Consignor GST'),
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
                                controller: consigneeNameController,
                                decoration:
                                    InputDecoration(labelText: 'Consignee Name'),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextField(
                                controller: consigneeGSTController,
                                decoration:
                                    InputDecoration(labelText: 'Consignee GST'),
                              ),
                            ],
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
                            controller: quantityController,
                            decoration: InputDecoration(labelText: 'Quantity'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextField(
                            controller: packingController,
                            decoration: InputDecoration(labelText: 'Packing'),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextField(
                            controller: weightController,
                            decoration: InputDecoration(labelText: 'Weight'),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextField(
                            controller: unitPriceController,
                            decoration: InputDecoration(labelText: 'Unit Price'),
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
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
                          title: Text(item.desc),
                          subtitle: Text('Quantity: ${item.quantity}'),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              ButtonWidget(
                text: 'Generate Invoice PDF   ->',
                onClicked: () async {
                  final date = DateTime.now();
                  final dueDate = date.add(Duration(days: 7));

                  final invoice = Invoice(
                    supplier: Supplier(
                      name: 'Sarah Field',
                      address: 'Sarah Street 9, Beijing, China',
                      paymentInfo: 'https://paypal.me/sarahfieldzz',
                    ),
                    customer: Customer(
                      name: 'Apple Inc.',
                      address: 'Apple Street, Cupertino, CA 95014',
                    ),
                    info: InvoiceInfo(
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
