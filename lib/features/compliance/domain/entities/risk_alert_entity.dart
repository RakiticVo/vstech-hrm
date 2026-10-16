import 'package:equatable/equatable.dart';

enum RiskTier { critical, high, medium }

class RiskAlertEntity extends Equatable {
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

  final String id;
  final String title;
  final String description;
  final String metricValue;
  final RiskTier tier;
  final String branch;
  final String detectedTimeText;
  final bool isAssignedToHr;

  RiskAlertEntity copyWith({bool? isAssignedToHr}) {
    return RiskAlertEntity(
      id: id,
      title: title,
      description: description,
      metricValue: metricValue,
      tier: tier,
      branch: branch,
      detectedTimeText: detectedTimeText,
      isAssignedToHr: isAssignedToHr ?? this.isAssignedToHr,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        metricValue,
        tier,
        branch,
        detectedTimeText,
        isAssignedToHr,
      ];
}
