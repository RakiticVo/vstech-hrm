import 'package:vstech_hrm/features/attendance/domain/entities/face_verify_result_entity.dart';

/// DTO for Face API POST /verify/ response.
class FaceVerifyResponseModel {
  const new({
    required this.status,
    required this.match,
    required this.message,
    this.similarity,
  });

  factory fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status'];
    final status = rawStatus == true ||
        rawStatus?.toString().toLowerCase() == 'true' ||
        rawStatus?.toString().toLowerCase() == 'success' ||
        rawStatus == 1 ||
        rawStatus?.toString() == '1' ||
        json['code'] == 200;

    final hasMatchKey = json.containsKey('match');
    final rawMatch = json['match'];
    final match = hasMatchKey
        ? (rawMatch == true ||
            rawMatch?.toString().toLowerCase() == 'true' ||
            rawMatch?.toString().toLowerCase() == 'success' ||
            rawMatch == 1 ||
            rawMatch?.toString() == '1')
        : status;

    final dynamic simVal = json['similarity'] ?? json['score'];
    final similarity = simVal is num
        ? simVal.toDouble()
        : double.tryParse(simVal?.toString() ?? '');

    return FaceVerifyResponseModel(
      status: status,
      match: match,
      similarity: similarity,
      message: json['message']?.toString() ?? json['detail']?.toString() ?? '',
    );
  }

  final bool status;
  final bool match;
  final double? similarity;
  final String message;

  Map<String, dynamic> toJson() => {
        'status': status,
        'match': match,
        'similarity': similarity,
        'message': message,
      };

  FaceVerifyResultEntity toEntity() => FaceVerifyResultEntity(
        isSuccess: status,
        isMatch: match,
        similarity: similarity,
        message: message,
      );
}
