import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/app_settings/app_info.dart';
import 'package:findatherapistapp/utils/admin/add_therapists_in_batch.dart';
import 'package:findatherapistapp/utils/admin/consolidate_terms.dart';
import 'package:findatherapistapp/utils/admin/update_terms_index_from_all_therapist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:findatherapistapp/app_settings/app_general_settings.dart';
import 'package:findatherapistapp/widgets/AppScaffold/app_scaffold.dart';

import '../../../generated/l10n.dart';
import '../../../models/therapist_model.dart';
import '../../../routes/routes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool useAppBar = AppGeneralSettings.useTopAppBar;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  bool exampleSwitchValue = false;
  static const bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isProtected: true,
      ignoreGlobalPadding: true,
      appBarTitle: S.of(context).homeScreenTitle,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 60,
            ),
            Lottie.asset(
              'lib/assets/lottie_animations/animation2.json',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 210,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: Skeletonizer(
                enabled: isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${S.of(context).welcomeToPrefix}${AppInfo.appName}!',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 10),
                    Text(
                        'The platform for finding the right therapist for you.',
                        style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () {
                          context.push(Routes.userRequestScreen.path);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 47),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(S.of(context).findYourTherapistButton),
                          ],
                        )),
                    const SizedBox(height: 15),
                    OutlinedButton(
                        onPressed: () {
                          consolidateTerms(
                              'pet-therapy', ['pet-driven-therapy']);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 47),
                        ),
                        child: Text(S.of(context).applyAsTherapistButton)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
