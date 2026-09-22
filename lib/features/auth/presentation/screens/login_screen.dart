import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/session/auth_cubit.dart';
import 'package:vstech_hrm/core/session/auth_state.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/auth/presentation/widgets/face_id_login_sheet.dart';

/// Screen 02: Login Screen matching the exact reference mockup.
class LoginScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _codeController = TextEditingController(text: 'NV-04821');
  final _passwordController = TextEditingController(text: '123456');
  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    unawaited(
      context.read<AuthCubit>().login(
            username: _codeController.text.trim(),
            password: _passwordController.text.trim(),
          ),
    );
  }

  void _onFaceIdLogin() {
    unawaited(FaceIdLoginSheet.show(context));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authState = context.watch<AuthCubit>().state;
    final isLoading = authState is AuthLoading;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primaryIndigo,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Symbols.person, color: Color(0xFFFFF8EC), size: 26),
              ),
              const SizedBox(height: 20),
              Text(
                'Chào bạn trở lại',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Đăng nhập bằng mã nhân viên để xem ca làm, phép và phiếu lương.',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500, color: colors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 28),
              _buildFieldLabel('Mã nhân viên', colors),
              const SizedBox(height: 6),
              TextField(
                controller: _codeController,
                decoration: _inputDecoration(
                  prefixIcon: Icon(Symbols.badge, color: colors.textSecondary, size: 20),
                  colors: colors,
                ),
              ),
              const SizedBox(height: 16),
              _buildFieldLabel('Mật khẩu', colors),
              const SizedBox(height: 6),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: _inputDecoration(
                  prefixIcon: Icon(Symbols.lock, color: colors.textSecondary, size: 20),
                  colors: colors,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Symbols.visibility_off : Symbols.visibility, size: 20),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _rememberMe,
                          activeColor: colors.primaryIndigo,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          onChanged: (v) => setState(() => _rememberMe = v ?? false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Ghi nhớ đăng nhập', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: colors.textPrimary)),
                    ],
                  ),
                  TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng liên hệ HR để đặt lại mật khẩu')),
                    ),
                    child: Text('Quên?', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors.primaryIndigo)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accentAmber,
                    foregroundColor: const Color(0xFF1C1408),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: isLoading ? null : _onLogin,
                  child: isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Đăng nhập', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(child: Divider(color: colors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text('hoặc', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colors.textTertiary)),
                  ),
                  Expanded(child: Divider(color: colors.border)),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: isLoading ? null : _onFaceIdLogin,
                  icon: Icon(Symbols.face, color: colors.primaryIndigo, size: 20),
                  label: Text('Đăng nhập bằng Face ID', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: colors.textPrimary)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Demo nhanh:', style: TextStyle(fontSize: 11.5, color: colors.textTertiary)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => context.read<AuthCubit>().loginAsDemo(UserRole.employee),
                    child: Text('Nhân viên', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.primaryIndigo, decoration: TextDecoration.underline)),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => context.read<AuthCubit>().loginAsDemo(UserRole.manager),
                    child: Text('Quản lý', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.accentAmber, decoration: TextDecoration.underline)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Text('Cần hỗ trợ? Liên hệ HR · nội bộ 1180', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: colors.textTertiary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String text, AppColorsExtension colors) {
    return Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: colors.textSecondary));
  }

  InputDecoration _inputDecoration({required Widget prefixIcon, required AppColorsExtension colors, Widget? suffixIcon}) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colors.cardSecondary,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.primaryIndigo, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}
