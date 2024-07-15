import 'package:flutter/material.dart';
import 'package:findatherapistapp/models/therapist_model.dart';
import 'package:findatherapistapp/widgets/TherapistListCard/therapist_list_card.dart';

import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../common/therapist_public_profile_screen/therapist_public_profile_screen.dart';

class TherapistResultsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> matchedTherapists;

  const TherapistResultsScreen({
    super.key,
    required this.matchedTherapists,
  });

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
        itemCount: matchedTherapists.length,
        itemBuilder: (context, index) {
          final match = matchedTherapists[index];
          final therapist = match['therapist'] as TherapistModel;
          final matchScore = match['matchScore'] as double;

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
        },
      ),
      appBarTitle: 'Matched Therapists',
      isProtected: true,
    );
  }
}
