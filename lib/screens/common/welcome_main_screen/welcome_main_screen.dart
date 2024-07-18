import 'package:animate_do/animate_do.dart';
import 'package:findatherapistapp/app_settings/app_info.dart';
import 'package:findatherapistapp/utils/admin/update_all_therapists_aspects.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:findatherapistapp/app_settings/app_general_settings.dart';
import 'package:findatherapistapp/widgets/AppScaffold/app_scaffold.dart';

import '../../../generated/l10n.dart';
import '../../../routes/routes.dart';

class WelcomeMainScreen extends ConsumerStatefulWidget {
  const WelcomeMainScreen({super.key});

  @override
  ConsumerState<WelcomeMainScreen> createState() => _WelcomeMainScreenState();
}

class _WelcomeMainScreenState extends ConsumerState<WelcomeMainScreen> {
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
              height: 48,
            ),
            FadeInUp(
              from: 20,
              curve: Curves.decelerate,
              delay: const Duration(milliseconds: 2500),
              duration: const Duration(milliseconds: 900),
              child: Lottie.asset(
                'lib/assets/lottie_animations/animation2.json',
                width: double.infinity,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 194,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: Skeletonizer(
                enabled: isLoading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 1000),
                      delay: const Duration(milliseconds: 2000),
                      from: 10,
                      child: Column(
                        children: [
                          Text(
                              '${S.of(context).welcomeToPrefix}${AppInfo.appName}!',
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 10),
                          Text(S.of(context).welcomeScreenSubtitleDescription,
                              style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(height: 13),
                    FadeInUp(
                      curve: Curves.decelerate,
                      duration: const Duration(milliseconds: 1000),
                      from: 20,
                      child: Column(
                        children: [
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
                                context
                                    .push(Routes.therapistProfileScreen.path);
                                // updateALLTherapistAspects();
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 47),
                              ),
                              child: Text(
                                  S.of(context).registerAsTherapistButton)),
                        ],
                      ),
                    ),
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
