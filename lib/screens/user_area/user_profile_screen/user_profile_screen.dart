import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../generated/l10n.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
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
