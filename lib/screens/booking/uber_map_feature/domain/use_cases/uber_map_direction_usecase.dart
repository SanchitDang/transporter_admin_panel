import '../entities/uber_map_direction_entity.dart';
import '../repositories/uber_map_repository.dart';

class UberMapDirectionUsecase {
  final UberMapRepository uberMapRepository;

  UberMapDirectionUsecase({required this.uberMapRepository});

  Future<List<UberMapDirectionEntity>> call(double sourceLat, double sourceLng,
      double destinationLat, double destinationLng) async {
    return await uberMapRepository.getUberMapDirection(
        sourceLat, sourceLng, destinationLat, destinationLng);
  }
}
