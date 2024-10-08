import 'package:animate_do/animate_do.dart';
import 'package:findatherapistapp/models/general_models.dart';
import 'package:flutter/material.dart';
import 'package:findatherapistapp/models/therapist_model.dart';
import 'package:findatherapistapp/widgets/TherapistListCard/therapist_list_card.dart';

import '../../../generated/l10n.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../common/therapist_public_profile_screen/therapist_public_profile_screen.dart';

class TherapistResultsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> matchedTherapists;
  final UserRequestFilters therapistFilters;

  const TherapistResultsScreen({
    super.key,
    required this.matchedTherapists,
    required this.therapistFilters,
  });

  @override
  _TherapistResultsScreenState createState() => _TherapistResultsScreenState();
}

class _TherapistResultsScreenState extends State<TherapistResultsScreen> {
  final Set<int> _animatedIndexes = {};
  late List<Map<String, dynamic>> _filteredTherapists;

  @override
  void initState() {
    super.initState();
    _applyFilters();
  }

  void _applyFilters() {
    _filteredTherapists = widget.matchedTherapists.where((match) {
      final therapist = match['therapist'] as TherapistModel;
      final meetingType = therapist.therapistInfo.meetingType;
      final country = therapist.therapistInfo.location.country;

      bool matchesRemote = widget.therapistFilters.remote && meetingType.remote;
      bool matchesPresential =
          widget.therapistFilters.presential && meetingType.presential;
      bool matchesCountry = widget.therapistFilters.location.enabled == false
          ? true
          : (widget.therapistFilters.location.country == country);

      if (widget.therapistFilters.remote &&
          !widget.therapistFilters.presential) {
        return matchesRemote && matchesCountry;
      } else if (!widget.therapistFilters.remote &&
          widget.therapistFilters.presential) {
        return matchesPresential && matchesCountry;
      } else if (widget.therapistFilters.remote &&
          widget.therapistFilters.presential) {
        return ((matchesRemote && matchesCountry) ||
            (matchesPresential && matchesCountry));
      }

      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      centerTitle: true,
      useTopAppBar: true,
      showScreenTitleInAppBar: true,
      ignoreGlobalPadding: true,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      body: _filteredTherapists.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.search_off,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.of(context).noTherapistsFound,
                      style: const TextStyle(fontSize: 22, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      S.of(context).noTherapistsFoundDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'match %',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black.withOpacity(0.7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 75, top: 2),
                    physics: const ClampingScrollPhysics(),
                    itemCount: _filteredTherapists.length,
                    itemBuilder: (context, index) {
                      final match = _filteredTherapists[index];
                      final therapist = match['therapist'] as TherapistModel;
                      final matchScore = match['matchScore'] as double;

                      bool shouldAnimate = !_animatedIndexes.contains(index);

                      // Set a threshold for how many items should have staggered animations
                      const int staggeredAnimationThreshold = 6;

                      if (matchScore < 0.5) {
                        return Container();
                      }

                      return shouldAnimate
                          ? (index < staggeredAnimationThreshold
                              ? FadeInUp(
                                  curve: Curves.decelerate,
                                  from: 10,
                                  delay: Duration(milliseconds: 300 * index),
                                  child: _buildTherapistCard(
                                      therapist, matchScore, index),
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
                                  duration: const Duration(milliseconds: 200),
                                  controller: (controller) {
                                    controller.addStatusListener((status) {
                                      if (status == AnimationStatus.completed) {
                                        setState(() {
                                          _animatedIndexes.add(index);
                                        });
                                      }
                                    });
                                  },
                                  child: _buildTherapistCard(
                                      therapist, matchScore, index),
                                ))
                          : _buildTherapistCard(therapist, matchScore, index);
                    },
                  ),
                ),
              ],
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
