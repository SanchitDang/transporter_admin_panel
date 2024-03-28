
import '../../data/models/generate_trip_model.dart';
import '../repositories/uber_map_repository.dart';

class UberMapGenerateTripUseCase {
  final UberMapRepository uberMapRepository;

  UberMapGenerateTripUseCase({required this.uberMapRepository});

  Stream call(GenerateTripModel generateTripModel) {
    return uberMapRepository.generateTrip(generateTripModel);
  }
}
