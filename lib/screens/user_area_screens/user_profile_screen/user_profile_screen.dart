import 'package:findatherapistapp/widgets/AppScaffold/app_scaffold.dart';
import 'package:flutter/cupertino.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      body: Placeholder(),
      appBarTitle: 'User Profile',
    );
  }
}
