import 'package:admin/screens/warehouses/add_warehouse.dart';
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
                      // show warehouses, based on filter by states
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
