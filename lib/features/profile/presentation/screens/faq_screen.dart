import 'package:flutter/material.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/core/widgets/app_icon.dart';

/// Dedicated FAQ screen with categorized questions and interactive dropdown answers.
class FaqScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  final _searchController = TextEditingController();
  final Set<int> _expandedIndices = <int>{0};
  int _selectedCategoryIndex = 0;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final allItems = [
      _FaqItem(id: 0, categoryId: 1, categoryName: l10n.faqCategoryAttendance, question: l10n.faqQ1, answer: l10n.faqA1),
      _FaqItem(id: 1, categoryId: 2, categoryName: l10n.faqCategoryPayroll, question: l10n.faqQ2, answer: l10n.faqA2),
      _FaqItem(id: 2, categoryId: 3, categoryName: l10n.faqCategoryRequests, question: l10n.faqQ3, answer: l10n.faqA3),
      _FaqItem(id: 3, categoryId: 4, categoryName: l10n.faqCategoryAccount, question: l10n.faqQ4, answer: l10n.faqA4),
      _FaqItem(id: 4, categoryId: 4, categoryName: l10n.faqCategoryAccount, question: l10n.faqQ5, answer: l10n.faqA5),
      _FaqItem(id: 5, categoryId: 4, categoryName: l10n.faqCategoryAccount, question: l10n.faqQ6, answer: l10n.faqA6),
    ];

    final categories = [
      l10n.faqCategoryAll,
      l10n.faqCategoryAttendance,
      l10n.faqCategoryPayroll,
      l10n.faqCategoryRequests,
      l10n.faqCategoryAccount,
    ];

    final filteredItems = allItems.where((item) {
      final matchesCategory = _selectedCategoryIndex == 0 || item.categoryId == _selectedCategoryIndex;
      final q = _searchQuery.toLowerCase();
      final matchesQuery = q.isEmpty ||
          item.question.toLowerCase().contains(q) ||
          item.answer.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const AppIcon(AppIcons.back, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.faqTitle,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
        children: [
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val.trim()),
            style: TextStyle(fontSize: 13.5, color: colors.textPrimary),
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.surface,
              hintText: l10n.faqSearchHint,
              hintStyle: TextStyle(fontSize: 13, color: colors.textTertiary),
              prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: AppIcon(AppIcons.search, size: 18, color: colors.textSecondary),
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const AppIcon(AppIcons.close, size: 16),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: colors.pineGreen, width: 1.5)),
            ),
          ),
          12.gapH,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(categories.length, (idx) {
                final isSelected = _selectedCategoryIndex == idx;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    showCheckmark: false,
                    label: Text(
                      categories[idx],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: isSelected ? Colors.white : colors.textSecondary,
                      ),
                    ),
                    backgroundColor: colors.surface,
                    selectedColor: colors.pineGreen,
                    side: BorderSide(
                      color: isSelected ? colors.pineGreen : colors.border,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    onSelected: (_) => setState(() => _selectedCategoryIndex = idx),
                  ),
                );
              }),
            ),
          ),
          16.gapH,
          if (filteredItems.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: Text(
                l10n.faqEmptySearch,
                style: TextStyle(fontSize: 13.5, color: colors.textSecondary, fontWeight: FontWeight.w600),
              ),
            )
          else
            ...filteredItems.map((item) => _buildExpandableTile(item, colors)),
        ],
      ),
    );
  }

  Widget _buildExpandableTile(_FaqItem item, AppColorsExtension colors) {
    final isExpanded = _expandedIndices.contains(item.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? colors.pineGreen.withValues(alpha: 0.4) : colors.border,
          width: isExpanded ? 1.4 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              if (isExpanded) {
                _expandedIndices.remove(item.id);
              } else {
                _expandedIndices.add(item.id);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: colors.pineGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.categoryName,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: colors.pineGreen,
                        ),
                      ),
                    ),
                    const Spacer(),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: AppIcon(
                        AppIcons.chevronDown,
                        size: 18,
                        color: isExpanded ? colors.pineGreen : colors.textTertiary,
                      ),
                    ),
                  ],
                ),
                8.gapH,
                Text(
                  item.question,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: colors.textPrimary,
                    height: 1.35,
                  ),
                ),
                AnimatedCrossFade(
                  firstChild: const SizedBox.shrink(),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.gapH,
                      Divider(height: 1, color: colors.border.withValues(alpha: 0.5)),
                      10.gapH,
                      Text(
                        item.answer,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                  crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 220),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FaqItem {
  const new({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.question,
    required this.answer,
  });

  final int id;
  final int categoryId;
  final String categoryName;
  final String question;
  final String answer;
}
