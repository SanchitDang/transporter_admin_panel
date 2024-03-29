import 'package:get/get.dart';

class TripDataController extends GetxController {
  // Observable variables for source and destination place names and coordinates
  RxString tripId = 'xxx'.obs;
  RxString sourcePlaceName = 'Nawada'.obs;
  RxString destinationPlaceName = 'Subhash Nagar'.obs;
  RxDouble sourcePlaceLat = 28.6230738.obs;
  RxDouble sourcePlaceLng = 77.1207739.obs;
  RxDouble destinationPlaceLat = 28.638643799999997.obs;
  RxDouble destinationPlaceLng = 77.07206.obs;

  // Method to update current tripId
  void updateTripId(String id){
    tripId.value = id;
  }

  // Method to update source place data
  void updateSourcePlace(String name, double lat, double lng) {
    sourcePlaceName.value = name;
    sourcePlaceLat.value = lat;
    sourcePlaceLng.value = lng;
  }

  // Method to update destination place data
  void updateDestinationPlace(String name, double lat, double lng) {
    destinationPlaceName.value = name;
    destinationPlaceLat.value = lat;
    destinationPlaceLng.value = lng;
  }
}
