import 'package:animate_do/animate_do.dart';
import 'package:findatherapistapp/app_settings/app_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:findatherapistapp/app_settings/app_general_settings.dart';
import 'package:findatherapistapp/widgets/AppScaffold/app_scaffold.dart';

import '../../../generated/l10n.dart';
import '../../../routes/routes.dart';
import '../../../utils/admin/add_current_user_as_therapist.dart';
import '../../../utils/admin/add_current_user_to_database.dart';

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
    ///device height
    final double deviceHeight = MediaQuery.of(context).size.height;
    return AppScaffold(
      isProtected: true,
      ignoreGlobalPadding: true,
      appBarTitle: S.of(context).homeScreenTitle,
      body: SizedBox(
        height: deviceHeight - 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            const SizedBox(
              height: 60,
            ),
            Expanded(
              child: FadeInUp(
                from: 20,
                curve: Curves.decelerate,
                delay: const Duration(milliseconds: 2000),
                duration: const Duration(milliseconds: 900),
                child: Lottie.asset(
                    'lib/assets/lottie_animations/animation2.json',
                    width: 330
                    // Use BoxFit.contain to adjust the size
                    ),
              ),
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
                      delay: const Duration(milliseconds: 1500),
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
                          const SizedBox(height: 10),
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
            ElevatedButton(
                onPressed: () {
                  addTherapist();
                  createUser();
                },
                child: Text('Add Therapist and user')),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
