import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../generated/l10n.dart';
import '../../models/therapist_model.dart';
import '../../providers/providers_all.dart';

class AspectSection extends ConsumerWidget {
  final List<Term> positiveAspects;
  final List<Term> negativeAspects;

  const AspectSection({
    super.key,
    required this.positiveAspects,
    required this.negativeAspects,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        _buildAspectChips(context, positiveAspects, Colors.green, ref),

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
        _buildAspectChips(context, negativeAspects, Colors.red, ref),
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

  Widget _buildAspectChips(BuildContext context, List<Term> aspects,
      Color chipColor, WidgetRef ref) {
    final bool isDarkMode =
        ref.watch(themeProvider).themeMode == ThemeMode.dark;
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: aspects.isNotEmpty
          ? aspects
              .map((aspect) => Chip(
                    side: BorderSide(
                        color: isDarkMode ? chipColor : Colors.black12,
                        width: 1.0),
                    label: Text(aspect.term,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: isDarkMode ? chipColor : Colors.white,
                            )),
                    backgroundColor:
                        isDarkMode ? Colors.transparent : chipColor,
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
