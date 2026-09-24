import 'package:equatable/equatable.dart';

/// Department attendance metric for workshop breakdown.
class DepartmentAttendanceRate extends Equatable {
  const new({
    required this.name,
    required this.presentCount,
    required this.totalCount,
    required this.percentage,
  });

  final String name;
  final int presentCount;
  final int totalCount;
  final double percentage;

  @override
  List<Object?> get props => [name, presentCount, totalCount, percentage];
}

/// Urgent compliance flag requiring executive attention.
class ExecutiveFlagSummary extends Equatable {
  const new({
    required this.id,
    required this.title,
    required this.description,
    required this.metricValue,
    required this.tier,
    required this.department,
  });

  final String id;
  final String title;
  final String description;
  final String metricValue;
  final String tier; // critical, high, medium
  final String department;

  @override
  List<Object?> get props => [id, title, description, metricValue, tier, department];
}

/// Overall company statistics for C-Level executives.
class ExecutiveStatsEntity extends Equatable {
  const new({
    required this.totalHeadcount,
    required this.todayAttendanceRate,
    required this.monthlyPayrollVnd,
    required this.payrollGrowthPercentage,
    required this.monthlyOvertimeHours,
    required this.avgOvertimePerWorker,
    required this.turnoverRate,
    required this.pendingFinalApprovalsCount,
    required this.oldestPendingHours,
    required this.flaggedRisks,
    required this.departmentRates,
  });

  final int totalHeadcount;
  final double todayAttendanceRate;
  final double monthlyPayrollVnd;
  final double payrollGrowthPercentage;
  final double monthlyOvertimeHours;
  final double avgOvertimePerWorker;
  final double turnoverRate;
  final int pendingFinalApprovalsCount;
  final int oldestPendingHours;
  final List<ExecutiveFlagSummary> flaggedRisks;
  final List<DepartmentAttendanceRate> departmentRates;

  @override
  List<Object?> get props => [
        totalHeadcount,
        todayAttendanceRate,
        monthlyPayrollVnd,
        payrollGrowthPercentage,
        monthlyOvertimeHours,
        avgOvertimePerWorker,
        turnoverRate,
        pendingFinalApprovalsCount,
        oldestPendingHours,
        flaggedRisks,
        departmentRates,
      ];
}
