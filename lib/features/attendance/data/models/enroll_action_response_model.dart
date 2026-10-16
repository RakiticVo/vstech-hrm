import 'package:equatable/equatable.dart';

/// DTO mapping to EnrollActionResponse from OpenAPI 3.0.1 (docs/api/api-1.json).
class EnrollActionResponseModel extends Equatable {
  const new({
    required this.message,
    this.checkin,
    this.checkout,
  });

  factory fromJson(Map<String, dynamic> json) {
    return EnrollActionResponseModel(
      message: json['message']?.toString() ?? '',
      checkin: json['checkin'] as bool?,
      checkout: json['checkout'] as bool?,
    );
  }

  final String message;
  final bool? checkin;
  final bool? checkout;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'message': message,
        'checkin': checkin,
        'checkout': checkout,
      };

  @override
  List<Object?> get props => [message, checkin, checkout];
}
