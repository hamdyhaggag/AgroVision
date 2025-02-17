import 'package:flutter/material.dart';

import '../../core/themes/app_colors.dart';
import '../../core/themes/text_styles.dart';

class ConfidenceScoreWidget extends StatelessWidget {
  final double score;

  const ConfidenceScoreWidget({required this.score, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Confidence Score',
              style: TextStyles.bodyText,
            ),
            const Spacer(),
            Text(
              '${(score * 100).toStringAsFixed(0)}%',
              style: TextStyles.bodyText.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: score,
          backgroundColor: AppColors.greyLight,
          color: AppColors.primaryColor,
        ),
      ],
    );
  }
}
