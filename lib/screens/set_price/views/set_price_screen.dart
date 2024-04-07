import 'package:admin/screens/set_price/controller/set_price_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/MenuAppController.dart';
import '../../../utils/constants.dart';
import '../../../utils/responsive.dart';
import '../../dashboard/components/header.dart';
import '../../main/components/side_menu.dart';

class SetPrice extends StatelessWidget {
  final SetPriceController _setPriceController = Get.put(SetPriceController());

  @override
  Widget build(BuildContext context) {
    final MenuAppController menuAppController = Get.find<MenuAppController>();

    return Scaffold(
      key: menuAppController.scaffoldKey,
      drawer: SideMenu(),
      body: Row(
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
                    FutureBuilder(
                      future: _setPriceController.fetchPrices(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildPriceField('Rickshaw Price', _setPriceController.bikePrice),
                              buildPriceField('Auto Price', _setPriceController.autoRickshawPrice),
                              buildPriceField('Mini Truck Price', _setPriceController.carPrice),
                              SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: _setPriceController.updatePrices,
                                child: Text('Set Prices'),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPriceField(String label, RxDouble price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter price',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => price.value = double.tryParse(value) ?? 0.0,
          initialValue: price.value.toString(),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
