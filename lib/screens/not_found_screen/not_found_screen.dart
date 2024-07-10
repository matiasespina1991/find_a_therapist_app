import 'package:flutter/material.dart';

import '../../widgets/AppScaffold/app_scaffold.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      isProtected: false,
      body: Center(
        child: Text('404 - Page Not Found', style: TextStyle(fontSize: 24)),
      ),
      appBarTitle: '404 - Page Not Found',
    );
  }
}
