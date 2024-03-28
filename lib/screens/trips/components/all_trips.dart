import 'package:admin/controllers/TripDataController.dart';
import 'package:admin/screens/activity_log/views/activity_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/firebase_firestore_service.dart';

class AllTrips extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firestoreService.getTripsData(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loading indicator while fetching data
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No data available');
        } else {
          List<Map<String, dynamic>> users = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Deliveries",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: 10.0, // Adjust as needed
                  columns: [
                    DataColumn(
                      label: Text("Source"),
                    ),
                    DataColumn(
                      label: Text("Destination"),
                    ),
                    DataColumn(
                      label: Text("Trip Amount"),
                    ),
                    DataColumn(
                      label: Text("Actions"),
                    ),
                  ],
                  rows: users.map((userData) {
                    if (userData != null && !userData['is_from_admin']) {
                      return DataRow(
                        cells: [
                          DataCell(Text(userData['source'] ?? '')),
                          DataCell(Text(userData['destination'] ?? '')),
                          DataCell(Text(userData['trip_amount'].toString() ?? '')),
                          DataCell(
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    final TripDataController tripDataController =
                                    Get.put(TripDataController());

                                    // Assuming userData['source_location'] and userData['destination_location'] are GeoPoint objects
                                    GeoPoint? sourceLocation = userData['source_location'];
                                    GeoPoint? destinationLocation =
                                    userData['destination_location'];

                                    if (sourceLocation != null && destinationLocation != null) {
                                      // Extract latitude and longitude from source location
                                      double sourceLat = sourceLocation.latitude;
                                      double sourceLng = sourceLocation.longitude;

                                      // Extract latitude and longitude from destination location
                                      double destinationLat = destinationLocation.latitude;
                                      double destinationLng = destinationLocation.longitude;

                                      // Update TripDataController with extracted values
                                      tripDataController.updateSourcePlace(
                                          userData['source'], sourceLat, sourceLng);
                                      tripDataController.updateDestinationPlace(
                                          userData['destination'], destinationLat, destinationLng);

                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, secondaryAnimation) =>
                                              ActivityLog(userData),
                                        ),
                                      );
                                    } else {
                                      // Handle null GeoPoint objects
                                      // Display an error message or handle it as per your requirement
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    minimumSize: Size(Get.width * 0.1, Get.height * 0.05),
                                  ),
                                  child: Text("TRACK"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Return an empty DataRow if userData is null or not from admin
                      return DataRow(
                        cells: [
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text('')), // Add an empty DataCell for the "Actions" column
                        ],
                      );
                    }
                  }).toList(),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
