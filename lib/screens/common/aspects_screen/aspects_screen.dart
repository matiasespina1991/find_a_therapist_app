import 'package:findatherapistapp/models/therapist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../generated/l10n.dart';
import '../../../utils/admin/find_best_therapist_by_aspects.dart';
import '../../../utils/ui/is_dark_mode.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../../widgets/AspectSection/aspect_section.dart';
import '../../../widgets/LoadingCircle/loading_circle.dart';
import '../../user_area/therapist_result_screen/therapist_result_screen.dart';

class AspectsScreen extends ConsumerStatefulWidget {
  final Aspects aspects;
  const AspectsScreen({required this.aspects, super.key});

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
        final _matchedTherapists = await findBestTherapist(widget.aspects);
        setState(() {
          matchedTherapists = _matchedTherapists;
          _searchingForTherapists = false;
          _therapistsSearchDone = true;
        });
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TherapistResultsScreen(matchedTherapists: matchedTherapists),
        ),
      );
    } catch (e) {
      print('Error when trying to search for a therapist: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      useTopAppBar: true,
      appBarTitle: 'Aspects detected by AI:',
      isProtected: true,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  fixedSize: Size(170, 40),
                ),
                onPressed: () => context.pop(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(S.of(context).redoRequestButton),
                    SizedBox(width: 8),
                    Icon(
                      Icons.refresh_outlined,
                      size: 16,
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  ElevatedButton(
                      onPressed: _searchingForTherapists
                          ? null
                          : _pressedFindATherapist,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Visibility(
                                visible: (_searchingForTherapists ||
                                        _therapistsSearchDone)
                                    ? false
                                    : true,
                                maintainState: true,
                                maintainAnimation: true,
                                maintainSize: true,
                                maintainSemantics: true,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(S.of(context).findMyTherapistButton),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.send_outlined,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if (_therapistsSearchDone)
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(S.of(context).seeResultsButton),
                                    SizedBox(width: 8),
                                    Icon(
                                      Icons.send_outlined,
                                      size: 16,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          if (_searchingForTherapists)
                            Center(
                              child: Container(
                                width: 30,
                                height: 30,
                                child: LoadingCircle(
                                  color: isDarkMode(context)
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ),
                        ],
                      )),
                ],
              ),
            ],
          ),
          Divider(),
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
