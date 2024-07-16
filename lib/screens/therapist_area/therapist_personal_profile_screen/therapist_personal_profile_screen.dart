import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../generated/l10n.dart';
import '../../../../widgets/AppScaffold/app_scaffold.dart';

class TherapistPersonalProfileScreen extends ConsumerStatefulWidget {
  const TherapistPersonalProfileScreen({super.key});

  @override
  ConsumerState<TherapistPersonalProfileScreen> createState() =>
      _TherapistPersonalProfileScreenState();
}

class _TherapistPersonalProfileScreenState
    extends ConsumerState<TherapistPersonalProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: S.of(context).userProfile,
      useTopAppBar: true,
      isProtected: false,
      body: const Center(
        child: Text('User profile', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
