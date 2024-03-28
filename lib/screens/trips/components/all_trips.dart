import 'package:admin/screens/activity_log/views/activity_log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../services/firebase_firestore_service.dart';
import '../../booking/uber_map_feature/presentation/pages/map_with_source_destination_field.dart';

class AllTrips extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  static const CameraPosition _defaultLocation = CameraPosition(
    target: LatLng(23.030357, 72.517845),
    zoom: 14.4746,
  );

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
                    return DataRow(
                      cells: [
                        DataCell(Text(userData['source'] ?? '')),
                        DataCell(Text(userData['destination'] ?? '')),
                        DataCell(Text(userData['trip_amount'].toString() ?? '')),
                        DataCell(Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => ActivityLog(userData),

                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize:
                                    Size(Get.width * 0.1, Get.height * 0.05),
                              ),
                              child: Text("TRACK"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => MapWithSourceDestinationField(
                                        newCameraPosition: _defaultLocation,
                                        defaultCameraPosition: _defaultLocation),

                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                minimumSize:
                                    Size(Get.width * 0.1, Get.height * 0.05),
                              ),
                              child: Text("Demo Find Driver"),
                            ),
                          ],
                        )),
                      ],
                    );
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
