import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:findatherapistapp/models/therapist_model.dart';
import 'package:findatherapistapp/widgets/TherapistListCard/therapist_list_card.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../common/therapist_public_profile_screen/therapist_public_profile_screen.dart';

class TherapistResultsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> matchedTherapists;

  const TherapistResultsScreen({
    super.key,
    required this.matchedTherapists,
  });

  @override
  _TherapistResultsScreenState createState() => _TherapistResultsScreenState();
}

class _TherapistResultsScreenState extends State<TherapistResultsScreen> {
  final Set<int> _animatedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      centerTitle: true,
      useTopAppBar: true,
      showScreenTitleInAppBar: true,
      ignoreGlobalPadding: true,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 75, top: 10),
        physics: const ClampingScrollPhysics(),
        itemCount: widget.matchedTherapists.length,
        itemBuilder: (context, index) {
          final match = widget.matchedTherapists[index];
          final therapist = match['therapist'] as TherapistModel;
          final matchScore = match['matchScore'] as double;

          bool shouldAnimate = !_animatedIndexes.contains(index);

          // Set a threshold for how many items should have staggered animations
          const int staggeredAnimationThreshold = 6;

          return shouldAnimate
              ? (index < staggeredAnimationThreshold
                  ? FadeInUp(
                      curve: Curves.decelerate,
                      from: 10,
                      delay: Duration(milliseconds: 300 * index),
                      child: _buildTherapistCard(therapist, matchScore, index),
                      controller: (controller) {
                        controller.addStatusListener((status) {
                          if (status == AnimationStatus.completed) {
                            setState(() {
                              _animatedIndexes.add(index);
                            });
                          }
                        });
                      },
                    )
                  : FadeIn(
                      child: _buildTherapistCard(therapist, matchScore, index),
                      duration: Duration(milliseconds: 200),
                      controller: (controller) {
                        controller.addStatusListener((status) {
                          if (status == AnimationStatus.completed) {
                            setState(() {
                              _animatedIndexes.add(index);
                            });
                          }
                        });
                      },
                    ))
              : _buildTherapistCard(therapist, matchScore, index);
        },
      ),
      appBarTitle: S.of(context).matchedTherapists,
      isProtected: true,
    );
  }

  Widget _buildTherapistCard(
      TherapistModel therapist, double matchScore, int index) {
    return TherapistListCard(
      therapist: therapist,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TherapistPublicProfileScreen(therapist: therapist),
          ),
        );
      },
      matchScore: matchScore,
    );
  }
}
