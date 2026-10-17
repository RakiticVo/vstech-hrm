import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/theme/tile_pattern_painter.dart';
import 'package:vstech_hrm/core/widgets/app_logo.dart';

/// Splash screen checking initial authentication and session status.
///
/// Styled strictly after Option 1a in `docs/ui/VStech Logo Screen.dc.html`:
/// deep teal Saigon tile backdrop (#0A544E), cream brand logo, smooth amber
/// progress bar matching keyframe `vs-load`, and tabular version caption.
class SplashScreen extends StatefulWidget {
  const new({
    this.splashDuration = const Duration(milliseconds: 2500),
    super.key,
  });

  /// Duration to hold the splash screen before checking auth and transitioning.
  final Duration splashDuration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _splashTimer;

  late final AnimationController _popController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..forward();

  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 0.92,
    end: 1,
  ).animate(
    CurvedAnimation(parent: _popController, curve: Curves.easeOut),
  );

  late final Animation<double> _fadeAnimation = CurvedAnimation(
    parent: _popController,
    curve: Curves.easeOut,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _splashTimer = Timer(widget.splashDuration, () {
        if (!mounted) return;
        unawaited(context.read<AuthCubit>().checkAuthStatus());
      });
    });
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    _popController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: const Color(0xFF0A544E),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: TilePatternPainter(
                backgroundColor: const Color(0xFF0A544E),
                patternColor: const Color(0xFFFFF8EC).withValues(alpha: 0.19),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  const Spacer(),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: AppLogo.cream(
                        width: context.w(250),
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(34)),
                  _SplashLoadingBar(
                    width: context.w(96),
                    barColor: colors.accentAmber,
                    trackColor: const Color(0xFFFFF8EC).withValues(alpha: 0.28),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(bottom: context.h(40)),
                    child: Text(
                      context.l10n.splashVersionText,
                      style: AppTextStyles.tabular(
                        AppTextStyles.caption.copyWith(
                          color:
                              const Color(0xFFFFF8EC).withValues(alpha: 0.78),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Indeterminate horizontal loading bar styled after CSS keyframe `vs-load`.
class _SplashLoadingBar extends StatefulWidget {
  const new({
    required this.width,
    required this.barColor,
    required this.trackColor,
  });

  final double width;
  final Color barColor;
  final Color trackColor;

  @override
  State<_SplashLoadingBar> createState() => _SplashLoadingBarState();
}

class _SplashLoadingBarState extends State<_SplashLoadingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barWidth = widget.width * 0.44;
    final totalTravel = widget.width + barWidth;

    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        width: widget.width,
        height: 3,
        color: widget.trackColor,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final offset = -barWidth + (totalTravel * _controller.value);
            return Stack(
              children: [
                Positioned(
                  left: offset,
                  width: barWidth,
                  top: 0,
                  bottom: 0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: widget.barColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
