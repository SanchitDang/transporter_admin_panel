import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  Future<List<Map<String, dynamic>>> getUsersData() async {
    final CollectionReference _usersCollection =
    FirebaseFirestore.instance.collection('riders');

    QuerySnapshot usersSnapshot = await _usersCollection.get();
    List<Map<String, dynamic>> userList = [];
    usersSnapshot.docs.forEach((userDoc) {
      userList.add({
        'name': userDoc['name'],
        'city': userDoc['city'],
        'email': userDoc['email'],
      });
    });
    return userList;
  }

  Future<List<Map<String, dynamic>>> getDriversData() async {
    final CollectionReference _usersCollection =
    FirebaseFirestore.instance.collection('drivers');

    QuerySnapshot usersSnapshot = await _usersCollection.get();
    List<Map<String, dynamic>> userList = [];
    usersSnapshot.docs.forEach((userDoc) {
      userList.add({
        'name': userDoc['name'],
        'city': userDoc['city'],
        'email': userDoc['email'],
      });
    });
    return userList;
  }

  Future<List<Map<String, dynamic>>> getTripsData() async {
    final CollectionReference _usersCollection =
    FirebaseFirestore.instance.collection('trips');

    QuerySnapshot usersSnapshot = await _usersCollection.get();
    List<Map<String, dynamic>> userList = [];
    usersSnapshot.docs.forEach((userDoc) {
      userList.add({
        'destination': userDoc['destination'],
        'source': userDoc['source'],
        'trip_amount': userDoc['trip_amount'],
      });
    });
    return userList;
  }

}