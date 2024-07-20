import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/services/firestore_service.dart';

Future<void> addTherapist() async {
  FirebaseFirestore firestore = FirestoreService.instance;
  String uid = 'gTmWZZQyzeaIJxAGtctJvk0HGZw1';

  // Datos del terapeuta
  final Map<String, dynamic> therapistData = {
    "id": uid,
    "createdAt": Timestamp.now(),
    "updatedAt": Timestamp.now(),
    "aspects": {"positive": [], "negative": []},
    "subscription": {
      "endsAt": Timestamp.now(),
      "plan": "",
      "startedAt": Timestamp.now(),
      "autoRenewal": false
    },
    "score": {"rating": 0.0, "amountRatings": 0},
    "therapistInfo": {
      "intro": "",
      "publicPresentation": "",
      "privateNotes": "",
      "location": {
        "address": "",
        "city": "",
        "country": "",
        "geolocation": GeoPoint(0.0, 0.0),
        "stateProvince": "",
        "zip": ""
      },
      "firstName": "",
      "userInfoIsVerified": false,
      "lastName": "",
      "specializations": [],
      "spokenLanguages": [],
      "professionalCertificates": [],
      "profilePictureUrl": {"large": "", "small": "", "thumb": ""},
      "meetingType": {"presential": false, "remote": false}
    },
    "isOnline": false,
    "lastOnline": Timestamp.now(),
    "phone": {"areaCode": "", "number": ""},
    "title": ""
  };

  // Guardar en Firestore
  await firestore.collection('therapists').doc(uid).set(therapistData);
}
