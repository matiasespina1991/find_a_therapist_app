import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:findatherapistapp/app_settings/theme_settings.dart';
import 'package:findatherapistapp/models/therapist_model.dart';

class TherapistListCard extends StatelessWidget {
  final TherapistModel therapist;
  final VoidCallback onTap;

  const TherapistListCard({
    super.key,
    required this.therapist,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: ThemeSettings.cardVerticalSpacing,
        horizontal: 6,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              blurRadius: 5,
              offset: const Offset(1, 2),
            ),
        ],
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
      foregroundDecoration: BoxDecoration(
        borderRadius: ThemeSettings.cardBorderRadius,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            ThemeSettings.seedColor.withOpacity(0.01),
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: ThemeSettings.cardBorderRadius,
          onTap: onTap,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 1,
                                offset: const Offset(0, 1),
                              ),
                            ],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: CachedNetworkImageProvider(
                              therapist.therapistInfo.profilePictureUrl.small,
                            ),
                          ),
                        ),
                        if (therapist.isOnline)
                          Positioned(
                            bottom: 1.5,
                            right: 2,
                            child: Card(
                              elevation: 0.5,
                              child: Container(
                                width: 17,
                                height: 17,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: therapist.isOnline
                                      ? Colors.green
                                      : Colors.red,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '${therapist.therapistInfo.firstName} ${therapist.therapistInfo.lastName}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (therapist.therapistInfo.userInfoIsVerified)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: therapist.subscription.plan == 'gold'
                                      ? Image.asset(
                                          'lib/assets/icons/gold-plan-badge.png',
                                          width: 15,
                                        )
                                      : Image.asset(
                                          'lib/assets/icons/verified-badge.png',
                                          width: 15,
                                        ),
                                ),
                            ],
                          ),
                          Text(
                            '${therapist.therapistInfo.location.city}, ${therapist.therapistInfo.location.country}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[500],
                            ),
                          ),
                          Text(
                            therapist.therapistInfo.bio,
                            style: TextStyle(
                              fontSize: 15.5,
                              color: Colors.grey[700],
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 7,
                right: 15,
                child: Row(
                  children: [
                    Text('${therapist.score.rating}',
                        style: const TextStyle(
                          fontSize: 15,
                        )),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 18,
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
