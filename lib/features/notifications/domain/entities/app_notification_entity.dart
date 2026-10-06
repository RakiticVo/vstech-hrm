import 'package:equatable/equatable.dart';

/// Pure domain entity for notification.
class AppNotificationEntity extends Equatable {
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
