import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.trailing,
    this.padding = const EdgeInsets.all(16),
    this.titleSpacing = 12,
  });

  final String title;
  final Widget child;
  final Widget? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final double titleSpacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitleBase =
        theme.textTheme.bodySmall ?? theme.textTheme.bodyMedium;
    final subtitleStyle = subtitleBase?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            if (subtitle != null && subtitleStyle != null) ...[
              SizedBox(height: titleSpacing / 2),
              DefaultTextStyle(style: subtitleStyle, child: subtitle!),
            ] else if (subtitle != null) ...[
              SizedBox(height: titleSpacing / 2),
              subtitle!,
            ],
            SizedBox(height: titleSpacing),
            child,
          ],
        ),
      ),
    );
  }
}
