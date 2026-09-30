import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';

/// Quick role selection widget for demo logins, split across 2 rows to prevent overflow.
class DemoQuickLoginSection extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${l10n.demoQuickLogin}:',
          style: TextStyle(fontSize: 11.5, color: colors.textTertiary),
        ),
        6.gapH,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => context.read<AuthCubit>().loginAsDemo(UserRole.employee),
              child: Text(
                l10n.demoEmployee,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colors.primaryIndigo,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            16.gapW,
            GestureDetector(
              onTap: () => context.read<AuthCubit>().loginAsDemo(UserRole.manager),
              child: Text(
                l10n.demoManager,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: colors.accentAmber,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
