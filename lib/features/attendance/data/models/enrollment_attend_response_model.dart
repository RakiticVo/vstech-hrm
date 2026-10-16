import 'package:equatable/equatable.dart';

/// DTO mapping to EnrollmentAttendResponse from OpenAPI 3.0.1 (docs/api/api-1.json).
class EnrollmentAttendResponseModel extends Equatable {
  const new({
    this.mode = 'IN',
  });

  factory fromJson(Map<String, dynamic> json) {
    return EnrollmentAttendResponseModel(
      mode: json['mode']?.toString() ?? 'IN',
    );
  }

  final String mode;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'mode': mode,
      };

  @override
  List<Object?> get props => [mode];
}
