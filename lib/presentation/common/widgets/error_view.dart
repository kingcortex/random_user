import 'package:flutter/material.dart';

import 'package:random_user/core/theme/sizes.dart';
import 'package:random_user/core/theme/spacing.dart';

import '../../../core/utils/gap.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.message,
    required this.onRetry,
    this.icon = Icons.error_outline,
    this.retryLabel = 'Réessayer',
    super.key,
  });

  final String message;
  final VoidCallback onRetry;
  final IconData icon;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: Spacing.pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: Sizes.iconLg),
            Spacing.sm.verticalSpace,
            Text(message, textAlign: TextAlign.center),
            Spacing.md.verticalSpace,
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}
