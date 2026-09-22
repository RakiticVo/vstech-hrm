import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_empty_state.dart';
import 'package:vstech_hrm/core/widgets/app_error_state.dart';
import 'package:vstech_hrm/core/widgets/app_shimmer.dart';
import 'package:vstech_hrm/core/widgets/app_success_dialog.dart';

/// Screen showcasing the 4 core design states: Empty, Shimmer, Error, Success.
class StateShowcaseScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<StateShowcaseScreen> createState() => _StateShowcaseScreenState();
}

class _StateShowcaseScreenState extends State<StateShowcaseScreen> {
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    const tabs = ['Rỗng', 'Đang tải (Shimmer)', 'Lỗi', 'Thành công'];

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Minh họa 4 Trạng thái',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(44),
          child: SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: tabs.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (ctx, index) {
                final isSel = _activeTab == index;
                return ChoiceChip(
                  label: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSel ? const Color(0xFFFFF8EC) : colors.textSecondary,
                    ),
                  ),
                  selected: isSel,
                  selectedColor: colors.primaryIndigo,
                  backgroundColor: colors.cardSecondary,
                  onSelected: (_) => setState(() => _activeTab = index),
                );
              },
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _activeTab,
        children: [
          // 0: Empty
          AppEmptyState(
            title: 'Chưa có yêu cầu nào',
            message: 'Danh sách đơn từ của bạn hiện đang trống. Hãy tạo đơn mới khi cần xin nghỉ phép hoặc sửa công.',
            actionLabel: 'Tạo đơn mới',
            onAction: () {},
          ),
          // 1: Shimmer
          ListView(
            padding: const EdgeInsets.all(16),
            children: const [
              AppShimmerCard(),
              SizedBox(height: 12),
              AppShimmerCard(),
              SizedBox(height: 12),
              AppShimmerCard(),
            ],
          ),
          // 2: Error
          AppErrorState(
            title: 'Lỗi tải dữ liệu ca làm',
            message: 'Hệ thống không thể kết nối tới máy chủ. Vui lòng kiểm tra lại mạng Wi-Fi/4G của bạn.',
            onRetry: () {},
          ),
          // 3: Success
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppSuccessDialog(
                    title: 'Gửi yêu cầu thành công!',
                    message: 'Yêu cầu nghỉ phép đã được chuyển tới quản lý Trần Văn Nam để phê duyệt.',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      unawaited(
                        AppSuccessDialog.show(
                          context,
                          title: 'Chấm công thành công!',
                          message: 'Đã ghi nhận giờ vào làm 08:24 tại Văn phòng HCM.',
                        ),
                      );
                    },
                    child: const Text('Bấm mở Dialog Thành công'),
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
