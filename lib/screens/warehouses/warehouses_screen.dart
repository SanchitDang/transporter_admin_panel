import 'package:admin/screens/warehouses/add_warehouse.dart';
import 'package:admin/screens/warehouses/warehouse_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/responsive.dart';
import '../../utils/constants.dart';
import '../../controllers/MenuAppController.dart';
import '../dashboard/components/header.dart';
import '../main/components/side_menu.dart';

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
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount:
                                      warehouseController.warehouses.length,
                                  itemBuilder: (context, index) {
                                    var warehouse =
                                        warehouseController.warehouses[index];
                                    return ListTile(
                                      onTap: () {
                                        // todo add edit trucks and their quantity
                                      },
                                      title: Text(warehouse['name']),
                                      subtitle: Text(
                                          'Lat: ${warehouse['lat']}, Lng: ${warehouse['lng']}'),
                                    );
                                  },
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
