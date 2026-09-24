import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vstech_hrm/core/responsive/app_layout.dart';
import 'package:vstech_hrm/core/theme/app_colors.dart';
import 'package:vstech_hrm/features/executive/domain/entities/final_approval_entity.dart';

class FinalApprovalChainTimeline extends StatelessWidget {
  const new({
    required this.approvalChain,
    super.key,
  });

  final List<ApprovalChainStep> approvalChain;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        for (var i = 0; i < approvalChain.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: approvalChain[i].status == ApprovalStepStatus.done
                          ? const Color(0xFF16A34A)
                          : colors.accentAmber,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      approvalChain[i].status == ApprovalStepStatus.done
                          ? Symbols.check
                          : Symbols.schedule,
                      size: 11,
                      color: Colors.white,
                    ),
                  ),
                  if (i < approvalChain.length - 1)
                    Container(
                      width: 2,
                      height: 20,
                      color: colors.border,
                    ),
                ],
              ),
              10.gapW,
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${approvalChain[i].roleTitle}: ${approvalChain[i].actorName}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: colors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        approvalChain[i].timestampText,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: colors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
