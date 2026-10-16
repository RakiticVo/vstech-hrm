import 'package:vstech_hrm/features/attendance/domain/entities/face_check_reg_entity.dart';

/// DTO for Face API GET /checkreg/ response.
class FaceCheckRegModel {
  const new({
    required this.status,
    required this.registered,
    required this.count,
    required this.message,
  });

  factory fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status'];
    final status = rawStatus == true ||
        rawStatus?.toString().toLowerCase() == 'true' ||
        rawStatus?.toString().toLowerCase() == 'success' ||
        rawStatus == 1 ||
        rawStatus?.toString() == '1' ||
        json['code'] == 200;

    final parsedCount = int.tryParse(json['count']?.toString() ?? '0') ?? 0;
    final rawReg = json['registered'];
    final isExplicitReg = rawReg == true ||
        rawReg?.toString().toLowerCase() == 'true' ||
        rawReg?.toString().toLowerCase() == 'success' ||
        rawReg == 1 ||
        rawReg?.toString() == '1';

    return FaceCheckRegModel(
      status: status,
      registered: isExplicitReg || parsedCount > 0,
      count: parsedCount,
      message: json['message']?.toString() ?? json['detail']?.toString() ?? '',
    );
  }

  final bool status;
  final bool registered;
  final int count;
  final String message;

  Map<String, dynamic> toJson() => {
        'status': status,
        'registered': registered,
        'count': count,
        'message': message,
      };

  FaceCheckRegEntity toEntity() => FaceCheckRegEntity(
        isSuccess: status,
        isRegistered: registered,
        count: count,
        message: message,
      );
}
