import 'package:equatable/equatable.dart';

/// DTO command for ConfirmTimesheetConfirmRequestCommand in OpenAPI 3.0.1.
class TimesheetConfirmApproveCommand extends Equatable {
  const new({
    this.confirmedWorktime,
    this.confirmNote,
  });

  final double? confirmedWorktime;
  final String? confirmNote;

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (confirmedWorktime != null) 'confirmedWorktime': confirmedWorktime,
        if (confirmNote != null) 'confirmNote': confirmNote,
      };

  @override
  List<Object?> get props => [confirmedWorktime, confirmNote];
}

/// DTO for ServiceResultResponse in OpenAPI 3.0.1 (common response for accept/deny actions).
class ServiceResultResponseModel extends Equatable {
  const new({this.message});

  factory fromJson(Map<String, dynamic> json) {
    return ServiceResultResponseModel(
      message: json['message']?.toString(),
    );
  }

  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Request type category enumeration for Manager Approvals.
enum ApprovalCategory {
  leave,
  overtime,
  correction,
  businessTrip,
  swap,
}
