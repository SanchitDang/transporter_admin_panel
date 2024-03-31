import 'package:admin/screens/invoice/invoice_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'booking/uber_map_feature/presentation/pages/map_with_source_destination_field.dart';

class DeBugScreen extends StatefulWidget {
  const DeBugScreen();

  @override
  State<DeBugScreen> createState() => _DeBugScreenState();
}

class _DeBugScreenState extends State<DeBugScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Text('D E B U G   S C R E E N',
                    style: TextStyle(fontSize: 18))),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {
                const CameraPosition _defaultLocation = CameraPosition(
                  target: LatLng(23.030357, 72.517845),
                  zoom: 14.4746,
                );
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        MapWithSourceDestinationField(
                            newCameraPosition: _defaultLocation,
                            defaultCameraPosition: _defaultLocation),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(Get.width * 0.26, Get.height * 0.05),
              ),
              child: Text("Find Driver"),
            ),
            SizedBox(height: 10,),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        InvoicePage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(Get.width * 0.26, Get.height * 0.05),
              ),
              child: Text("Invoice Page"),
            ),
          ],
        ),
      ),
    );
  }
}
