import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/extensions/l10n_extension.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/labor_profile/presentation/cubit/labor_profile_cubit.dart';
import 'package:vstech_hrm/features/labor_profile/presentation/cubit/labor_profile_state.dart';
import 'package:vstech_hrm/features/labor_profile/presentation/widgets/contract_attachment_tile.dart';
import 'package:vstech_hrm/features/labor_profile/presentation/widgets/contract_info_card.dart';
import 'package:vstech_hrm/features/labor_profile/presentation/widgets/social_insurance_card.dart';

/// Screen presenting the full labor, contract, salary, and social insurance record.
class LaborProfileScreen extends StatefulWidget {
  const new({super.key});

  @override
  State<LaborProfileScreen> createState() => _LaborProfileScreenState();
}

class _LaborProfileScreenState extends State<LaborProfileScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<LaborProfileCubit>().loadProfile());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: colors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.laborProfileTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: colors.textPrimary,
          ),
        ),
      ),
      body: BlocBuilder<LaborProfileCubit, LaborProfileState>(
        builder: (context, state) {
          if (state.status == LaborProfileStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == LaborProfileStatus.failure || state.profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Symbols.error, size: 48, color: colors.error),
                  12.gapH,
                  Text(
                    state.errorMessage ?? l10n.errorOccurredMessage,
                    style: TextStyle(color: colors.textSecondary),
                  ),
                  16.gapH,
                  ElevatedButton(
                    onPressed: () => unawaited(context.read<LaborProfileCubit>().loadProfile()),
                    child: Text(l10n.syncRetryButton),
                  ),
                ],
              ),
            );
          }

          final profile = state.profile!;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
            children: [
              // Notice banner: HR Managed & Read-only
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Symbols.info, color: Color(0xFF2563EB), size: 18),
                    10.gapW,
                    Expanded(
                      child: Text(
                        l10n.laborProfileHrNotice,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1E40AF),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 1. Contract details
              ContractInfoCard(profile: profile),
              16.gapH,

              // 2. Agreed salary & Social insurance
              SocialInsuranceCard(profile: profile),
              16.gapH,

              // 3. Attachments section
              if (profile.attachments.isNotEmpty) ...[
                Text(
                  l10n.contractAttachmentsSection,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: colors.textPrimary,
                  ),
                ),
                10.gapH,
                ...profile.attachments.map((att) => ContractAttachmentTile(attachment: att)),
              ],
            ],
          );
        },
      ),
    );
  }
}
