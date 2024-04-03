import 'dart:html' as html;

import 'package:admin/services/firebase_firestore_service.dart';
import 'package:get/get.dart';

class DartHtmlFunctions {

  final FirestoreService _firestoreService = FirestoreService();

  void uploadPdfFile(String tripId, String fileName) {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'application/pdf'; // Specify accepted file types
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final files = uploadInput.files;
      if (files != null && files.length == 1) {
        final file = files[0];

        Get.snackbar("INFO", "File uploading started...");

        // Call uploadToFirebase function with obtained PDF file
        _firestoreService.uploadToFirebase(tripId, file, fileName);

        // final reader = html.FileReader();
        // reader.onLoadEnd.listen((event) {
        //   if (reader.result != null) {
        //     final fileContent = reader.result as String;
        //     // Handle the file content here
        //     print('File name: ${file.name}');
        //     print('File size: ${file.size}');
        //     print('File type: ${file.type}');
        //     print('File content: $fileContent');
        //   }
        // });
        //
        // reader.readAsDataUrl(file);
      }
    });
  }

}