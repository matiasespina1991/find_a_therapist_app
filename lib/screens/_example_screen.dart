import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';
import '../generated/l10n.dart';

class ExampleScreen extends ConsumerStatefulWidget {
  const ExampleScreen({super.key});

  @override
  ConsumerState<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends ConsumerState<ExampleScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: S.of(context).exampleTitleSmallPrefix,
      isProtected: false,
      body: const Center(
        child: Text('Example screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
