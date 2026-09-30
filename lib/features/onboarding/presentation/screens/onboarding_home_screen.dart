import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/router/routes.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/features/onboarding/presentation/widgets/onboarding_checklist_tile.dart';
import 'package:vstech_hrm/features/onboarding/presentation/widgets/onboarding_hero_banner.dart';

/// Screen 1 / OB-Home: Central Onboarding Dashboard for new hires.
class OnboardingHomeScreen extends StatelessWidget {
  const OnboardingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final steps = const [
      OnboardingStepItem(
        stepNumber: 1,
        title: 'Xem & Chấp thuận Thư mời nhận việc',
        description: 'Xác nhận mức lương, chế độ phúc lợi và ngày nhận việc',
        icon: AppIcons.mail,
        route: AppRoutes.onboardingOffer,
        status: OnboardingStepStatus.completed,
      ),
      OnboardingStepItem(
        stepNumber: 2,
        title: 'Đội ngũ & Người hướng dẫn (Buddy)',
        description: 'Làm quen với người đồng hành và sơ đồ tổ chức phòng ban',
        icon: AppIcons.users,
        route: AppRoutes.onboardingOrg,
        status: OnboardingStepStatus.completed,
      ),
      OnboardingStepItem(
        stepNumber: 3,
        title: 'Nộp hồ sơ nhân sự đầu vào',
        description: 'Tải lên CCCD, Sơ yếu lý lịch, Giấy khám sức khỏe',
        icon: AppIcons.upload,
        route: AppRoutes.onboardingDocs,
        status: OnboardingStepStatus.inProgress,
      ),
      OnboardingStepItem(
        stepNumber: 4,
        title: 'Chụp ảnh thẻ nhân viên 3x4',
        description: 'Chụp ảnh chân dung làm thẻ ra vào và tài khoản nội bộ',
        icon: AppIcons.camera,
        route: AppRoutes.onboardingCapture,
        status: OnboardingStepStatus.notStarted,
      ),
      OnboardingStepItem(
        stepNumber: 5,
        title: 'Xác thực danh tính (OCR CCCD)',
        description: 'Quét căn cước công dân gắn chip để đối soát tự động',
        icon: AppIcons.badgeAlert,
        route: AppRoutes.onboardingOcr,
        status: OnboardingStepStatus.notStarted,
      ),
      OnboardingStepItem(
        stepNumber: 6,
        title: 'Ký hợp đồng thử việc điện tử',
        description: 'Ký trực tuyến với mã xác thực OTP bảo mật cao',
        icon: AppIcons.edit3,
        route: AppRoutes.onboardingSign,
        status: OnboardingStepStatus.notStarted,
      ),
      OnboardingStepItem(
        stepNumber: 7,
        title: 'Cẩm nang Ngày đầu tiên đi làm',
        description: 'Thời gian, địa điểm, trang phục và người đón tiếp',
        icon: AppIcons.fileText,
        route: AppRoutes.onboardingDayOne,
        status: OnboardingStepStatus.notStarted,
      ),
    ];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        title: Text(
          l10n.onboardingHomeTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const OnboardingHeroBanner(
            candidateName: 'Nguyễn Minh Tuấn',
            position: 'Giám sát cửa hàng (Vận hành)',
            daysLeft: 3,
            startDate: '01/10/2026',
            completedSteps: 2,
            totalSteps: 7,
          ),
          20.gapH,
          Text(
            'Các bước chuẩn bị trước ngày đi làm',
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: colors.textPrimary),
          ),
          12.gapH,
          ...steps.map(
            (step) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: OnboardingChecklistTile(
                item: step,
                onTap: () => context.push(step.route),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: PrimaryButton(
            text: l10n.startNextStepBtn,
            iconName: AppIcons.arrowRight,
            onPressed: () => context.push(AppRoutes.onboardingDocs),
          ),
        ),
      ),
    );
  }
}
