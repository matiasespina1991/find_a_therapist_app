import 'package:findatherapistapp/models/general_models.dart';
import 'package:findatherapistapp/models/therapist_model.dart';
import 'package:findatherapistapp/widgets/NotificationModal/notification_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../generated/l10n.dart';
import '../../../utils/admin/find_best_therapist_by_aspects.dart';

import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../../widgets/AspectSection/aspect_section.dart';
import '../../../widgets/LoadingCircle/loading_circle.dart';
import '../../user_area/therapist_result_screen/therapist_result_screen.dart';

class AspectsScreen extends ConsumerStatefulWidget {
  final Aspects aspects;
  final UserRequestFilters therapistFilters;
  const AspectsScreen(
      {required this.therapistFilters, required this.aspects, super.key});

  @override
  ConsumerState<AspectsScreen> createState() => _AspectsScreenState();
}

class _AspectsScreenState extends ConsumerState<AspectsScreen> {
  bool _searchingForTherapists = false;
  bool _therapistsSearchDone = false;
  List<Map<String, dynamic>> matchedTherapists = [];

  void _pressedFindATherapist() async {
    try {
      if (!_therapistsSearchDone) {
        setState(() {
          _searchingForTherapists = true;
        });
        final _matchedTherapists = await findBestTherapistByAspects(
            userAspects: widget.aspects,
            therapistFilters: widget.therapistFilters);

        if (_matchedTherapists.isEmpty) {
          setState(() {
            matchedTherapists = _matchedTherapists;
            _searchingForTherapists = false;
            _therapistsSearchDone = false;
          });
          if (mounted) {
            NotificationModal.errorModal(
                context: context,
                title: 'No therapists found',
                message:
                    'We are sorry, we could not find any therapists that match your needs',
                onTapConfirm: () {});
          }

          return;
        }
        setState(() {
          matchedTherapists = _matchedTherapists;
          _searchingForTherapists = false;
          _therapistsSearchDone = true;
        });
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TherapistResultsScreen(
                matchedTherapists: matchedTherapists,
                therapistFilters: widget.therapistFilters),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error when trying to search for a therapist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppScaffold(
      setFloatingSpeedDialToLoadingMode: _searchingForTherapists,
      scrollPhysics: const ClampingScrollPhysics(),
      useTopAppBar: true,
      appBarTitle: S.of(context).aspectsDetectedByAi,
      isProtected: true,
      body: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          S.of(context).redoRequestButton,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.refresh_outlined,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10), // Add some space between the buttons
              Expanded(
                child: Stack(
                  children: [
                    ElevatedButton(
                      onPressed: _searchingForTherapists
                          ? null
                          : _pressedFindATherapist,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 0),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Visibility(
                            visible: !_therapistsSearchDone,
                            maintainState: true,
                            maintainAnimation: true,
                            maintainSize: true,
                            maintainSemantics: true,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_searchingForTherapists)
                                  Flexible(
                                    child: Text(
                                      S.of(context).findingMatches,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                if (!_searchingForTherapists)
                                  Flexible(
                                    child: Text(
                                      S.of(context).findMyTherapistButton,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.send_outlined,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                          if (_therapistsSearchDone)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(S.of(context).seeResultsButton),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.send_outlined,
                                  size: 16,
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            height: 70,
          ),
          Center(
              child: AspectSection(
            positiveAspects: widget.aspects.positive,
            negativeAspects: widget.aspects.negative,
          )),
        ],
      ),
    );
  }
}
