import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/firebase_firestore_service.dart';
import '../driver_profile_controller.dart';
import '../update_driver.dart';

class AllDrivers extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _firestoreService.getDriversData(),
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
                "All Users",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                width: double.infinity,
                child: DataTable(
                  columnSpacing: 10.0, // Adjust as needed
                  columns: [
                    DataColumn(
                      label: Text("Name"),
                    ),
                    DataColumn(
                      label: Text("City"),
                    ),
                    DataColumn(
                      label: Text("Email"),
                    ),
                    DataColumn(
                      label: Text("Actions"),
                    ),
                  ],
                  rows: users.map((userData) {
                    return DataRow(
                      cells: [
                        DataCell(Text(userData['name'] ?? '')),
                        DataCell(Text(userData['city'] ?? '')),
                        DataCell(Text(userData['email'] ?? '')),
                        DataCell(
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {

                                  DriverProfileController profileController = Get.put(DriverProfileController());
                                  profileController.setDataFromUserData(userData);

                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) =>
                                            UpdateDriverProfileScreen()
                                    ),
                                  );

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  minimumSize: Size(Get.width * 0.1, Get.height * 0.05),
                                ),
                                child: Text("EDIT"),
                              ),
                            ],
                          ),
                        ),
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
