import 'package:admin/services/firebase_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripDetailsController extends GetxController {
  final RxString picUrl = ''.obs;
  final RxString tripId = ''.obs;
  final RxString tripDate = ''.obs;
  final RxString tripAmount = ''.obs;
  final RxString travellingTime = ''.obs;
  final RxString source = ''.obs;
  final RxString destination = ''.obs;
  final RxList<dynamic> goodsData = RxList<dynamic>();

  void setDataFromTripsData(Map<String, dynamic> userData) {
    picUrl.value = userData['good_picture'] ?? 'https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png';
    tripId.value = userData['trip_id'];
    source.value = userData['source'];
    destination.value = userData['destination'];
    tripDate.value = userData['trip_date'];
    tripAmount.value = userData['trip_amount'].toString();
    travellingTime.value = userData['travelling_time'];
    goodsData.value = userData['goods_info'];
  }

}
