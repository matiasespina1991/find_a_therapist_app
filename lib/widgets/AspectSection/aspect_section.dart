import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../utils/ui/is_dark_mode.dart';

class AspectSection extends StatelessWidget {
  final List<String> positiveAspects;
  final List<String> negativeAspects;

  const AspectSection({
    Key? key,
    required this.positiveAspects,
    required this.negativeAspects,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Positive aspects
        _buildAspectTitle(context, S.of(context).positiveAspectsTitle),
        const SizedBox(height: 4),
        Text(
          '(${S.of(context).positiveAspectsDescription})',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 11.0),
        _buildAspectChips(context, positiveAspects, Colors.green),

        const Divider(
          height: 70,
        ),
        // Negative aspects
        _buildAspectTitle(context, S.of(context).negativeAspectsTitle),
        const SizedBox(height: 4),
        Text(
          '(${S.of(context).negativeAspectsDescription})',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 11.0),
        _buildAspectChips(context, negativeAspects, Colors.red),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildAspectTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildAspectChips(
      BuildContext context, List<String> aspects, Color chipColor) {
    final bool _isDarkMode = isDarkMode(context);
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: aspects.isNotEmpty
          ? aspects
              .map((aspect) => Chip(
                    side: BorderSide(
                        color: _isDarkMode ? chipColor : Colors.black12,
                        width: 1.0),
                    label: Text(aspect,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: _isDarkMode ? chipColor : Colors.white,
                            )),
                    backgroundColor:
                        _isDarkMode ? Colors.transparent : chipColor,
                  ))
              .toList()
          : [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 13.0),
                child: Text(S.of(context).notFound,
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
    );
  }
}
