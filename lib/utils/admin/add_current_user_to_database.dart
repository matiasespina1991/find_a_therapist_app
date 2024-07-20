import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/services/firestore_service.dart';
import 'package:findatherapistapp/models/current_user_data.dart';

Future<void> createUser() async {
  FirebaseFirestore firestore = FirestoreService.instance;

  // Datos del usuario
  final CurrentUserData userData = CurrentUserData(
    id: 'gTmWZZQyzeaIJxAGtctJvk0HGZw1',
    userInfo: UserInfo(
      email: 'matiasespina1991@gmail.com',
      displayName: 'M E',
      phone: Phone(areaCode: '', number: ''),
      profilePictureUrl: ProfilePictureUrl(
        large: '',
        small: '',
        thumb: '',
      ),
      title: '',
    ),
    isTherapist: false,
    createdAt: Timestamp.now(),
    updatedAt: Timestamp.now(),
    isOnline: false,
    lastOnline: Timestamp.now(),
    score: Score(rating: 0.0, amountRatings: 0),
    subscription: Subscription(
      endsAt: Timestamp.now(),
      plan: '',
      startedAt: Timestamp.now(),
      autoRenewal: false,
    ),
  );

  // Guardar en Firestore
  await firestore.collection('users').doc(userData.id).set(userData.toJson());
}
