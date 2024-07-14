import 'package:findatherapistapp/app_settings/app_info.dart';
import 'package:findatherapistapp/utils/admin/add_terms_as_subcategory.dart';
import 'package:findatherapistapp/utils/admin/add_therapist.dart';
import 'package:findatherapistapp/utils/admin/consolidate_terms.dart';
import 'package:findatherapistapp/utils/admin/log_all_therapists.dart';
import 'package:findatherapistapp/utils/admin/update_terms_index_from_all_therapist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:findatherapistapp/app_settings/app_general_settings.dart';
import 'package:findatherapistapp/widgets/AppScaffold/app_scaffold.dart';

import '../../../generated/l10n.dart';
import '../../../providers/providers_all.dart';
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
      appBarTitle: S.of(context).homeScreenTitle,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 38,
            ),
            Skeletonizer(
              enabled: isLoading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${S.of(context).welcomeToPrefix}${AppInfo.appName}!',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 10),
                  Text(S.of(context).exampleDescription,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        context.push(Routes.userRequestScreen.path);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 47),
                      ),
                      child: Text(S.of(context).findYourTherapistButton)),
                  const SizedBox(height: 15),
                  OutlinedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 47),
                      ),
                      child: Text(S.of(context).applyAsTherapistButton)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    ref.read(localeProvider).setLocale(const Locale('en'));
                  },
                  child: const Text(
                    '🇺🇸',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(width: 10),
                const Text('/'),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    ref.read(localeProvider).setLocale(const Locale('es'));
                  },
                  child: const Text(
                    '🇪🇸',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(width: 10),
                const Text('/'),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    ref.read(localeProvider).setLocale(const Locale('de'));
                  },
                  child: const Text(
                    '🇩🇪',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  // updateTermsIndex();

                  // consolidateTerms('cognitive-behavioral-techniques', [
                  //   'cognitive-strategies',
                  // ]);

                  //
                  // addTermsAsSubcategory('insomnia', [
                  //   'anxiety',
                  // ]);
                  logAllTherapists();

                  // family-counseling, family-dynamics, family-support, family-therapy
                },
                child: Text('Test')),
          ],
        ),
      ),
    );
  }
}
