import 'package:admin/screens/activity_log/views/activity_log.dart';
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
