import 'package:equatable/equatable.dart';

/// DTO mapping to EnrollForm from OpenAPI 3.0.1 (docs/api/api-1.json).
class EnrollFormModel extends Equatable {
  const new({
    required this.coordinate,
    required this.local,
    required this.fingerprint,
    this.ip4,
    this.ip6,
    this.time,
    this.date,
  });

  final String coordinate;
  final String local;
  final String fingerprint;
  final String? ip4;
  final String? ip6;
  final String? time;
  final String? date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'coordinate': coordinate,
      'local': local,
      'fingerprint': fingerprint,
    };
    if (ip4 != null) map['ip4'] = ip4;
    if (ip6 != null) map['ip6'] = ip6;
    if (time != null) map['time'] = time;
    if (date != null) map['date'] = date;
    return map;
  }

  @override
  List<Object?> get props => [
        coordinate,
        local,
        fingerprint,
        ip4,
        ip6,
        time,
        date,
      ];
}
