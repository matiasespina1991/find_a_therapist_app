// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:findatherapistapp/services/firestore_service.dart';
// import 'dart:math';
// import 'package:flutter/cupertino.dart';
//
// Future<void> addEmailPropToAllTherapists() async {
//   FirebaseFirestore firestore = FirestoreService.instance;
//
//   // Generate a random email based on the therapist's name and last name
//   String generateEmail(String firstName, String lastName) {
//     List<String> domains = ['example.com', 'mail.com', 'email.com'];
//     String domain = domains[Random().nextInt(domains.length)];
//     String email =
//         '${firstName.toLowerCase()}.${lastName.toLowerCase()}@$domain';
//     return email;
//   }
//
//   try {
//     QuerySnapshot snapshot = await firestore.collection('therapists').get();
//
//     for (var doc in snapshot.docs) {
//       try {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         Map<String, dynamic> therapistInfo =
//             data['therapistInfo'] as Map<String, dynamic>;
//         String firstName = therapistInfo['firstName'] as String;
//         String lastName = therapistInfo['lastName'] as String;
//         String newEmail = generateEmail(firstName, lastName);
//
//         // Update the email in therapistInfo
//         await doc.reference.update({
//           'therapistInfo.email': newEmail,
//         });
//
//         print('Updated email for therapist ID ${doc.id}: $newEmail');
//       } catch (e, stack) {
//         print('Error processing document ID ${doc.id}: $e');
//         print('Stack trace: $stack');
//       }
//     }
//   } catch (e, stack) {
//     print('Failed to get therapists: $e');
//     print('Stack trace: $stack');
//   }
// }
