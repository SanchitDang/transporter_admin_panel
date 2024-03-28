import '../../data/models/vehicle_details_model.dart';
import '../repositories/uber_map_repository.dart';

class UberMapGetVehicleDetailsUseCase {
  final UberMapRepository uberMapRepository;

  UberMapGetVehicleDetailsUseCase({required this.uberMapRepository});

  Future<VehicleModel> call(String vehicleType, String driverId) {
    return uberMapRepository.getVehicleDetails(vehicleType, driverId);
  }
}
