import 'package:equatable/equatable.dart';

/// DTO mapping to Notification in OpenAPI 3.0.1.
class AppNotificationModel extends Equatable {
  const new({
    required this.id,
    required this.title,
    required this.body,
    this.image,
    this.userCode,
    this.departmentCode,
    this.keyPage,
    this.status = 2,
    this.dateSent,
  });

  factory fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id'] is num ? (json['id'] as num).toInt() : 0,
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      image: json['image']?.toString(),
      userCode: json['userCode']?.toString(),
      departmentCode: json['departmentCode']?.toString(),
      keyPage: json['keyPage']?.toString(),
      status: json['status'] is num ? (json['status'] as num).toInt() : 2,
      dateSent: json['dateSent']?.toString(),
    );
  }

  final int id;
  final String title;
  final String body;
  final String? image;
  final String? userCode;
  final String? departmentCode;
  final String? keyPage;
  final int status;
  final String? dateSent;

  bool get isRead => status == 1;

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        image,
        userCode,
        departmentCode,
        keyPage,
        status,
        dateSent,
      ];
}
