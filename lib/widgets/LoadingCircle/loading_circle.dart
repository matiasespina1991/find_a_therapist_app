import 'package:flutter/material.dart';

class LoadingCircle extends StatelessWidget {
  final Color? color;
  final double? strokeWidth;
  const LoadingCircle({super.key, this.color, this.strokeWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      strokeWidth: strokeWidth != null ? strokeWidth! : 5,
      valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).colorScheme.secondary),
    ));
  }
}
