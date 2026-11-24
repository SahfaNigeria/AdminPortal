import '../../shared/model/mothers_model.dart';
import '../../shared/model/health_professionals.dart';

List<MothersModel> parseMothers(List<Map<String, dynamic>> data) {
  return data
      .map(
        (e) => MothersModel.fromJson(
          e,
          id: e['_documentId'] as String?,
        ),
      )
      .toList();
}

List<HealthProfessionalsModel> parseHealthProfessionals(
  List<Map<String, dynamic>> data,
) {
  return data
      .map(
        (e) => HealthProfessionalsModel.fromJson(
          e,
          id: e['_documentId'] as String?,
        ),
      )
      .toList();
}
