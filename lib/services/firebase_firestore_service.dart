import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirestoreService {

  void updateUserProfile(String riderId, name, email, mobile, city) async {
    final CollectionReference _ridersCollection =
    FirebaseFirestore.instance.collection('riders');

    try {
      // Get the current user's ID
      String userId = riderId;

      // Update the user's profile data in Firestore
      await _ridersCollection.doc(userId).update({
        'name': name,
        'email': email,
        'mobile': mobile,
        'city': city,
      });

      // Display a success message
      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle errors
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void updateDriverProfile(String riderId, name, email, mobile, city) async {
    final CollectionReference _ridersCollection =
    FirebaseFirestore.instance.collection('drivers');

    try {
      // Get the current user's ID
      String userId = riderId;

      // Update the user's profile data in Firestore
      await _ridersCollection.doc(userId).update({
        'name': name,
        'email': email,
        'mobile': mobile,
        'city': city,
      });

      // Display a success message
      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle errors
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  Future<List<Map<String, dynamic>>> getUsersData() async {
    final CollectionReference _usersCollection =
    FirebaseFirestore.instance.collection('riders');

    QuerySnapshot usersSnapshot = await _usersCollection.get();
    List<Map<String, dynamic>> userList = [];
    usersSnapshot.docs.forEach((userDoc) {
      userList.add(userDoc.data() as Map<String, dynamic>);
    });
    return userList;
  }

  Future<List<Map<String, dynamic>>> getDriversData() async {
    final CollectionReference _usersCollection =
    FirebaseFirestore.instance.collection('drivers');

    QuerySnapshot usersSnapshot = await _usersCollection.get();
    List<Map<String, dynamic>> userList = [];
    usersSnapshot.docs.forEach((userDoc) {
      userList.add(userDoc.data() as Map<String, dynamic>);
    });
    return userList;
  }

  Future<List<Map<String, dynamic>>> getTripsData() async {
    final CollectionReference tripsCollection =
    FirebaseFirestore.instance.collection('trips');

    QuerySnapshot tripsSnapshot = await tripsCollection.get();
    List<Map<String, dynamic>> tripList = [];
    tripsSnapshot.docs.forEach((tripDoc) {
      tripList.add(tripDoc.data() as Map<String, dynamic>);
    });
    return tripList;
  }

  Future<void> changeDeliveryStatus(String documentId, String fieldName, bool status) async {
    final CollectionReference _tripsCollection =
    FirebaseFirestore.instance.collection('trips');
    try {
      await _tripsCollection.doc(documentId).update({
        fieldName: status,
      });
    } catch (e) {
      throw Exception("Failed to update delivery status: $e");
    }
  }

  // for uploading from web
  Future<void> uploadToFirebase(String tripId, html.File myFile, String myFileName) async {
    final CollectionReference _tripsCollection =  FirebaseFirestore.instance.collection('trips');

    try {
      // Convert html.File to Blob
      final blob = html.Blob([myFile.slice()], myFile.type);

      // Upload file to Firebase Storage
      final firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('trips')
          .child(tripId)
          .child(myFileName); // with file extension

      // Upload Blob instead of File
      await storageRef.putBlob(blob);

      // Get download URL
      final myFileUrl = await storageRef.getDownloadURL();

      // Update Firestore with file URL
      await _tripsCollection.doc(tripId).update({
        myFileName.split(".")[0] : myFileUrl,
      });

      Get.snackbar("Great!", "File uploaded...");

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to upload file: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw Exception("Failed to upload file to Firebase: $e");
    }
  }

  // for other mobile devices
  // Future<void> uploadToFirebase(String tripId, File myFile, String myFileName) async {
  //   final CollectionReference _tripsCollection =  FirebaseFirestore.instance.collection('trips');
  //
  //   try {
  //     // Upload image to Firebase Storage
  //     final firebase_storage.Reference storageRef = firebase_storage.FirebaseStorage.instance
  //         .ref()
  //         .child('trips')
  //         .child(tripId)
  //         .child(myFileName); // with file extension
  //
  //     await storageRef.putFile(myFile);
  //
  //     // Get download URL
  //     final myFileUrl = await storageRef.getDownloadURL();
  //
  //     // Update Firestore with image URL
  //     await _tripsCollection.doc(tripId).update({
  //       myFileName.split(".")[0] : myFileUrl,
  //     });
  //   } catch (e) {
  //     throw Exception("Failed to upload image to Firebase: $e");
  //   }
  // }

  // Function to create a new warehouse document
  Future<void> createWarehouseDocument(String state, String name, double lat, double lng) async {
    try {
      // Reference to the warehouses collection
      final warehousesRef = FirebaseFirestore.instance.collection('warehouses').doc('states').collection(state);

      // Create a new document with an auto-generated ID
      final warehouseDocRef = await warehousesRef.add({
        'name': name,
        'lat': lat,
        'lng': lng,
        'warehouse_id': '', // Will be updated with the ID of the newly created document
      });

      // Update the warehouse_id field with the ID of the newly created document
      await warehouseDocRef.update({
        'warehouse_id': warehouseDocRef.id,
      });
      Get.snackbar(
        'Success',
        'Warehouse document created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create warehouse: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<List<DocumentSnapshot>> getWarehouseData(String stateName) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('warehouses')
            .doc('states')
            .collection(stateName)
            .get();
        return querySnapshot.docs;
      } catch (e) {
        // Handle any errors
        print('Error fetching warehouse data: $e');
        return [];
      }
  }


  Future<void> setVehiclePrice(String vehicleType, double price) async {
    final CollectionReference _pricesCollection = FirebaseFirestore.instance.collection('prices');
    try {
      await _pricesCollection.doc('vehicles').update({
        vehicleType: price,
      });
      print('Price for $vehicleType updated successfully!');
    } catch (e) {
      print('Failed to update price for $vehicleType: $e');
    }
  }

  Future<Map<String, double>> getVehiclePrices() async {
    final CollectionReference _pricesCollection = FirebaseFirestore.instance.collection('prices');
    try {
      final DocumentSnapshot doc =
      await _pricesCollection.doc('vehicles').get();
      return Map<String, double>.from(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching vehicle prices: $e');
      return {};
    }
  }

}