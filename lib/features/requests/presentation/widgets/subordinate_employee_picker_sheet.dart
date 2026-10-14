import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/di/injector.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';
import 'package:vstech_hrm/features/approvals/domain/entities/managed_employee_entity.dart';
import 'package:vstech_hrm/features/approvals/domain/usecases/get_managed_employees_usecase.dart';

/// Modal bottom sheet allowing managers to select a subordinate employee or themselves.
class SubordinateEmployeePickerSheet extends StatefulWidget {
  const new({
    this.selectedEmployee,
    super.key,
  });

  final ManagedEmployeeEntity? selectedEmployee;

  static Future<ManagedEmployeeEntity?> show(
    BuildContext context, {
    ManagedEmployeeEntity? selectedEmployee,
  }) {
    return showModalBottomSheet<ManagedEmployeeEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => SubordinateEmployeePickerSheet(
        selectedEmployee: selectedEmployee,
      ),
    );
  }

  @override
  State<SubordinateEmployeePickerSheet> createState() => _SubordinateEmployeePickerSheetState();
}

class _SubordinateEmployeePickerSheetState extends State<SubordinateEmployeePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<ManagedEmployeeEntity> _allEmployees = [];
  List<ManagedEmployeeEntity> _filtered = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadEmployees());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEmployees() async {
    if (!sl.isRegistered<GetManagedEmployeesUseCase>()) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    final result = await sl<GetManagedEmployeesUseCase>()();
    if (!mounted) return;
    result.fold(
      (_) => setState(() => _isLoading = false),
      (data) {
        setState(() {
          _isLoading = false;
          _allEmployees = data;
          _filtered = data;
        });
      },
    );
  }

  void _onSearch(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = _allEmployees;
      } else {
        _filtered = _allEmployees.where((e) {
          final nameMatch = e.name.toLowerCase().contains(q);
          final codeMatch = e.code.toLowerCase().contains(q);
          final deptMatch = e.department?.toLowerCase().contains(q) ?? false;
          return nameMatch || codeMatch || deptMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      top: false,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.72,
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.selectSubordinateEmployee,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: colors.textPrimary),
                ),
                IconButton(
                  icon: const AppIcon(AppIcons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            8.gapH,
            TextField(
              controller: _searchController,
              onChanged: _onSearch,
              style: TextStyle(fontSize: 13, color: colors.textPrimary),
              decoration: InputDecoration(
                hintText: l10n.searchEmployeePlaceholder,
                hintStyle: TextStyle(fontSize: 13, color: colors.textTertiary),
                prefixIcon: const AppIcon(AppIcons.search, size: 18),
                filled: true,
                fillColor: colors.cardSecondary,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
              ),
            ),
            12.gapH,
            // Option 1: Myself
            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: widget.selectedEmployee == null
                      ? colors.pineGreen.withValues(alpha: 0.1)
                      : colors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: widget.selectedEmployee == null ? colors.pineGreen : colors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colors.accentAmber.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: AppIcon(AppIcons.profile, size: 18, color: colors.accentAmber),
                      ),
                    ),
                    12.gapW,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.overtimeTargetSelf,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: colors.textPrimary,
                            ),
                          ),
                          Text(
                            'Tạo phiếu cho tài khoản của bạn',
                            style: TextStyle(fontSize: 11, color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (widget.selectedEmployee == null)
                      Icon(Icons.check_circle, size: 20, color: colors.pineGreen),
                  ],
                ),
              ),
            ),
            10.gapH,
            Divider(height: 1, color: colors.border),
            8.gapH,
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                      ? Center(
                          child: Text(
                            l10n.noSubordinatesFound,
                            style: TextStyle(fontSize: 13, color: colors.textTertiary),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _filtered.length,
                          separatorBuilder: (_, _) => 6.gapH,
                          itemBuilder: (ctx, idx) {
                            final emp = _filtered[idx];
                            final isSelected = widget.selectedEmployee?.code == emp.code;
                            return InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => Navigator.pop(context, emp),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colors.pineGreen.withValues(alpha: 0.1)
                                      : colors.cardSecondary.withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? colors.pineGreen : colors.border,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 17,
                                      backgroundColor: colors.pineGreen.withValues(alpha: 0.15),
                                      child: Text(
                                        emp.name.isNotEmpty ? emp.name[0].toUpperCase() : 'NV',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: colors.pineGreen,
                                        ),
                                      ),
                                    ),
                                    12.gapW,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            emp.name,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: colors.textPrimary,
                                            ),
                                          ),
                                          Text(
                                            '${emp.code}${emp.department != null ? ' · ${emp.department}' : ''}',
                                            style: TextStyle(fontSize: 11, color: colors.textSecondary),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(Icons.check_circle, size: 20, color: colors.pineGreen),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
