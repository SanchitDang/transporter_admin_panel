import '../entities/uber_map_get_drivers_entity.dart';
import '../repositories/uber_map_repository.dart';

class UberMapGetDriversUsecase {
  final UberMapRepository uberMapRepository;

  UberMapGetDriversUsecase({required this.uberMapRepository});

  Stream<List<UberDriverEntity>> call() {
    return uberMapRepository.getAvailableDrivers();
  }
}
