// lib/utils/functions/profile_utils.dart

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<String?> uploadProfilePicture(
    File imageFile, String profileTarget) async {
  try {
    final storageRef = FirebaseStorage.instance.ref();
    final profilePictureRef = storageRef.child(
        '$profileTarget/profile_pictures/${imageFile.path.split('/').last}');
    final uploadTask = profilePictureRef.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    debugPrint('Error uploading profile picture: $e');
    return null;
  }
}

Future<File?> pickImage(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);

  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}
