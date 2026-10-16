import 'package:vstech_hrm/features/executive/data/models/executive_stats_model.dart';
import 'package:vstech_hrm/features/executive/data/models/final_approval_model.dart';

class ExecutiveMockDataSource {
  const new();

  Future<ExecutiveStatsModel> getOverviewStats() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return ExecutiveStatsModel.fromJson({
      'totalHeadcount': 3142,
      'todayAttendanceRate': 98.2,
      'monthlyPayrollVnd': 42850000000.0,
      'payrollGrowthPercentage': 3.4,
      'monthlyOvertimeHours': 14280.0,
      'avgOvertimePerWorker': 18.2,
      'turnoverRate': 0.8,
      'pendingFinalApprovalsCount': 4,
      'oldestPendingHours': 18,
      'flaggedRisks': [
        {
          'id': 'risk_01',
          'title': '14 công nhân Xưởng SMT 2 vượt ngưỡng OT 40h/tháng',
          'description': 'Đã ghi nhận 46.5h/tháng. Nguy cơ vi phạm quy định làm thêm giờ của Bộ luật Lao động.',
          'metricValue': '+46.5h / 40h',
          'tier': 'critical',
          'department': 'Xưởng Lắp ráp Điện tử 2',
        },
        {
          'id': 'risk_02',
          'title': '8 nhân viên ca đêm liên tiếp 6 ca chưa bố trí nghỉ bù',
          'description': 'Vi phạm quy định thời gian nghỉ ngơi tối thiểu giữa các ca làm việc đặc thù.',
          'metricValue': '6 ca liên tục',
          'tier': 'high',
          'department': 'Xưởng Cơ khí Chính xác',
        },
      ],
      'departmentRates': [
        {
          'name': 'Xưởng Lắp ráp Điện tử 1',
          'presentCount': 1024,
          'totalCount': 1040,
          'percentage': 98.4,
        },
        {
          'name': 'Xưởng Lắp ráp Điện tử 2',
          'presentCount': 910,
          'totalCount': 930,
          'percentage': 97.8,
        },
        {
          'name': 'Xưởng Cơ khí Chính xác',
          'presentCount': 684,
          'totalCount': 690,
          'percentage': 99.1,
        },
        {
          'name': 'Khối Văn phòng & R&D',
          'presentCount': 468,
          'totalCount': 482,
          'percentage': 96.5,
        },
      ],
    });
  }

  Future<List<FinalApprovalItemModel>> getFinalQueue() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final now = DateTime.now();
    return [
      FinalApprovalItemModel.fromJson({
        'id': 'final_01',
        'employeeName': 'Trần Minh Quân',
        'employeeRole': 'Trưởng ca Vận hành Máy CNC',
        'department': 'Xưởng Cơ khí Chính xác',
        'categoryTag': 'ĐỀ XUẤT TĂNG LƯƠNG',
        'financialImpact': '+4.500.000 đ/tháng',
        'contingencyBudget': 'Còn 84% ngân sách',
        'hrNotes': 'Đạt KPI 115% liên tục 3 quý. Đã qua thẩm định ngân sách của Kế toán & HR.',
        'createdAt': now.subtract(const Duration(hours: 18)).toIso8601String(),
        'approvalChain': [
          {'roleTitle': 'Người đề xuất', 'actorName': 'Trần Minh Quân', 'status': 'done', 'timestampText': '18h trước'},
          {'roleTitle': 'Quản lý trực tiếp', 'actorName': 'Lê Văn Thắng (Quản đốc)', 'status': 'done', 'timestampText': '14h trước'},
          {'roleTitle': 'HR Xác nhận', 'actorName': 'Phạm Thu Trang (HR Head)', 'status': 'done', 'timestampText': '6h trước'},
          {'roleTitle': 'Giám đốc Phê duyệt', 'actorName': 'Lê Hoàng (CEO)', 'status': 'pending', 'timestampText': 'Đang chờ quyết định'},
        ],
      }),
      FinalApprovalItemModel.fromJson({
        'id': 'final_02',
        'employeeName': 'Đỗ Thị Bích Ngân',
        'employeeRole': 'Kỹ sư Kiểm soát Chất lượng (QA/QC)',
        'department': 'Phòng Quản lý Chất lượng',
        'categoryTag': 'BỔ NHIỆM PHÓ PHÒNG',
        'financialImpact': '+6.800.000 đ/tháng',
        'contingencyBudget': 'Còn 91% ngân sách',
        'hrNotes': 'Thẩm định hồ sơ năng lực 5 năm, hoàn thành dự án ISO 9001-2015 xuất sắc.',
        'createdAt': now.subtract(const Duration(hours: 12)).toIso8601String(),
        'approvalChain': [
          {'roleTitle': 'Người đề xuất', 'actorName': 'Nguyễn Tấn Phát (Trưởng phòng)', 'status': 'done', 'timestampText': '12h trước'},
          {'roleTitle': 'HR Xác nhận', 'actorName': 'Phạm Thu Trang (HR Head)', 'status': 'done', 'timestampText': '8h trước'},
          {'roleTitle': 'Giám đốc Phê duyệt', 'actorName': 'Lê Hoàng (CEO)', 'status': 'pending', 'timestampText': 'Đang chờ quyết định'},
        ],
      }),
      FinalApprovalItemModel.fromJson({
        'id': 'final_03',
        'employeeName': 'Nhóm Tối ưu Tự động hóa',
        'employeeRole': 'Đại diện: Hoàng Anh Tuấn',
        'department': 'Trung tâm R&D & Robot',
        'categoryTag': 'THƯỞNG DỰ ÁN SÁNG KIẾN',
        'financialImpact': '35.000.000 đ (1 lần)',
        'contingencyBudget': 'Quỹ Khen thưởng Q3',
        'hrNotes': 'Sáng kiến giảm thời gian dừng chuyền 14%, tiết kiệm 210 triệu đồng/tháng.',
        'createdAt': now.subtract(const Duration(hours: 8)).toIso8601String(),
        'approvalChain': [
          {'roleTitle': 'Đề xuất', 'actorName': 'Hoàng Anh Tuấn', 'status': 'done', 'timestampText': '8h trước'},
          {'roleTitle': 'Ban Thẩm định Kỹ thuật', 'actorName': 'Vũ Quốc Bảo (CTO)', 'status': 'done', 'timestampText': '4h trước'},
          {'roleTitle': 'Giám đốc Phê duyệt', 'actorName': 'Lê Hoàng (CEO)', 'status': 'pending', 'timestampText': 'Đang chờ quyết định'},
        ],
      }),
      FinalApprovalItemModel.fromJson({
        'id': 'final_04',
        'employeeName': 'Tổ Lắp ráp Cụm Cảm biến',
        'employeeRole': '22 công nhân viên',
        'department': 'Xưởng Lắp ráp Điện tử 1',
        'categoryTag': 'TĂNG CA ĐẶC BIỆT ĐƠN HÀNG XUẤT KHẨU',
        'financialImpact': '+18.400.000 đ (OT)',
        'contingencyBudget': 'Ngân sách Đơn hàng Mỹ',
        'hrNotes': 'Đơn hàng giao gấp trước 30/09. Đã kiểm tra cam kết an toàn & phiếu tự nguyện.',
        'createdAt': now.subtract(const Duration(hours: 3)).toIso8601String(),
        'approvalChain': [
          {'roleTitle': 'Quản đốc đề xuất', 'actorName': 'Ngô Minh Đức', 'status': 'done', 'timestampText': '3h trước'},
          {'roleTitle': 'HR Xác nhận', 'actorName': 'Phạm Thu Trang (HR Head)', 'status': 'done', 'timestampText': '1h trước'},
          {'roleTitle': 'Giám đốc Phê duyệt', 'actorName': 'Lê Hoàng (CEO)', 'status': 'pending', 'timestampText': 'Đang chờ quyết định'},
        ],
      }),
    ];
  }
}
