import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/features/compliance/domain/usecases/compliance_usecases.dart';
import 'package:vstech_hrm/features/compliance/presentation/cubits/risk_alerts_state.dart';

class RiskAlertsCubit extends Cubit<RiskAlertsState> {
  new({
    required this.getRiskAlertsUseCase,
    required this.assignRiskToHrUseCase,
  }) : super(const RiskAlertsInitial());

  final GetRiskAlertsUseCase getRiskAlertsUseCase;
  final AssignRiskToHrUseCase assignRiskToHrUseCase;

  Future<void> fetchRiskAlerts() async {
    emit(const RiskAlertsLoading());
    final result = await getRiskAlertsUseCase();
    result.fold(
      (failure) => emit(RiskAlertsError(failure.message)),
      (alerts) => emit(RiskAlertsLoaded(alerts: alerts)),
    );
  }

  Future<void> assignToHr(String alertId) async {
    final currentState = state;
    if (currentState is! RiskAlertsLoaded) return;

    emit(currentState.copyWith(isAssigning: true));
    final result = await assignRiskToHrUseCase(alertId);

    result.fold(
      (failure) => emit(RiskAlertsError(failure.message)),
      (_) {
        final updatedAlerts = currentState.alerts.map((alert) {
          if (alert.id == alertId) {
            return alert.copyWith(isAssignedToHr: true);
          }
          return alert;
        }).toList();

        emit(currentState.copyWith(
          alerts: updatedAlerts,
          isAssigning: false,
          actionMessage: alertId,
        ));
      },
    );
  }
}
