import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

final ImagePicker _picker = ImagePicker();

Future<File?> pickImage(ImageSource source) async {
  final pickedFile = await _picker.pickImage(
    source: source,
    preferredCameraDevice: source == ImageSource.camera
        ? CameraDevice.front
        : CameraDevice.rear, // Usar cámara frontal si es fuente de cámara
  );
  if (pickedFile != null) {
    return File(pickedFile.path);
  }
  return null;
}

Future<String?> uploadImageToFirebase(File imageFile) async {
  try {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profile_pictures/${DateTime.now().toIso8601String()}.png');
    final uploadTask = storageRef.putFile(imageFile);

    final snapshot = await uploadTask.whenComplete(() => null);
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return downloadUrl;
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}
