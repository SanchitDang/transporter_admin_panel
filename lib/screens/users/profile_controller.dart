import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RxString profileUrl = ''.obs;
  final RxString riderId = ''.obs;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final RxBool obscurePassword = true.obs;

  @override
  void onClose() {
    // Dispose the TextEditingController when the controller is closed to prevent memory leaks
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    cityController.dispose();
    super.onClose();
  }

  // Method to update profile data
  void updateProfileData({
    required String name,
    required String email,
    required String mobile,
    required String city,
  }) {
    nameController.text = name;
    emailController.text = email;
    mobileController.text = mobile;
    cityController.text = city;
  }

  // Method to toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Method to handle profile update submission
  void submitProfileUpdate() {
    // Add logic here to handle profile update submission
  }

  // Method to delete the profile
  void deleteProfile() {
    // Add logic here to delete the profile
  }

  // Method to set data from userData to respective TextEditingController
  void setDataFromUserData(Map<String, dynamic> userData) {
    profileUrl.value = userData['profile_img'] ?? 'https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png';
    riderId.value = userData['rider_id'];
    nameController.text = userData['name'] ?? '';
    emailController.text = userData['email'] ?? '';
    mobileController.text = userData['mobile'] ?? '';
    cityController.text = userData['city'] ?? '';
  }

}
