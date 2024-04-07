import 'package:admin/services/dart_html_service.dart';
import 'package:admin/services/firebase_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../booking/uber_map_feature/presentation/pages/map_with_source_destination_field.dart';
import '../controller/activity_log_controller.dart';

class ActivityLog extends StatefulWidget {
  ActivityLog(this.data);

  Map<String, dynamic> data;

  @override
  State<ActivityLog> createState() => _ActivityLogState();
}

class _ActivityLogState extends State<ActivityLog> {
  Widget stepBuilder(context, details) {
    ActivityLogController controller = Get.find();

    return widget.data['delivered'] ? Container() :
    Row(
      children: [
        ElevatedButton(
          onPressed: () {
            // show confirmation dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirmation"),
                  content: Text("Are you sure?\nThis cannot be undone."),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {

                        // if we're in warehouse destination ie want to find driver for delivery
                        if(controller.currentStep.value == 5){
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
                          // for this condition changeDeliveryStatus function will run once trip is accepted by driver

                        }else {
                          FirestoreService().changeDeliveryStatus(widget.data['trip_id'], controller.getSelectedFieldName(), true);
                          Navigator.of(context).pop(true);
                        }
                        widget.data[controller.getSelectedFieldName()] = true;
                        controller.continueStep();
                        details.onStepContinue;
                        setState(() {});


                      },
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );

          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(Get.width * 0.26, Get.height * 0.05),
          ),
          child: Text(controller.currentStep.value == 5 ? "Find Driver" : "Mark Completed"),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            // details.onStepCancel;

            final DartHtmlFunctions _dartHtmlFunctions = DartHtmlFunctions();
            _dartHtmlFunctions.uploadFile(widget.data['trip_id'], controller.getSelectedFieldName()+'_receipt.pdf','application/pdf');

          },
          style: ElevatedButton.styleFrom(
            minimumSize: Size(Get.width * 0.3, Get.height * 0.05),
          ),
          child: Text("Upload Receipt"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final ActivityLogController activityLogController =
        Get.put(ActivityLogController());

    if(widget.data['is_payment_done'] && !widget.data['sending_warehouse_source']) {
      print("in 1");
      activityLogController.currentStep = 1.obs;
      //change status sending_warehouse_source to true
      activityLogController.changeSelectedFieldName('sending_warehouse_source');
    } else if(widget.data['sending_warehouse_source'] && !widget.data['reached_warehouse_source']) {
      print("in 2");
      activityLogController.currentStep = 2.obs;
      //change status reached_warehouse_source to true
      activityLogController.changeSelectedFieldName('reached_warehouse_source');
    } else if(widget.data['reached_warehouse_source'] && !widget.data['sending_warehouse_destination']) {
      print("in 3");
      activityLogController.currentStep = 3.obs;
      //change status sending_warehouse_destination to true
      activityLogController.changeSelectedFieldName('sending_warehouse_destination');
    }  else if(widget.data['sending_warehouse_destination'] && !widget.data['reached_warehouse_destination']) {
      print("in 4");
      activityLogController.currentStep = 4.obs;
      //change status reached_warehouse_destination to true
      activityLogController.changeSelectedFieldName('reached_warehouse_destination');
    } else if(widget.data['reached_warehouse_destination'] && !widget.data['out_for_delivery']) {
      print("in 5");
      activityLogController.currentStep = 5.obs;
      //change status out_for_delivery to true
      // !! here find and assign a driver !!
      activityLogController.changeSelectedFieldName('out_for_delivery');
    } else if(widget.data['out_for_delivery'] && !widget.data['delivered']) {
      print("in 6");
      activityLogController.currentStep = 6.obs;
      //change status delivered to true
      activityLogController.changeSelectedFieldName('delivered');
    } else if(widget.data['delivered']) {
      // do nothing
      activityLogController.currentStep = 6.obs;
    }

    return Scaffold(
      body: Center(
          child: Obx(
        () => Theme(
          data: ThemeData(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  onSurface: Colors.black,
                ),
          ),
          child: Stepper(
            elevation: 1,
            controlsBuilder: stepBuilder,
            currentStep: activityLogController.currentStep.value,
            onStepContinue: activityLogController.continueStep,
            onStepCancel: activityLogController.cancelStep,
            steps: [
              Step(
                title: Text('Picked from User', style: TextStyle(fontSize: 18)),
                content: const Text(''),
                isActive: widget.data['is_payment_done'] && !widget.data['sending_warehouse_source'],
                subtitle: const Text("2 Days ago"),
              ),
              Step(
                title: Text('Sending to Warehouse Source', style: TextStyle(fontSize: 18)),
                content: const Text(''),
                isActive: widget.data['sending_warehouse_source'] && !widget.data['reached_warehouse_source'],
                subtitle: const Text("2 Days ago"),
              ),
              Step(
                title: Text('Reached Warehouse Source', style: TextStyle(fontSize: 18)),
                content: const Text(''),
                isActive: widget.data['reached_warehouse_source'] && !widget.data['sending_warehouse_destination'],
                subtitle: const Text("2 Days ago"),
              ),
              Step(
                title: Text('Sending to Warehouse Destination', style: TextStyle(fontSize: 18)),
                content: const Text(''),
                isActive: widget.data['sending_warehouse_destination'] && !widget.data['reached_warehouse_destination'],
                subtitle: const Text("2 Days ago"),
              ),
              Step(
                title: Text('Reached Warehouse Destination', style: TextStyle(fontSize: 18)),
                content: const Text(''),
                isActive: widget.data['reached_warehouse_destination'] && !widget.data['out_for_delivery'],
                subtitle: const Text("2 Days ago"),
              ),
              Step(
                title: Text('Find Driver & Set Out for Delivery', style: TextStyle(fontSize: 18)),
                content: const Text(''),
                isActive: widget.data['out_for_delivery'] && !widget.data['delivered'],
                subtitle: const Text("2 Days ago"),
              ),
              Step(
                title: Text('Delivered', style: TextStyle(fontSize: 18)),
                content: const Text(''),
                isActive: widget.data['delivered'],
                subtitle: const Text("2 Days ago"),
              ),
            ],
          ),
        ),
      )),
    );
  }

  AlertDialog buildConfirmAlertDialog(BuildContext context){
    return AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are you sure?\nThis cannot be undone."),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text("OK"),
        ),
      ],
    );
  }

}
