import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/theme/app_text_styles.dart';
import 'package:vstech_hrm/core/widgets/amber_cta_button.dart';
import 'package:vstech_hrm/core/widgets/app_card.dart';
import 'package:vstech_hrm/core/widgets/primary_button.dart';
import 'package:vstech_hrm/core/widgets/secondary_button.dart';
import 'package:vstech_hrm/core/widgets/tile_header_banner.dart';

/// Login Screen supporting regular credentials and 1-tap Demo role switching.
class LoginScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController(text: 'employee01');
  final _passwordController = TextEditingController(text: '123456');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    unawaited(
      context.read<AuthCubit>().login(
            username: _usernameController.text.trim(),
            password: _passwordController.text.trim(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authState = context.watch<AuthCubit>().state;
    final isLoading = authState is AuthLoading;

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TileHeaderBanner(
              title: 'VSTech HRM',
              subtitle: 'Hệ thống Quản trị Nhân sự thế hệ mới',
              height: 160,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đăng nhập tài khoản',
                          style: AppTextStyles.titleMedium(color: colors.textPrimary)
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _usernameController,
                          label: 'Tên đăng nhập / Mã NV',
                          icon: Symbols.person,
                          colors: colors,
                        ),
                        const SizedBox(height: 14),
                        _buildPasswordField(colors),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          text: 'Đăng nhập',
                          isLoading: isLoading,
                          onPressed: _onLogin,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDemoSection(isLoading, colors),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required AppColorsExtension colors,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: colors.textTertiary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
      ),
    );
  }

  Widget _buildPasswordField(AppColorsExtension colors) {
    return TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Mật khẩu',
        prefixIcon: Icon(Symbols.lock, size: 20, color: colors.textTertiary),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Symbols.visibility_off : Symbols.visibility,
            size: 20,
            color: colors.textTertiary,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.border),
        ),
      ),
    );
  }

  Widget _buildDemoSection(bool isLoading, AppColorsExtension colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.cardSecondary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Symbols.smart_toy, size: 18, color: colors.accentAmber),
              const SizedBox(width: 8),
              Text(
                'Chế độ Demo (Standalone Mock)',
                style: AppTextStyles.labelMedium(color: colors.textPrimary).copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AmberCtaButton(
            text: 'Vào vai: Nhân viên (NV / ESS)',
            icon: Symbols.badge,
            isLoading: isLoading,
            onPressed: () => unawaited(
              context.read<AuthCubit>().loginAsDemo(UserRole.employee),
            ),
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            text: 'Vào vai: Quản lý (QL / MSS)',
            icon: Symbols.supervisor_account,
            onPressed: isLoading
                ? null
                : () => unawaited(
                      context.read<AuthCubit>().loginAsDemo(UserRole.manager),
                    ),
          ),
        ],
      ),
    );
  }
}
