import 'package:vstech_hrm/features/announcements/data/models/announcement_model.dart';
import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';

/// Abstract contract for announcement remote/mock data source.
abstract class AnnouncementDataSource {
  Future<List<AnnouncementModel>> getAnnouncements({AnnouncementScope? scope});
  Future<AnnouncementModel> getAnnouncementDetail(String id);
  Future<void> markAsRead(String id);
}

/// Standalone mock implementation with realistic Vietnamese factory announcements.
class AnnouncementMockDataSource implements AnnouncementDataSource {
  final Set<String> _readIds = {'ann_03', 'ann_05'};

  late final List<Map<String, dynamic>> _fixtures = [
    {
      'id': 'ann_01',
      'title': 'Kế hoạch bảo dưỡng máy móc định kỳ Phân xưởng 1 & 2 tháng 10/2026',
      'content':
          'Kính gửi toàn thể Cán bộ công nhân viên Phân xưởng 1 và Phân xưởng 2,\n\n'
          'Nhằm đảm bảo an toàn vận hành và duy trì năng suất dây chuyền sản xuất tự động, '
          'Bộ phận Kỹ thuật & Bảo trì sẽ tiến hành công tác bảo dưỡng tổng thể theo lịch trình sau:\n\n'
          '1. Thời gian: Từ 20:00 Thứ Bảy (10/10/2026) đến 06:00 Chủ Nhật (11/10/2026).\n'
          '2. Phạm vi: Dây chuyền dập kim loại, hệ thống ép nhiệt và máy nén khí trung tâm.\n'
          '3. Yêu cầu phối hợp:\n'
          '   - Các tổ trưởng bàn giao mặt bằng xưởng sạch sẽ trước 19:30 ngày 10/10.\n'
          '   - Toàn bộ công nhân ca 3 tạm nghỉ và sẽ được bố trí làm bù hoặc hưởng 100% lương ngừng việc theo quy định.\n'
          '   - Đội kỹ thuật trực bảo dưỡng phải tuân thủ nghiêm ngặt quy trình khóa cách ly nguồn năng lượng (LOTO).\n\n'
          'Mọi thắc mắc vui lòng liên hệ Kỹ sư trưởng xưởng: Đỗ Anh Tuấn (Ext: 204).',
      'publishedAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'authorName': 'Phòng Quản Lý Sản Xuất & Bảo Trì',
      'authorRole': 'HR/Admin',
      'scope': 'factory',
      'summary': 'Kế hoạch tạm dừng máy bảo dưỡng định kỳ ca đêm 10/10 tại Phân xưởng 1 & 2.',
    },
    {
      'id': 'ann_02',
      'title': 'Phát động Chiến dịch 5S và An toàn vệ sinh lao động toàn nhà máy',
      'content':
          'Thưa toàn thể Anh Chị Em công nhân viên VSTech,\n\n'
          'Ban Giám Đốc phối hợp cùng Ban Chấp Hành Công Đoàn chính thức phát động phong trào '
          '"Nhà máy Xanh - Sạch - An toàn - Năng suất vượt bậc" quý 4/2026.\n\n'
          'Nội dung chính:\n'
          '• Sàng lọc (Seiri): Phân loại và thu hồi các vật tư, khuôn mẫu không dùng trong vòng 30 ngày.\n'
          '• Sắp xếp (Seiton): Đặt biển báo mã màu cho từng vị trí để pallet và dụng cụ thao tác.\n'
          '• Sạch sẽ (Seiso): Dành 15 phút cuối mỗi ca làm việc để tổng vệ sinh máy và lối thoát hiểm.\n'
          '• Săn sóc & Sẵn sàng (Seiketsu & Shitsuke): Đánh giá chấm điểm thi đua hàng tuần giữa 12 tổ sản xuất.\n\n'
          'Cơ cấu giải thưởng:\n'
          '- 01 Giải Nhất Tổ Xuất Sắc: 5.000.000 ₫ + Cờ thi đua tháng.\n'
          '- 02 Giải Nhì: 3.000.000 ₫/giải.\n'
          '- Thưởng nóng 500.000 ₫ cho cá nhân có sáng kiến cải tiến giảm thiểu nguy cơ tai nạn lao động.',
      'publishedAt': DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
      'authorName': 'Ban Giám Đốc & Phòng Nhân Sự',
      'authorRole': 'HR/Admin',
      'scope': 'company',
      'summary': 'Thi đua 5S quý 4 toàn nhà máy với tổng giải thưởng lên đến 20 triệu đồng.',
    },
    {
      'id': 'ann_03',
      'title': 'Lịch khám sức khỏe định kỳ năm 2026 cho 3.000 cán bộ công nhân viên',
      'content':
          'Phòng Nhân sự thông báo kế hoạch tổ chức khám sức khỏe tổng quát định kỳ năm 2026 '
          'hợp tác cùng Bệnh viện Đa khoa Quốc tế:\n\n'
          '• Địa điểm: Trạm Y tế Nhà máy (Tầng 1, Nhà điều hành).\n'
          '• Thời gian: Từ ngày 15/10/2026 đến hết ngày 25/10/2026.\n'
          '• Danh mục khám: Khám lâm sàng tổng quát, X-quang phổi kỹ thuật số, xét nghiệm máu, '
          'đo thính lực cho công nhân môi trường tiếng ồn cao.\n\n'
          'Lưu ý: Công nhân ca sáng khám từ 07:30 đến 10:00 (nhịn ăn sáng để lấy máu xét nghiệm). '
          'Bệnh viện và công ty có phục vụ suất ăn nhẹ miễn phí ngay sau khi hoàn thành lấy mẫu máu.',
      'publishedAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'authorName': 'Phòng Y Tế & Chăm Sóc Sức Khỏe',
      'authorRole': 'HR/Admin',
      'scope': 'company',
      'summary': 'Tổ chức khám sức khỏe định kỳ từ 15–25/10/2026 tại Trạm Y tế Nhà máy.',
    },
    {
      'id': 'ann_04',
      'title': 'Quy định chấm công và quản lý điện thoại cá nhân trong khu vực sản xuất',
      'content':
          'Nhằm tuân thủ tiêu chuẩn chất lượng xuất khẩu và bảo mật dây chuyền công nghệ cao:\n\n'
          '1. Toàn bộ công nhân viên tuyệt đối cất điện thoại cá nhân tại tủ Locker cá nhân trước giờ vào ca.\n'
          '2. Điểm danh chấm công GPS / Khuôn mặt phải hoàn tất trước giờ kẻ vạch vào xưởng.\n'
          '3. Ứng dụng di động VSTech HRM đã trang bị tính năng "Nhắc nhở ca kíp & Giờ ăn trưa" '
          'để công nhân chủ động thời gian sinh hoạt mà không cần cầm điện thoại vào nơi sản xuất.\n'
          '4. Các trường hợp gia đình có việc khẩn cấp, người thân có thể gọi thẳng Tổng đài trực ban Nhà máy: '
          '028 3812 8888 (máy lẻ 101) để phòng bảo vệ báo trực tiếp xuống chuyền.',
      'publishedAt': DateTime.now().subtract(const Duration(days: 4)).toIso8601String(),
      'authorName': 'Ban An Ninh & Phòng Nhân Sự',
      'authorRole': 'HR/Admin',
      'scope': 'factory',
      'summary': 'Quy định gửi điện thoại tại tủ locker và kênh liên lạc khẩn cấp qua tổng đài.',
    },
    {
      'id': 'ann_05',
      'title': 'Chương trình đào tạo kỹ năng quản lý hiện trường dành cho Tổ trưởng',
      'content':
          'Phòng Nhân sự và Ban Đào tạo trân trọng thông báo khóa tập huấn chuyên sâu:\n\n'
          '• Chuyên đề: "Kỹ năng điều phối ca làm việc và giải quyết tranh chấp hiện trường".\n'
          '• Đối tượng: Toàn bộ Tổ trưởng, Giám sát chuyền may và Quản lý ca.\n'
          '• Thời lượng: 02 buổi (Thứ Bảy ngày 17/10 và 24/10/2026).\n'
          '• Địa điểm: Hội trường Lầu 3 - Nhà Văn phòng VSTech.\n\n'
          'Học viên tham gia đầy đủ được cấp chứng chỉ nội bộ và tính ngày công đào tạo hưởng nguyên lương.',
      'publishedAt': DateTime.now().subtract(const Duration(days: 6)).toIso8601String(),
      'authorName': 'Trung Tâm Đào Tạo Nguồn Nhân Lực',
      'authorRole': 'HR/Admin',
      'scope': 'office',
      'summary': 'Tập huấn kỹ năng quản lý hiện trường cho Tổ trưởng & Giám sát ca.',
    },
  ];

  @override
  Future<List<AnnouncementModel>> getAnnouncements({AnnouncementScope? scope}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final list = _fixtures.map((m) {
      final id = m['id'] as String;
      final isRead = _readIds.contains(id);
      return AnnouncementModel.fromJson({...m, 'isRead': isRead});
    }).toList();

    if (scope == null || scope == AnnouncementScope.all) {
      return list;
    }
    return list.where((item) => item.scope == scope).toList();
  }

  @override
  Future<AnnouncementModel> getAnnouncementDetail(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final match = _fixtures.firstWhere(
      (m) => m['id'] == id,
      orElse: () => _fixtures.first,
    );
    _readIds.add(id);
    return AnnouncementModel.fromJson({...match, 'isRead': true});
  }

  @override
  Future<void> markAsRead(String id) async {
    _readIds.add(id);
  }
}
