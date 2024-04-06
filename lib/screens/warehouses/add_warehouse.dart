import 'package:admin/screens/warehouses/warehouse_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants.dart';



class AddWarehouse extends StatelessWidget {
  const AddWarehouse();

  @override
  Widget build(BuildContext context) {
    WarehouseController warehouseController = Get.put(WarehouseController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Warehouse'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select State:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            DropdownButtonFormField<String>(
              value: warehouseController.selectedState?.value == '' ? null : warehouseController.selectedState?.value,
              hint: Text('Select State'),
              items: indianStates.map((state) {
                return DropdownMenuItem<String>(
                  value: state,
                  child: Text(state),
                );
              }).toList(),
              onChanged: (value) {
                warehouseController.updateSelectedState(value!);
              },
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                hintText: 'Select State',
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Warehouse Name:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: warehouseController.warehouseNameController,
              decoration: InputDecoration(
                hintText: 'Enter warehouse name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Latitude:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: warehouseController.latitudeController,
              decoration: InputDecoration(
                hintText: 'Enter latitude',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Longitude:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: warehouseController.longitudeController,
              decoration: InputDecoration(
                hintText: 'Enter longitude',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30.0),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(Get.width * 0.2, Get.height * 0.05),
                ),
                onPressed: () {
                  if (warehouseController.selectedState?.value != null) {
                        warehouseController.createWarehouse();
                  } else {
                    print('Please select a state.');
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
