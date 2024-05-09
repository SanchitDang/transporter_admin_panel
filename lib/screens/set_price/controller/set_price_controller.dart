import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/firebase_firestore_service.dart';

class SetPriceController extends GetxController {
  //**IMP** prices>vehicles>auto_rickshaw,bike,car fields should be initialed before **IMP**//

  final FirestoreService _firestoreService = FirestoreService();

  RxDouble autoRickshawPrice = RxDouble(0.0);
  RxDouble bikePrice = RxDouble(0.0);
  RxDouble carPrice = RxDouble(0.0);

  // Method to update prices in Firestore
  Future<void> updatePrices() async {
    try {
      await _firestoreService.setVehiclePrice('auto_rickshaw', autoRickshawPrice.value);
      await _firestoreService.setVehiclePrice('bike', bikePrice.value);
      await _firestoreService.setVehiclePrice('car', carPrice.value);
      update();
      Get.snackbar(
        'Success',
        'Prices updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update prices: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Method to fetch current prices from Firestore
  Future<void> fetchPrices() async {
    try {
      final prices = await _firestoreService.getVehiclePrices();
      autoRickshawPrice.value = prices['auto_rickshaw'] ?? 0.0;
      bikePrice.value = prices['bike'] ?? 0.0;
      carPrice.value = prices['car'] ?? 0.0;
      update();
    } catch (e) {
      print('Error fetching prices: $e');
    }
  }

  // NEW FLOW

  RxString name = RxString("");
  RxDouble price = RxDouble(0.0);
  RxList<dynamic> prices = RxList<dynamic>();

  Future<void> addPriceToFirestore() async {
    try {
      // final CollectionReference _pricesCollection =
      //     FirebaseFirestore.instance.collection('prices');
      //
      // await _pricesCollection.doc('categories').collection('categories').add({
      //   'name': name.value,
      //   'price': price.value,
      // });

      prices.add({'name': name.value, 'price': price.value});
      update();

      Get.snackbar(
        'Success',
        'Prices updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update prices: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<List<Map<String, dynamic>>> getPricesFromFirestore() async {
    final CollectionReference _pricesCollection =
        FirebaseFirestore.instance.collection('prices');

    try {
      QuerySnapshot querySnapshot = await _pricesCollection.get();

      List<Map<String, dynamic>> items = [];
      for (QueryDocumentSnapshot categoryDoc in querySnapshot.docs) {
        QuerySnapshot subCategorySnapshot =
            await categoryDoc.reference.collection('categories').get();
        for (QueryDocumentSnapshot subCategoryDoc in subCategorySnapshot.docs) {
          if (subCategoryDoc.exists) {
            items.add({
              'name': subCategoryDoc['name'],
              'price': subCategoryDoc['price'],
            });
          }
        }
      }
      Get.snackbar(
        'Success',
        'Prices fetched successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      print(items);
      prices.addAll(items);
      return items;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update prices: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    return [];
  }

  void removePrices(){
    prices.value.clear();
  }
}
