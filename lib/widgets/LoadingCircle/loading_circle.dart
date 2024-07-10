import 'package:flutter/material.dart';

class LoadingCircle extends StatelessWidget {
  final Color? color;
  const LoadingCircle({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).colorScheme.secondary),
    ));
  }
}
