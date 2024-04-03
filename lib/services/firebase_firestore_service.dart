import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';

class FirestoreService {

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
      Get.snackbar("Error!", "Failed to upload file: $e");
      throw Exception("Failed to upload image to Firebase: $e");
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

}