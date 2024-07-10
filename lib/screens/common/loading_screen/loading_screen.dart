import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../../../widgets/LoadingCircle/loading_circle.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({super.key});

  @override
  ConsumerState<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      isProtected: false,
      body: Center(
        child: LoadingCircle(),
      ),
      appBarTitle: 'Loading...',
    );
  }
}
