import 'dart:async';
import 'dart:ui' as ui;

import 'package:admin/screens/trips/trips_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../../controllers/TripDataController.dart';
import '../../../../../services/firebase_firestore_service.dart';
import '../../data/models/generate_trip_model.dart';
import '../../domain/entities/uber_map_direction_entity.dart';
import '../../domain/entities/uber_map_get_drivers_entity.dart';
import '../../domain/entities/uber_map_prediction_entity.dart';
import '../../domain/use_cases/cancel_trip_usecase.dart';
import '../../domain/use_cases/generate_trip_usecase.dart';
import '../../domain/use_cases/get_rental_charges_usecase.dart';
import '../../domain/use_cases/uber_map_direction_usecase.dart';
import '../../domain/use_cases/uber_map_get_drivers_usecase.dart';
import '../../domain/use_cases/uber_map_prediction_usecase.dart';
import '../../domain/use_cases/vehicle_details_usecase.dart';

class UberMapController extends GetxController {
  final UberMapPredictionUsecase uberMapPredictionUsecase;
  final UberMapDirectionUsecase uberMapDirectionUsecase;
  final UberMapGetDriversUsecase uberMapGetDriversUsecase;
  final UberMapGetRentalChargesUseCase uberMapGetRentalChargesUseCase;
  final UberMapGenerateTripUseCase uberMapGenerateTripUseCase;
  final UberMapGetVehicleDetailsUseCase uberMapGetVehicleDetailsUseCase;
  final UberCancelTripUseCase uberCancelTripUseCase;

  //todo rider id for admin
  var uberAuthGetUserUidUseCase = "R98PG2sseqUjbm8knJiGmwEPKUh1";

  var uberMapPredictionData = <UberMapPredictionEntity>[].obs;

  var uberMapDirectionData = <UberMapDirectionEntity>[].obs;
  var sourcePlaceName = "".obs;
  var destinationPlaceName = "".obs;
  var predictionListType = "source".obs;

  RxDouble sourceLatitude = 0.0.obs;
  RxDouble sourceLongitude = 0.0.obs;

  RxDouble destinationLatitude = 0.0.obs;
  RxDouble destinationLongitude = 0.0.obs;
  var availableDriversList = <UberDriverEntity>[].obs;

  // polyline
  var polylineCoordinates = <LatLng>[].obs;
  var polylineCoordinatesforacptDriver = <LatLng>[].obs;
  PolylinePoints polylinePoints = PolylinePoints();

  //markers
  // var markers = <String, Marker>{}.obs;
  var markers = <Marker>[].obs;

  var isPoliLineDraw = false.obs;
  var isReadyToDisplayAvlDriver = false.obs;

  var carRent = 0.obs;
  var bikeRent = 0.obs;
  var autoRent = 0.obs;
  var isDriverLoading = false.obs;
  var findDriverLoading = false.obs;
  var prevTripId = "xyz".obs;

  var reqAccepted = false.obs;

  var req_accepted_driver_and_vehicle_data = <String, String>{};

  final Completer<GoogleMapController> controller = Completer();
  late StreamSubscription subscription;

  UberMapController(
      {required this.uberMapPredictionUsecase,
      required this.uberMapDirectionUsecase,
      required this.uberMapGetDriversUsecase,
      required this.uberMapGetRentalChargesUseCase,
      required this.uberMapGenerateTripUseCase,
      required this.uberMapGetVehicleDetailsUseCase,
      required this.uberCancelTripUseCase,
      });

  getPredictions(String placeName, String predictiontype) async {
    uberMapPredictionData.clear();
    predictionListType.value = predictiontype;
    if (placeName != sourcePlaceName.value ||
        placeName != destinationPlaceName.value) {
      final predictionData = await uberMapPredictionUsecase.call(placeName);
      uberMapPredictionData.value = predictionData;
    }
  }

  setPlaceAndGetLocationDeatailsAndDirection(
      {required String sourcePlace, required String destinationPlace}) async {
    uberMapPredictionData.clear(); // clear list of suggestions
    if (sourcePlace == "") {
      availableDriversList.clear();
      destinationPlaceName.value = destinationPlace;
      List<Location> destinationLocations =
          await locationFromAddress(destinationPlace); //get destination latlng
      destinationLatitude.value = destinationLocations[0].latitude;
      destinationLongitude.value = destinationLocations[0].longitude;
      addMarkers(
          destinationLocations[0].latitude,
          destinationLocations[0].longitude,
          "destination_marker",
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          "default",
          "Destination Location");
      animateCamera(
          destinationLocations[0].latitude, destinationLocations[0].longitude);
    } else {
      availableDriversList.clear();
      sourcePlaceName.value = sourcePlace;
      List<Location> sourceLocations =
          await locationFromAddress(sourcePlace); //get source latlng
      sourceLatitude.value = sourceLocations[0].latitude;
      sourceLongitude.value = sourceLocations[0].longitude;
      addMarkers(
          sourceLocations[0].latitude,
          sourceLocations[0].longitude,
          "source_marker",
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          "default",
          "Source Location");
      animateCamera(sourceLocations[0].latitude, sourceLocations[0].longitude);
    } // set place in textfield
    if (sourcePlaceName.value.isNotEmpty &&
        destinationPlaceName.value.isNotEmpty) {
      if (sourcePlaceName.value != destinationPlaceName.value) {
        // getDirection();
      } //get direction data
      else {
        Get.snackbar("error", "both location can't be same!");
      }
    }
  }

  Future<void> getDirection(double sourceLat, double sourceLng,
      double destinationLat, double destinationLng) async {

    availableDriversList.clear();
    final directionData = await uberMapDirectionUsecase.call(
        sourceLat, sourceLng, destinationLat, destinationLng);
    uberMapDirectionData.value = directionData;

    // get drivers
    isDriverLoading.value = true;
    Stream<List<UberDriverEntity>> availableDriversData =
    uberMapGetDriversUsecase.call();
    availableDriversList.clear();
    subscription = availableDriversData.listen((driverData) {
      availableDriversList.clear();
      if (markers.length > 2) {
        markers.removeRange(2, markers.length - 1);
      }
      for (int i = 0; i < driverData.length; i++) {

        if (Geolocator.distanceBetween(
            sourceLat,
            sourceLng,
            driverData[i].currentLocation!.latitude,
            driverData[i].currentLocation!.longitude) <
            5000) {
          availableDriversList.add(driverData[i]);
          addMarkers(
              driverData[i].currentLocation!.latitude,
              driverData[i].currentLocation!.longitude,
              i.toString(),
              driverData[i].vehicle!.path.split('/').first == "cars"
                  ? 'assets/car.png'
                  : driverData[i].vehicle!.path.split('/').first == "bikes"
                  ? 'assets/bike.png'
                  : 'assets/auto.png',
              "img",
              "Driver Location");
        }
      }
      isDriverLoading.value = false;
      if (availableDriversList.isNotEmpty) {
        getRentalCharges();
        isPoliLineDraw.value = true;
      } else {
        isPoliLineDraw.value = false;
        print(" Sorry ! No Rides available");
        Get.snackbar(
          "Sorry !",
          "No Rides available",
          snackPosition: SnackPosition.BOTTOM,
        );
        isReadyToDisplayAvlDriver.value = false;
      }
    });
    animateCameraPolyline();
    getPolyLine();
  }

  getPolyLine() async {
    List<PointLatLng> result = polylinePoints
        .decodePolyline(uberMapDirectionData[0].enCodedPoints.toString());
    polylineCoordinates.clear();
    result.forEach((PointLatLng point) {
      polylineCoordinates.value.add(LatLng(point.latitude, point.longitude));
    });
    isPoliLineDraw.value = true;
  }

  addMarkers(double latitude, double longitude, String markerId, icon,
      String type, String infoWindow) async {
    Marker marker = Marker(
        icon: type == "img"
            ? BitmapDescriptor.fromBytes(await getBytesFromAsset(icon, 85))
            : icon,
        markerId: MarkerId(markerId),
        infoWindow: InfoWindow(title: infoWindow),
        position: LatLng(latitude, longitude));
    //markers[markerId] = marker;
    markers.add(marker);
  }

  getRentalCharges() async {
    final rentCharge = await uberMapGetRentalChargesUseCase
        .call(uberMapDirectionData[0].distanceValue! / 1000.toDouble());
    carRent.value = rentCharge.car.round();
    bikeRent.value = rentCharge.bike.round();
    autoRent.value = rentCharge.auto_rickshaw.round();
    isReadyToDisplayAvlDriver.value = true;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  animateCameraPolyline() async {
    animateCamera(sourceLatitude.value, sourceLongitude.value);
    final GoogleMapController _controller = await controller.future;

    _controller.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(sourceLatitude.value, sourceLongitude.value),
            northeast:
                LatLng(destinationLatitude.value, destinationLongitude.value)),
        50));
    animateCamera(sourceLatitude.value, sourceLongitude.value);
  }

  animateCamera(double lat, double lng) async {
    final GoogleMapController _controller = await controller.future;
    CameraPosition newPos = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 11,
    );
    _controller.animateCamera(CameraUpdate.newCameraPosition(newPos));
  }

  generateTrip(UberDriverEntity driverData, int index) async {
    final TripDataController tripDataController = Get.put(TripDataController());

    // uberCancelTripUseCase.call(prevTripId.value, true); // if canceled
    subscription.pause();
    String vehicleType = driverData.vehicle!.path.split('/').first;
    String driverId = driverData.driverId.toString();
    String riderId =uberAuthGetUserUidUseCase;
    DocumentReference driverIdRef =
        FirebaseFirestore.instance.doc("/drivers/${driverId.trim()}");
    DocumentReference riderIdRef =
        FirebaseFirestore.instance.doc("/riders/$riderId");
    var tripId = const Uuid().v4();
    prevTripId.value = tripId;
    final generateTripModel = GenerateTripModel(

        tripDataController.sourcePlaceName.value,
        tripDataController.destinationPlaceName.value,
        GeoPoint(tripDataController.sourcePlaceLat.value, tripDataController.sourcePlaceLng.value),
        GeoPoint(tripDataController.destinationPlaceLat.value, tripDataController.destinationPlaceLng.value),

        uberMapDirectionData[0].distanceValue! / 1000.roundToDouble(),
        uberMapDirectionData[0].durationText,
        false,
        DateTime.now().toString(),
        driverIdRef,
        riderIdRef,
        0.0,
        false,
        vehicleType == 'cars'
            ? carRent.value
            : vehicleType == 'auto'
                ? autoRent.value
                : bikeRent.value,
        false,
        false,
        tripId,
        tripDataController.isCod.value
    );
    Stream reqStatusData = uberMapGenerateTripUseCase.call(generateTripModel);
    findDriverLoading.value = true;
    late StreamSubscription tripSubscription;
    tripSubscription = reqStatusData.listen((data) async {
      final reqStatus = data.data()['ready_for_trip'];
      if (reqStatus) {
        subscription.cancel();
      }
      if (reqStatus && findDriverLoading.value) {
        subscription.cancel();
        final reqAcceptedDriverVehicleData =
            await uberMapGetVehicleDetailsUseCase.call(
                vehicleType, driverId); // get vehicldata if req accepted
        req_accepted_driver_and_vehicle_data["name"] =
            driverData.name.toString();
        req_accepted_driver_and_vehicle_data["mobile"] =
            driverData.mobile.toString();
        req_accepted_driver_and_vehicle_data["vehicle_color"] =
            reqAcceptedDriverVehicleData.color;
        req_accepted_driver_and_vehicle_data["vehicle_model"] =
            reqAcceptedDriverVehicleData.model;
        req_accepted_driver_and_vehicle_data["vehicle_company"] =
            reqAcceptedDriverVehicleData.company;
        req_accepted_driver_and_vehicle_data["vehicle_number_plate"] =
            reqAcceptedDriverVehicleData.numberPlate.toString();
        req_accepted_driver_and_vehicle_data["profile_img"] =
            driverData.profile_img.toString();
        req_accepted_driver_and_vehicle_data["overall_rating"] =
            driverData.overall_rating.toString();
        if (markers.length > 2) {
          markers.removeRange(2, markers.length - 1);
        } // clear extra marker
        addMarkers(
            driverData.currentLocation!.latitude,
            driverData.currentLocation!.longitude,
            "acpt_driver_marker",
            driverData.vehicle!.path.split('/').first == "cars"
                ? 'assets/car.png'
                : driverData.vehicle!.path.split('/').first == "bikes"
                    ? 'assets/bike.png'
                    : 'assets/auto.png',
            "img",
            "Driver Location"); // add only acpt_driver_marker

        // draw path from acpt_driver to consumer
        // final directionData = await uberMapDirectionUsecase.call(
        //     driverData.currentLocation!.latitude,
        //     driverData.currentLocation!.longitude,
        //     sourceLatitude.value,
        //     sourceLongitude.value);
        // List<PointLatLng> result = polylinePoints
        //     .decodePolyline(directionData[0].enCodedPoints.toString());
        // polylineCoordinatesforacptDriver.clear();
        // result.forEach((PointLatLng point) {
        //   polylineCoordinatesforacptDriver.value
        //       .add(LatLng(point.latitude, point.longitude));
        // });

        if (findDriverLoading.value && reqAccepted.value == false) {
          findDriverLoading.value = false;
          Get.snackbar(
            "Yahoo!",
            "request accepted by driver,driver will arrive soon",
          );
          reqAccepted.value = true;

          //change status to  out_for_delivery to true for the selected trip
          FirestoreService().changeDeliveryStatus(tripDataController.tripId.value, "out_for_delivery", true);

          //change status to is_from_admin to true for this new trip
          FirestoreService().changeDeliveryStatus(tripId, "is_from_admin", true);
          FirestoreService().changeDeliveryStatus(tripId, "out_for_delivery", true);

        }
      } else if (data.data()['is_arrived'] && !data.data()['is_completed']) {
        Get.snackbar(
            "Hooray!", "driver arrived!",
            snackPosition: SnackPosition.BOTTOM);
        tripSubscription.cancel();
        Get.off(() => TripsScreen());
      }
      Timer(const Duration(seconds: 60), () {
        if (reqStatus == false && findDriverLoading.value) {
          tripSubscription.cancel();
          uberCancelTripUseCase.call(tripId, false);
          Get.snackbar(
              "Sorry !", "request denied by driver, please choose other driver",
              snackPosition: SnackPosition.BOTTOM);
          subscription.resume();
          findDriverLoading.value = false;
        }
      });
    });
  }
}
