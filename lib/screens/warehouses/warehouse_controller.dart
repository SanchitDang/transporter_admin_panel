import 'package:admin/services/firebase_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarehouseController extends GetxController {
  RxString? selectedState = ''.obs;

  TextEditingController warehouseNameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  void updateSelectedState(String state){
    selectedState?.value = state;
  }

  void createWarehouse(){
    FirestoreService().createWarehouseDocument(selectedState?.value, warehouseNameController.text, double.parse(latitudeController.text), double.parse(longitudeController.text));
  }

}