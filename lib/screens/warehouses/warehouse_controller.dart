import 'package:admin/services/firebase_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarehouseController extends GetxController {
  RxString selectedState = ''.obs;

  TextEditingController warehouseNameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  RxList<dynamic> warehouses = [].obs;

  void updateSelectedState(String state) {
    selectedState.value = state;
  }

  void createWarehouse() {
    FirestoreService().createWarehouseDocument(
        selectedState.value,
        warehouseNameController.text,
        double.parse(latitudeController.text),
        double.parse(longitudeController.text));
  }

  Future<void> getWarehouseData() async {
    try {
      List<DocumentSnapshot> data = await FirestoreService().getWarehouseData(selectedState.value);
      warehouses.value = data;
    } catch (e) {
      print('Error fetching warehouse data: $e');
    }
  }

}
