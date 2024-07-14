import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../app_settings/theme_settings.dart';

class SkeletonTherapistCard extends StatelessWidget {
  const SkeletonTherapistCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      ignoreContainers: true,
      child: Container(
        height: 145,
        margin: const EdgeInsets.symmetric(
          vertical: ThemeSettings.cardVerticalSpacing,
        ),
        decoration: BoxDecoration(
          borderRadius: ThemeSettings.cardBorderRadius,
          border: BoxBorder.lerp(
            Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 0.5,
            ),
            Border.all(
              color: Colors.grey.withOpacity(0.2),
              width: 0.5,
            ),
            0.5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: CachedNetworkImageProvider(
                  'https://via.placeholder.com/150',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 15,
                      width: 220,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 15,
                      width: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 11,
                      width: 200,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 11,
                      width: 200,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
