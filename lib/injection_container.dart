import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:admin/screens/booking/uber_map_feature/data/data_sources/uber_map_data_source.dart';
import 'package:admin/screens/booking/uber_map_feature/data/data_sources/uber_map_data_source_impl.dart';
import 'package:admin/screens/booking/uber_map_feature/data/repositories/uber_map_repository_impl.dart';
import 'package:admin/screens/booking/uber_map_feature/domain/repositories/uber_map_repository.dart';
import 'package:admin/screens/booking/uber_map_feature/domain/use_cases/cancel_trip_usecase.dart';
import 'package:admin/screens/booking/uber_map_feature/domain/use_cases/generate_trip_usecase.dart';
import 'package:admin/screens/booking/uber_map_feature/domain/use_cases/get_rental_charges_usecase.dart';
import 'package:admin/screens/booking/uber_map_feature/domain/use_cases/uber_map_direction_usecase.dart';
import 'package:admin/screens/booking/uber_map_feature/domain/use_cases/uber_map_get_drivers_usecase.dart';
import 'package:admin/screens/booking/uber_map_feature/domain/use_cases/uber_map_prediction_usecase.dart';
import 'package:admin/screens/booking/uber_map_feature/domain/use_cases/uber_trip_payment_usecase.dart';
import 'package:admin/screens/booking/uber_map_feature/domain/use_cases/vehicle_details_usecase.dart';
import 'package:admin/screens/booking/uber_map_feature/presentation/getx/uber_map_controller.dart';
import 'package:get_it/get_it.dart';

import 'controllers/MenuAppController.dart';

final sl = GetIt.instance;

Future<void> init() async {

  // Register MenuAppController with GetX
  Get.put(MenuAppController());

  // getx
  sl.registerFactory<UberMapController>(() => UberMapController(
      uberMapPredictionUsecase: sl.call(),
      uberMapDirectionUsecase: sl.call(),
      uberMapGetDriversUsecase: sl.call(),
      uberMapGetRentalChargesUseCase: sl.call(),
      uberMapGenerateTripUseCase: sl.call(),
      uberMapGetVehicleDetailsUseCase: sl.call(),
      uberCancelTripUseCase: sl.call(),
      ));

  // use case
  sl.registerLazySingleton<UberMapPredictionUsecase>(
          () => UberMapPredictionUsecase(uberMapRepository: sl.call()));
  sl.registerLazySingleton<UberMapDirectionUsecase>(
          () => UberMapDirectionUsecase(uberMapRepository: sl.call()));
  sl.registerLazySingleton<UberMapGetDriversUsecase>(
          () => UberMapGetDriversUsecase(uberMapRepository: sl.call()));
  sl.registerLazySingleton<UberMapGetRentalChargesUseCase>(
          () => UberMapGetRentalChargesUseCase(uberMapRepository: sl.call()));
  sl.registerLazySingleton<UberMapGenerateTripUseCase>(
          () => UberMapGenerateTripUseCase(uberMapRepository: sl.call()));
  sl.registerLazySingleton<UberMapGetVehicleDetailsUseCase>(
          () => UberMapGetVehicleDetailsUseCase(uberMapRepository: sl.call()));

  sl.registerLazySingleton<UberCancelTripUseCase>(
          () => UberCancelTripUseCase(uberMapRepository: sl.call()));
  sl.registerLazySingleton<UberTripPaymentUseCase>(
          () => UberTripPaymentUseCase(uberMapRepository: sl.call()));

  // repository
  sl.registerLazySingleton<UberMapRepository>(
          () => UberMapRepositoryImpl(uberMapDataSource: sl.call()));

  // datasource
  sl.registerLazySingleton<UberMapDataSource>(() => UberMapDataSourceImpl(
       firestore: sl.call()));
  sl.registerLazySingleton(() => http.Client());

  //External
  final fireStore = FirebaseFirestore.instance;
  sl.registerLazySingleton(() => fireStore);

}