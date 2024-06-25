import 'package:admin/screens/trips/trip_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/dart_html_service.dart';
import '../../utils/constants.dart';
import 'details_controller.dart';
import 'goods_details.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(TripDetailsController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new)),
        title:
        Text("Trip Details", style: Theme.of(context).textTheme.headlineMedium),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              // -- IMAGE with ICON
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image(
                            image:
                            NetworkImage(profileController.picUrl.value))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: primaryColor),
                      child: InkWell(
                        onTap: () {
                          final DartHtmlFunctions _dartHtmlFunctions = DartHtmlFunctions();
                          _dartHtmlFunctions.uploadFile(profileController.tripId.value, 'good_picture.jpg', 'image/jpeg,image/png,image/jpg');
                        },
                        child: const Icon(Icons.camera,
                            color: Colors.black, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // -- Form Fields
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      enabled: false,
                      initialValue: profileController.tripId.value,
                      decoration: const InputDecoration(
                          label: Text("Trip Id"),
                          prefixIcon: Icon(Icons.person)),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      enabled: false,
                      initialValue: profileController.tripDate.value,
                      decoration: const InputDecoration(
                          label: Text("Trip Date"), prefixIcon: Icon(Icons.email)),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      enabled: false,
                      initialValue: profileController.source.value,
                      decoration: const InputDecoration(
                          label: Text("Source"),
                          prefixIcon: Icon(Icons.phone)),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      enabled: false,
                      initialValue: profileController.destination.value,
                      decoration: InputDecoration(
                        label: const Text("Destination"),
                        prefixIcon: const Icon(Icons.location_history),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      enabled: false,
                      initialValue: profileController.travellingTime.value,
                      decoration: InputDecoration(
                        label: const Text("Travelling Time"),
                        prefixIcon: const Icon(Icons.location_history),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      enabled: false,
                      initialValue: profileController.tripAmount.value,
                      decoration: InputDecoration(
                        label: const Text("Trip Amount"),
                        prefixIcon: const Icon(Icons.location_history),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final c = Get.put(DetailsController());
                          c.addGoodsFromList(profileController.goodsData.value);
                          Get.to(const GoodsDetailsPage());
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder()),
                        child: const Text("See Products attached with this delivery",
                            style: TextStyle(color: secondaryColor)),
                      ),
                    ),
                    // const SizedBox(height: 20),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
