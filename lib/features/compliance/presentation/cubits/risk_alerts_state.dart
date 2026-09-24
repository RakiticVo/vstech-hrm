import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/risk_alert_entity.dart';

sealed class RiskAlertsState extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}

final class RiskAlertsInitial extends RiskAlertsState {
  const new();
}

final class RiskAlertsLoading extends RiskAlertsState {
  const new();
}

final class RiskAlertsLoaded extends RiskAlertsState {
  const new({
    required this.alerts,
    this.actionMessage,
    this.isAssigning = false,
  });

  final List<RiskAlertEntity> alerts;
  final String? actionMessage;
  final bool isAssigning;

  int get criticalCount =>
      alerts.where((a) => a.tier == RiskTier.critical).length;

  int get highCount => alerts.where((a) => a.tier == RiskTier.high).length;

  int get mediumCount => alerts.where((a) => a.tier == RiskTier.medium).length;

  RiskAlertsLoaded copyWith({
    List<RiskAlertEntity>? alerts,
    String? actionMessage,
    bool? isAssigning,
  }) {
    return RiskAlertsLoaded(
      alerts: alerts ?? this.alerts,
      actionMessage: actionMessage,
      isAssigning: isAssigning ?? this.isAssigning,
    );
  }

  @override
  List<Object?> get props => [alerts, actionMessage, isAssigning];
}

final class RiskAlertsError extends RiskAlertsState {
  const new(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
