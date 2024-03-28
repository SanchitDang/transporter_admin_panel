import '../../data/models/rental_charges_model.dart';
import '../repositories/uber_map_repository.dart';

class UberMapGetRentalChargesUseCase {
  final UberMapRepository uberMapRepository;

  UberMapGetRentalChargesUseCase({required this.uberMapRepository});

  Future<RentalChargeModel> call(double kms) async {
    return await uberMapRepository.getRentalChargeForVehicle(kms);
  }
}
