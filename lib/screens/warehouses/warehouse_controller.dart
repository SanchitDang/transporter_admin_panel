import 'package:admin/services/firebase_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WarehouseController extends GetxController {
  RxString selectedState = ''.obs;

  TextEditingController warehouseNameController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  TextEditingController truckNameController = TextEditingController();
  TextEditingController truckTypeController = TextEditingController();
  TextEditingController truckCapacityController = TextEditingController();

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

  Future<void> addTruckToWarehouse(String warehouseId) async {
    try {
      final truckData = {
        'name': truckNameController.text,
        'type': truckTypeController.text,
        'capacity': int.parse(truckCapacityController.text),
      };

      final warehouseRef = FirebaseFirestore.instance.collection('warehouses').doc('states').collection(selectedState.value).doc(warehouseId);

      // Add the truck data to the 'trucks' collection
      final newTruckDocRef = await warehouseRef.collection('trucks').add(truckData);

      // Update the 'truck_id' field with the ID of the newly created truck document
      await newTruckDocRef.update({
        'truck_id': newTruckDocRef.id,
      });

      Get.snackbar(
        'Success',
        'Truck added to warehouse successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add truck to warehouse: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> editTruck(String warehouseId, String truckId) async {
    try {
      final truckData = {
        'name': truckNameController.text,
        'type': truckTypeController.text,
        'capacity': int.parse(truckCapacityController.text),
      };

      final warehouseRef = FirebaseFirestore.instance.collection('warehouses').doc('states').collection(selectedState.value).doc(warehouseId);

      // Update the truck data in the 'trucks' collection
      await warehouseRef.collection('trucks').doc(truckId).update(truckData);

      Get.snackbar(
        'Success',
        'Truck updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update truck: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  Future<List<DocumentSnapshot>> getTrucksInWarehouse(String warehouseId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('warehouses')
          .doc('states')
          .collection(selectedState.value)
          .doc(warehouseId)
          .collection('trucks')
          .get();

      return querySnapshot.docs;
    } catch (e) {
      // Handle any errors
      print('Error fetching trucks in warehouse: $e');
      return [];
    }
  }

}
