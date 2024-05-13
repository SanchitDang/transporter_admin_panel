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
  final TextEditingController descriptionController = TextEditingController();
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
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      controller: bookingDateController,
                      decoration: InputDecoration(labelText: 'Booking Date'),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextField(
                      controller: bookingBranchController,
                      decoration: InputDecoration(labelText: 'Booking Branch'),
                      keyboardType: TextInputType.datetime,
                    ),
                    TextField(
                      controller: destinationController,
                      decoration: InputDecoration(labelText: 'Destination'),
                    ),
                    TextField(
                      controller: consignorNameController,
                      decoration: InputDecoration(labelText: 'Consignor Name'),
                    ),
                    TextField(
                      controller: consignorGSTController,
                      decoration: InputDecoration(labelText: 'Consignor GST'),
                    ),
                    TextField(
                      controller: consigneeNameController,
                      decoration: InputDecoration(labelText: 'Consignee Name'),
                    ),
                    TextField(
                      controller: consigneeGSTController,
                      decoration: InputDecoration(labelText: 'Consignee GST'),
                    ),
                    TextField(
                      controller: quantityController,
                      decoration: InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: packingController,
                      decoration: InputDecoration(labelText: 'Packing'),
                    ),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      controller: weightController,
                      decoration: InputDecoration(labelText: 'Weight'),
                    ),
                    TextField(
                      controller: unitPriceController,
                      decoration: InputDecoration(labelText: 'Unit Price'),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
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
                          title: Text(item.desc),
                          subtitle: Text('Quantity: ${item.quantity}'),
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
