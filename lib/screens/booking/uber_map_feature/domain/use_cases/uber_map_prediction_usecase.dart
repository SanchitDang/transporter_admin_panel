import '../entities/uber_map_prediction_entity.dart';
import '../repositories/uber_map_repository.dart';

class UberMapPredictionUsecase {
  final UberMapRepository uberMapRepository;

  UberMapPredictionUsecase({required this.uberMapRepository});

  Future<List<UberMapPredictionEntity>> call(String placeName) async {
    return await uberMapRepository.getUberMapPrediction(placeName);
  }
}
