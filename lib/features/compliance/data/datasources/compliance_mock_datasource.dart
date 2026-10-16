import 'package:vstech_hrm/features/compliance/data/models/delegation_model.dart';
import 'package:vstech_hrm/features/compliance/data/models/risk_alert_model.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/delegation_entity.dart';
import 'package:vstech_hrm/features/compliance/domain/entities/risk_alert_entity.dart';

abstract class ComplianceMockDatasource {
  Future<List<RiskAlertModel>> getRiskAlerts();
  Future<void> assignRiskToHr(String alertId);
  Future<List<DelegatePersonModel>> getEligibleDelegates();
  Future<List<DelegationModel>> getActiveDelegations();
  Future<DelegationModel> createDelegation({
    required DelegatePersonEntity delegatePerson,
    required DateTime fromDate,
    required DateTime toDate,
    required String scopeDescription,
    required String financialLimitText,
  });
  Future<void> revokeDelegation(String delegationId);
}

class ComplianceMockDatasourceImpl implements ComplianceMockDatasource {
  final List<RiskAlertModel> _alerts = [
    const RiskAlertModel(
      id: 'RA-01',
      title: '14 công nhân tăng ca vượt trần 40h/tháng',
      description:
          'Quy định Điều 107 Bộ luật Lao động: làm thêm tối đa 40h/tháng. Cần điều chuyển chuyền sản xuất.',
      metricValue: '44.5h / 40h',
      tier: RiskTier.critical,
      branch: 'Xưởng May 2 · Chuyền 4',
      detectedTimeText: '08:15 Hôm nay',
    ),
    const RiskAlertModel(
      id: 'RA-02',
      title: 'Chưa ký phụ lục gia hạn HĐLĐ cho 8 nhân sự',
      description:
          'Hợp đồng xác định thời hạn 12 tháng đã đến hạn gia hạn, quá hạn thỏa thuận phụ lục.',
      metricValue: 'Quá hạn 3 ngày',
      tier: RiskTier.critical,
      branch: 'Khối Kỹ thuật & Bảo trì',
      detectedTimeText: 'Hôm qua',
    ),
    const RiskAlertModel(
      id: 'RA-03',
      title: '6 công nhân làm việc ca đêm liên tục 7 ngày',
      description:
          'Vi phạm quy định nghỉ bù sau ca đêm (khoản 2 Điều 109 BLLĐ). Nguy cơ mệt mỏi và tai nạn lao động.',
      metricValue: '7 ca đêm liên tiếp',
      tier: RiskTier.high,
      branch: 'Xưởng Cắt & Đóng gói',
      detectedTimeText: '07:30 Hôm nay',
    ),
    const RiskAlertModel(
      id: 'RA-04',
      title: 'Quỹ lương tháng 09 vượt dự toán 4.2%',
      description:
          'Chi phí làm thêm ca và tăng ca chủ nhật tăng đột biến ở bộ phận hoàn thiện đơn hàng xuất khẩu.',
      metricValue: '+1.8 Tỷ VNĐ',
      tier: RiskTier.high,
      branch: 'Toàn công ty',
      detectedTimeText: '2 ngày trước',
    ),
    const RiskAlertModel(
      id: 'RA-05',
      title: 'Tỷ lệ đi làm Xưởng Cắt giảm đột biến',
      description:
          'Tỷ lệ đi làm 91.8% giảm 5.2% so với trung bình tuần trước, do dịch cúm mùa tập trung.',
      metricValue: '91.8% (-5.2%)',
      tier: RiskTier.medium,
      branch: 'Xưởng Cắt A',
      detectedTimeText: '09:00 Hôm nay',
    ),
    const RiskAlertModel(
      id: 'RA-06',
      title: '12 chứng chỉ an toàn vận hành sắp hết hạn',
      description:
          'Chứng chỉ vận hành nồi hơi và xe nâng cần đào tạo và sát hạch gia hạn trong vòng 15 ngày.',
      metricValue: '12 nhân sự',
      tier: RiskTier.medium,
      branch: 'Tổ Vận hành Cơ điện',
      detectedTimeText: '3 ngày trước',
    ),
  ];

  final List<DelegatePersonModel> _delegates = const [
    DelegatePersonModel(
      id: 'DEL-01',
      name: 'Trần Văn Nam',
      role: 'Phó Tổng Giám Đốc',
      department: 'Ban Điều Hành',
      initials: 'TN',
    ),
    DelegatePersonModel(
      id: 'DEL-02',
      name: 'Nguyễn Thị Mai Hương',
      role: 'Giám Đốc Nhân Sự',
      department: 'Khối Nhân Sự & Đào Tạo',
      initials: 'MH',
    ),
    DelegatePersonModel(
      id: 'DEL-03',
      name: 'Lê Hoàng Phúc',
      role: 'Giám Đốc Điều Hành Sản Xuất',
      department: 'Khối Nhà Máy',
      initials: 'HP',
    ),
  ];

  final List<DelegationModel> _delegations = [
    DelegationModel(
      id: 'DLG-2026-001',
      delegatePerson: const DelegatePersonEntity(
        id: 'DEL-01',
        name: 'Trần Văn Nam',
        role: 'Phó Tổng Giám Đốc',
        department: 'Ban Điều Hành',
        initials: 'TN',
      ),
      fromDate: DateTime(2026, 9, 20),
      toDate: DateTime(2026, 9, 27),
      scopeDescription: 'Tất cả các loại đơn · Hạn mức: ≤ 50.000.000 VNĐ',
      financialLimitText: '≤ 50.000.000 VNĐ',
      isActive: true,
      createdAt: DateTime(2026, 9, 19, 15, 30),
    ),
  ];

  @override
  Future<List<RiskAlertModel>> getRiskAlerts() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List.from(_alerts);
  }

  @override
  Future<void> assignRiskToHr(String alertId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = _alerts.indexWhere((element) => element.id == alertId);
    if (index != -1) {
      final current = _alerts[index];
      _alerts[index] = RiskAlertModel(
        id: current.id,
        title: current.title,
        description: current.description,
        metricValue: current.metricValue,
        tier: current.tier,
        branch: current.branch,
        detectedTimeText: current.detectedTimeText,
        isAssignedToHr: true,
      );
    }
  }

  @override
  Future<List<DelegatePersonModel>> getEligibleDelegates() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List.from(_delegates);
  }

  @override
  Future<List<DelegationModel>> getActiveDelegations() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _delegations.where((d) => d.isActive).toList();
  }

  @override
  Future<DelegationModel> createDelegation({
    required DelegatePersonEntity delegatePerson,
    required DateTime fromDate,
    required DateTime toDate,
    required String scopeDescription,
    required String financialLimitText,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final newDelegation = DelegationModel(
      id: 'DLG-${DateTime.now().millisecondsSinceEpoch}',
      delegatePerson: delegatePerson,
      fromDate: fromDate,
      toDate: toDate,
      scopeDescription: scopeDescription,
      financialLimitText: financialLimitText,
      isActive: true,
      createdAt: DateTime.now(),
    );
    _delegations.insert(0, newDelegation);
    return newDelegation;
  }

  @override
  Future<void> revokeDelegation(String delegationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = _delegations.indexWhere((d) => d.id == delegationId);
    if (index != -1) {
      final current = _delegations[index];
      _delegations[index] = DelegationModel(
        id: current.id,
        delegatePerson: current.delegatePerson,
        fromDate: current.fromDate,
        toDate: current.toDate,
        scopeDescription: current.scopeDescription,
        financialLimitText: current.financialLimitText,
        isActive: false,
        createdAt: current.createdAt,
      );
    }
  }
}
