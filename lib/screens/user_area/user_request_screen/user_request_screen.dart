import 'package:findatherapistapp/widgets/AppScaffold/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../generated/l10n.dart';

class UserRequestScreen extends ConsumerStatefulWidget {
  const UserRequestScreen({super.key});

  @override
  ConsumerState<UserRequestScreen> createState() => _UserRequestScreenState();
}

class _UserRequestScreenState extends ConsumerState<UserRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isProtected: true,
      appBarTitle: 'Request a Therapist',
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('${S.of(context).tellUsWhatYouAreLookingFor}:',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              hintText: S.of(context).requestTextFieldHintText,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.5),
                  ),
              border: const OutlineInputBorder(),
            ),
            maxLines: 18,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {}, child: Text(S.of(context).sendButton)),
            ],
          ),
        ],
      )),
    );
  }
}
