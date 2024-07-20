import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalTopChip extends StatelessWidget {
  const ModalTopChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 14,
        ),
        Container(
          height: 5,
          width: 36,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}
