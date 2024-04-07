import 'package:admin/screens/warehouses/controller/warehouse_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllTrucksScreen extends StatelessWidget {
  final WarehouseController _warehouseController = Get.find<WarehouseController>();

  AllTrucksScreen(this.warehouseId);

  String warehouseId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Trucks'),
      ),
      body: FutureBuilder(
        future: _warehouseController.getTrucksInWarehouse(warehouseId), // Pass the warehouseId here
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Show a loading indicator while fetching data
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No trucks available'),
            );
          } else {
            List<DocumentSnapshot> trucks = snapshot.data!;
            return ListView.builder(
              itemCount: trucks.length,
              itemBuilder: (context, index) {
                var truckData = trucks[index].data() as Map<String, dynamic>;
                return ListTile(
                  title: Text(truckData['name'] ?? ''),
                  subtitle: Text('Type: ${truckData['type']}, Capacity: ${truckData['capacity']}', style: TextStyle(color: Colors.grey),),
                  onTap: () {

                    _warehouseController
                        .truckNameController.text = truckData['name'];
                    _warehouseController
                        .truckTypeController.text = truckData['type'];
                    _warehouseController
                        .truckCapacityController.text = truckData['capacity'].toString();

                    showDialog(
                      context: context,
                      builder: (BuildContext
                      context) {
                        return AlertDialog(
                          title: Text(
                              "Edit"),
                          content: Column(
                            mainAxisSize:
                            MainAxisSize
                                .min,
                            children: [
                              Text(
                                  "You can edit this truck from here."),
                              SizedBox(
                                  height:
                                  20),
                              TextField(
                                controller:
                                _warehouseController
                                    .truckNameController,
                                decoration: InputDecoration(
                                    labelText:
                                    'Truck Name'),
                              ),
                              SizedBox(
                                  height:
                                  10),
                              TextField(
                                controller:
                                _warehouseController
                                    .truckTypeController,
                                decoration: InputDecoration(
                                    labelText:
                                    'Truck Type'),
                              ),
                              SizedBox(
                                  height:
                                  10),
                              TextField(
                                controller:
                                _warehouseController
                                    .truckCapacityController,
                                decoration: InputDecoration(
                                    labelText:
                                    'Truck Capacity'),
                                keyboardType:
                                TextInputType
                                    .number,
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed:
                                  () {
                                Navigator.pop(
                                    context);
                              },
                              child: Text(
                                  "Cancel"),
                            ),
                            SizedBox(width: 14,),
                            TextButton(
                              onPressed:
                                () {
                                  _warehouseController.editTruck(warehouseId, truckData['truck_id']);
                                  Navigator.pop(
                                      context); // Close the dialog
                                  Navigator.pop(
                                      context); // go to all truck page
                              },
                              child: Text(
                                  "Edit Truck"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
