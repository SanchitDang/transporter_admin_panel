import 'package:flutter/material.dart';
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
                  ],
                  rows: users.map((userData) {
                    return DataRow(
                      cells: [
                        DataCell(Text(userData['source'] ?? '')),
                        DataCell(Text(userData['destination'] ?? '')),
                        DataCell(Text(userData['trip_amount'].toString() ?? '')),
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
