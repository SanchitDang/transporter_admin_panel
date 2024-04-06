
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../controllers/TripDataController.dart';
import '../../../../../utils/constants.dart';
import '../../../../../utils/injection_container.dart' as di;

import '../getx/uber_map_controller.dart';
import '../widgets/map_confirmation_bottomsheet.dart';

class MapWithSourceDestinationField extends StatefulWidget {
  final CameraPosition defaultCameraPosition;
  final CameraPosition newCameraPosition;

  const MapWithSourceDestinationField(
      {required this.newCameraPosition,
      required this.defaultCameraPosition,
      Key? key})
      : super(key: key);

  @override
  _MapWithSourceDestinationFieldState createState() =>
      _MapWithSourceDestinationFieldState();
}

class _MapWithSourceDestinationFieldState
    extends State<MapWithSourceDestinationField> {
  final sourcePlaceController = TextEditingController();
  final destinationController = TextEditingController();

  final UberMapController _uberMapController =
      Get.put(di.sl<UberMapController>());

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    sourcePlaceController.dispose();
    destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Obx(
                    () => Column(
                      children: [
                        Visibility(
                          visible: _uberMapController
                              .isReadyToDisplayAvlDriver.value,
                          child: const SizedBox(
                              height: 250, child: MapConfirmationBottomSheet()),
                        )
                      ],
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: !_uberMapController.isPoliLineDraw.value,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        color: primaryColor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Find a driver to drop the goods to customer',
                                style: TextStyle(fontSize: 18)),
                            ElevatedButton(
                              onPressed: () {
                                final TripDataController tripDataController =
                                    Get.put(TripDataController());

                                _uberMapController.getDirection(
                                    tripDataController.sourcePlaceLat.value,
                                    tripDataController.sourcePlaceLng.value,
                                    tripDataController
                                        .destinationPlaceLat.value,
                                    tripDataController
                                        .destinationPlaceLng.value);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    Size(Get.width * 0.26, Get.height * 0.05),
                              ),
                              child: Text("Find Driver"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _uberMapController.isDriverLoading.value,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Positioned(
                      //bottom: 15,
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(
                        color: Colors.black,
                      ),
                      Text(
                        "Loading Rides....",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
