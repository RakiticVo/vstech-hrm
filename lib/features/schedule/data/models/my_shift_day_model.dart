import 'package:vstech_hrm/features/schedule/domain/entities/my_shift_day_entity.dart';

/// DTO model for MyShiftDayDoc in OpenAPI 3.0.1 (GET /api/ShiftSchedules/me).
class MyShiftDayModel {
  const new({
    required this.date,
    this.shiftCode,
    this.shiftName,
    this.startHour,
    this.endHour,
    this.isOvernight = false,
    this.source,
  });

  factory fromJson(Map<String, dynamic> json) {
    return MyShiftDayModel(
      date: json['date']?.toString() ?? '',
      shiftCode: json['shiftCode']?.toString(),
      shiftName: json['shiftName']?.toString(),
      startHour: json['startHour']?.toString(),
      endHour: json['endHour']?.toString(),
      isOvernight: json['isOvernight'] == true,
      source: json['source']?.toString(),
    );
  }

  final String date;
  final String? shiftCode;
  final String? shiftName;
  final String? startHour;
  final String? endHour;
  final bool isOvernight;
  final String? source;

  MyShiftDayEntity toEntity() {
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(date);
    } on Object catch (_) {
      parsedDate = DateTime.now();
    }

    return MyShiftDayEntity(
      date: parsedDate,
      shiftCode: shiftCode,
      shiftName: shiftName,
      startHour: startHour,
      endHour: endHour,
      isOvernight: isOvernight,
      source: source,
    );
  }
}
