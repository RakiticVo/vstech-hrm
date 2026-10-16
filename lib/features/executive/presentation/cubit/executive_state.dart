import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/executive/domain/entities/executive_stats_entity.dart';

enum ExecutiveStatus { initial, loading, success, failure }

class ExecutiveState extends Equatable {
  const new({
    this.status = ExecutiveStatus.initial,
    this.stats,
    this.errorMessage,
  });

  final ExecutiveStatus status;
  final ExecutiveStatsEntity? stats;
  final String? errorMessage;

  bool get isLoading => status == ExecutiveStatus.loading;
  bool get isSuccess => status == ExecutiveStatus.success;

  ExecutiveState copyWith({
    ExecutiveStatus? status,
    ExecutiveStatsEntity? stats,
    String? errorMessage,
  }) {
    return ExecutiveState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, stats, errorMessage];
}
