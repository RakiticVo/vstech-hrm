import 'package:equatable/equatable.dart';

/// DTO mapping to EmployeeDynamicValueExtServiceResultResponse from GET /api/Account/basic.
class EmployeeBasicInfoModel extends Equatable {
  const new({
    this.message,
    this.data = const <String, dynamic>{},
  });

  factory fromJson(Map<String, dynamic> json) {
    return EmployeeBasicInfoModel(
      message: json['message']?.toString(),
      data: json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : const <String, dynamic>{},
    );
  }

  final String? message;
  final Map<String, dynamic> data;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'message': message,
        'data': data,
      };

  @override
  List<Object?> get props => [message, data];
}
