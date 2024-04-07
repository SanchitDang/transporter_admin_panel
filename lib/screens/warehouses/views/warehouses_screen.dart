import 'package:admin/screens/warehouses/views/add_warehouse.dart';
import 'package:admin/screens/warehouses/views/trucks_screen.dart';
import 'package:admin/screens/warehouses/controller/warehouse_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/responsive.dart';
import '../../../utils/constants.dart';
import '../../../controllers/MenuAppController.dart';
import '../../dashboard/components/header.dart';
import '../../main/components/side_menu.dart';

class WarehousesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MenuAppController menuAppController = Get.find<MenuAppController>();
    final WarehouseController warehouseController =
        Get.put(WarehouseController());

    return Scaffold(
      key: menuAppController.scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SafeArea(
                child: SingleChildScrollView(
                  primary: false,
                  padding: EdgeInsets.all(defaultPadding),
                  child: Column(
                    children: [
                      Header(),
                      SizedBox(height: defaultPadding),
                      Align(
                        alignment: Alignment.topRight,
                        child: ElevatedButton(
                          onPressed: () => Get.to(AddWarehouse()),
                          style: ElevatedButton.styleFrom(
                            minimumSize:
                                Size(Get.width * 0.1, Get.height * 0.05),
                          ),
                          child: Text("Add Warehouse"),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Select State:',
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Obx(() => DropdownButtonFormField<String>(
                            value: warehouseController.selectedState.value == ''
                                ? null
                                : warehouseController.selectedState.value,
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
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              hintText: 'Select State',
                            ),
                          )),
                      Obx(() => FutureBuilder(
                            future: warehouseController.getWarehouseData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else {
                                // Display warehouse data
                                    var warehouse =
                                        warehouseController.warehouses;
                                    return SizedBox(
                                      width: double.infinity,
                                      child: DataTable(
                                        columnSpacing: 10.0, // Adjust as needed
                                        columns: [
                                          DataColumn(
                                            label: Text("Name"),
                                          ),
                                          DataColumn(
                                            label: Text("Latitude"),
                                          ),
                                          DataColumn(
                                            label: Text("Longitude"),
                                          ),
                                          DataColumn(
                                            label: Text("Actions"),
                                          ),
                                        ],
                                        rows: warehouse.map((warehouseData) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(
                                                  warehouseData['name'] ?? '')),
                                              DataCell(Text(
                                                  warehouseData['lat'].toString() )),
                                              DataCell(Text(
                                                  warehouseData['lng'].toString() )),
                                              DataCell(
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          PageRouteBuilder(
                                                            pageBuilder: (context, animation, secondaryAnimation) =>
                                                                AllTrucksScreen(warehouseData['warehouse_id']),
                                                          ),
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        minimumSize: Size(
                                                            Get.width * 0.1,
                                                            Get.height * 0.05),
                                                      ),
                                                      child:
                                                          Text("EDIT TRUCKS"),
                                                    ),
                                                    SizedBox(width:20),
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Text(
                                                                  "Add Truck"),
                                                              content: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Text(
                                                                      "You can add a truck to this warehouse from here."),
                                                                  SizedBox(
                                                                      height:
                                                                          20),
                                                                  TextField(
                                                                    controller:
                                                                        warehouseController
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
                                                                        warehouseController
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
                                                                        warehouseController
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
                                                                    // Call the function to add a truck to the warehouse
                                                                    warehouseController
                                                                        .addTruckToWarehouse(
                                                                            warehouseData['warehouse_id']);

                                                                    Navigator.pop(
                                                                        context); // Close the dialog
                                                                  },
                                                                  child: Text(
                                                                      "Add Trucks"),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Colors.green,
                                                        minimumSize: Size(
                                                            Get.width * 0.1,
                                                            Get.height * 0.05),
                                                      ),
                                                      child: Text("ADD TRUCK"),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    );

                              }
                            },
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
