import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Centralized icon names matching `assets/icons/` SVG files.
abstract final class AppIcons {
  // --- A ---
  static const String alertTriangle = 'alert-triangle';
  static const String approvals = 'approvals';
  static const String approve = 'approve';
  static const String arrowLeft = 'arrow-left';
  static const String arrowRight = 'arrow-right';
  static const String attach = 'attach';
  static const String attendance = 'attendance';
  static const String award = 'award';

  // --- B ---
  static const String back = 'back';
  static const String badgeAlert = 'badge-alert';
  static const String bell = 'bell';
  static const String bonus = 'bonus';
  static const String bookmark = 'bookmark';
  static const String briefcase = 'briefcase';
  static const String building = 'building';

  // --- C ---
  static const String calendar = 'calendar';
  static const String camera = 'camera';
  static const String check = 'check';
  static const String checkCircle = 'check-circle';
  static const String checkCircle2 = 'check-circle-2';
  static const String checkIn = 'check-in';
  static const String checkOut = 'check-out';
  static const String checklist = 'checklist';
  static const String chevronDown = 'chevron-down';
  static const String chevronLeft = 'chevron-left';
  static const String chevronRight = 'chevron-right';
  static const String clipboardCheck = 'clipboard-check';
  static const String clock = 'clock';
  static const String close = 'close';
  static const String coffee = 'coffee';
  static const String coin = 'coin';
  static const String comment = 'comment';
  static const String commission = 'commission';
  static const String copy = 'copy';
  static const String correction = 'correction';

  // --- D ---
  static const String darkMode = 'dark-mode';
  static const String dependants = 'dependants';
  static const String device = 'device';
  static const String dispute = 'dispute';
  static const String documents = 'documents';
  static const String download = 'download';

  // --- E ---
  static const String edit3 = 'edit-3';
  static const String externalLink = 'external-link';
  static const String eye = 'eye';
  static const String eyeOff = 'eye-off';

  // --- F ---
  static const String faceScan = 'face-scan';
  static const String fileCode = 'file-code';
  static const String fileText = 'file-text';
  static const String filter = 'filter';
  static const String fingerprint = 'fingerprint';

  // --- G ---
  static const String globe = 'globe';

  // --- H ---
  static const String headset = 'headset';
  static const String history = 'history';
  static const String holiday = 'holiday';
  static const String home = 'home';

  // --- I ---
  static const String idCard = 'id-card';
  static const String inbox = 'inbox';
  static const String info = 'info';
  static const String itSupport = 'it-support';

  // --- J ---
  static const String jobs = 'jobs';

  // --- L ---
  static const String language = 'language';
  static const String laptop = 'laptop';
  static const String late = 'late';
  static const String leave = 'leave';
  static const String link = 'link';
  static const String location = 'location';
  static const String locationOff = 'location-off';
  static const String lock = 'lock';
  static const String logout = 'logout';

  // --- M ---
  static const String mail = 'mail';
  static const String mapPin = 'map-pin';
  static const String mentor = 'mentor';
  static const String messageSquare = 'message-square';
  static const String more = 'more';

  // --- O ---
  static const String offline = 'offline';
  static const String onboarding = 'onboarding';
  static const String orgChart = 'org-chart';
  static const String overtime = 'overtime';

  // --- P ---
  static const String palette = 'palette';
  static const String paperclip = 'paperclip';
  static const String payroll = 'payroll';
  static const String payslip = 'payslip';
  static const String pending = 'pending';
  static const String phone = 'phone';
  static const String plus = 'plus';
  static const String profile = 'profile';

  // --- Q ---
  static const String qr = 'qr';
  static const String qrCode = 'qr-code';

  // --- R ---
  static const String refer = 'refer';
  static const String refreshCw = 'refresh-cw';
  static const String reject = 'reject';
  static const String requests = 'requests';

  // --- S ---
  static const String scan = 'scan';
  static const String scanFace = 'scan-face';
  static const String screen = 'screen';
  static const String search = 'search';
  static const String services = 'services';
  static const String settings = 'settings';
  static const String share = 'share';
  static const String shield = 'shield';
  static const String shieldAlert = 'shield-alert';
  static const String shieldCheck = 'shield-check';
  static const String shift = 'shift';
  static const String shiftSwap = 'shift-swap';
  static const String sign = 'sign';
  static const String smartphone = 'smartphone';
  static const String sparkles = 'sparkles';
  static const String star = 'star';
  static const String sync = 'sync';

  // --- T ---
  static const String tag = 'tag';
  static const String target = 'target';
  static const String trash = 'trash';

  // --- U ---
  static const String upload = 'upload';
  static const String user = 'user';
  static const String userCheck = 'user-check';
  static const String userPlus = 'user-plus';
  static const String users = 'users';

  // --- W ---
  static const String wallet = 'wallet';
  static const String warning = 'warning';
  static const String wifi = 'wifi';

  // --- X ---
  static const String x = 'x';
  static const String xCircle = 'x-circle';

  // --- Z ---
  static const String zap = 'zap';
  static const String zapOff = 'zap-off';
}

/// Unified HRM SVG Icon widget.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.name, {
    super.key,
    this.size = 24.0,
    this.color,
    this.filled = false,
  });

  final String name;
  final double size;
  final Color? color;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final folder = filled ? 'filled' : 'outline';
    final iconColor =
        color ?? IconTheme.of(context).color ?? Theme.of(context).colorScheme.onSurface;
    return SvgPicture.asset(
      'assets/icons/$folder/$name.svg',
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
    );
  }
}
