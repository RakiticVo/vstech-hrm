import 'package:vstech_hrm/features/compliance/domain/entities/risk_alert_entity.dart';

class RiskAlertModel {
  const new({
    required this.id,
    required this.title,
    required this.description,
    required this.metricValue,
    required this.tier,
    required this.branch,
    required this.detectedTimeText,
    this.isAssignedToHr = false,
  });

  factory fromJson(Map<String, dynamic> json) {
    final tStr = (json['tier'] as String?)?.toLowerCase();
    final tier = switch (tStr) {
      'critical' => RiskTier.critical,
      'high' => RiskTier.high,
      _ => RiskTier.medium,
    };

    return RiskAlertModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      metricValue: json['metricValue'] as String,
      tier: tier,
      branch: json['branch'] as String,
      detectedTimeText: json['detectedTimeText'] as String,
      isAssignedToHr: json['isAssignedToHr'] as bool? ?? false,
    );
  }

  final String id;
  final String title;
  final String description;
  final String metricValue;
  final RiskTier tier;
  final String branch;
  final String detectedTimeText;
  final bool isAssignedToHr;

  RiskAlertEntity toEntity() => RiskAlertEntity(
        id: id,
        title: title,
        description: description,
        metricValue: metricValue,
        tier: tier,
        branch: branch,
        detectedTimeText: detectedTimeText,
        isAssignedToHr: isAssignedToHr,
      );
}
