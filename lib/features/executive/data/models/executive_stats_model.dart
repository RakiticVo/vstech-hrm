import 'package:vstech_hrm/features/executive/domain/entities/executive_stats_entity.dart';

class ExecutiveStatsModel {
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

  factory fromJson(Map<String, dynamic> json) {
    final risksRaw = json['flaggedRisks'] as List<dynamic>? ?? [];
    final deptsRaw = json['departmentRates'] as List<dynamic>? ?? [];

    return ExecutiveStatsModel(
      totalHeadcount: (json['totalHeadcount'] as num?)?.toInt() ?? 3142,
      todayAttendanceRate: (json['todayAttendanceRate'] as num?)?.toDouble() ?? 98.2,
      monthlyPayrollVnd: (json['monthlyPayrollVnd'] as num?)?.toDouble() ?? 42800000000,
      payrollGrowthPercentage: (json['payrollGrowthPercentage'] as num?)?.toDouble() ?? 3.4,
      monthlyOvertimeHours: (json['monthlyOvertimeHours'] as num?)?.toDouble() ?? 14280,
      avgOvertimePerWorker: (json['avgOvertimePerWorker'] as num?)?.toDouble() ?? 18.2,
      turnoverRate: (json['turnoverRate'] as num?)?.toDouble() ?? 0.8,
      pendingFinalApprovalsCount: (json['pendingFinalApprovalsCount'] as num?)?.toInt() ?? 4,
      oldestPendingHours: (json['oldestPendingHours'] as num?)?.toInt() ?? 18,
      flaggedRisks: risksRaw
          .map(
            (r) {
              final rMap = r as Map<String, dynamic>;
              return ExecutiveFlagSummary(
                id: rMap['id'] as String,
                title: rMap['title'] as String,
                description: rMap['description'] as String,
                metricValue: rMap['metricValue'] as String,
                tier: rMap['tier'] as String,
                department: rMap['department'] as String,
              );
            },
          )
          .toList(),
      departmentRates: deptsRaw
          .map(
            (d) {
              final dMap = d as Map<String, dynamic>;
              return DepartmentAttendanceRate(
                name: dMap['name'] as String,
                presentCount: (dMap['presentCount'] as num).toInt(),
                totalCount: (dMap['totalCount'] as num).toInt(),
                percentage: (dMap['percentage'] as num).toDouble(),
              );
            },
          )
          .toList(),
    );
  }

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

  ExecutiveStatsEntity toEntity() => ExecutiveStatsEntity(
        totalHeadcount: totalHeadcount,
        todayAttendanceRate: todayAttendanceRate,
        monthlyPayrollVnd: monthlyPayrollVnd,
        payrollGrowthPercentage: payrollGrowthPercentage,
        monthlyOvertimeHours: monthlyOvertimeHours,
        avgOvertimePerWorker: avgOvertimePerWorker,
        turnoverRate: turnoverRate,
        pendingFinalApprovalsCount: pendingFinalApprovalsCount,
        oldestPendingHours: oldestPendingHours,
        flaggedRisks: flaggedRisks,
        departmentRates: departmentRates,
      );
}
