import 'package:cloud_firestore/cloud_firestore.dart';

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
}