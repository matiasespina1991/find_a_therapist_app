import 'package:flutter/material.dart';
import 'package:findatherapistapp/models/therapist_model.dart';

class AspectSection extends StatelessWidget {
  final List<Term> positiveAspects;
  final List<Term> negativeAspects;

  const AspectSection({
    Key? key,
    required this.positiveAspects,
    required this.negativeAspects,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Positive Aspects'),
        ...positiveAspects.map((term) => ListTile(
              title: Text(term.term),
              trailing:
                  Icon(term.public ? Icons.visibility : Icons.visibility_off),
            )),
        SizedBox(height: 20),
        Text('Negative Aspects'),
        ...negativeAspects.map((term) => ListTile(
              title: Text(term.term),
              trailing:
                  Icon(term.public ? Icons.visibility : Icons.visibility_off),
            )),
      ],
    );
  }
}
