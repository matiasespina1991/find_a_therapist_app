import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import '../../services/firestore_service.dart';

Future<void> updatePropsOnTherapistsDocs() async {
  // Obtener referencia a la colección de terapeutas
  CollectionReference therapistsCollection =
      FirestoreService.instance.collection('therapists');

  // Obtener todos los documentos en la colección
  QuerySnapshot querySnapshot = await therapistsCollection.get();

  // Iterar sobre cada documento
  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    if (doc.id != 'AhCRJehRbnT2gPdH3KJb') {
      continue;
    }
    print('Updateando ${doc.id}');

    final now = DateTime.now();
    final threeMonthsAgo = now.subtract(Duration(days: 90));
    final difference =
        now.millisecondsSinceEpoch - threeMonthsAgo.millisecondsSinceEpoch;
    final randomMilliseconds = Random().nextInt(difference);
    final randomLastOnline = Timestamp.fromDate(
      DateTime.fromMillisecondsSinceEpoch(
          threeMonthsAgo.millisecondsSinceEpoch + randomMilliseconds),
    );

    // Generar una fecha de cumpleaños aleatoria entre 1980 y 1998
    final startYear = 1980;
    final endYear = 1998;
    final randomYear = startYear + Random().nextInt(endYear - startYear + 1);
    final randomMonth = Random().nextInt(12) + 1;
    final randomDay = Random().nextInt(28) + 1;
    final randomBirthday =
        Timestamp.fromDate(DateTime(randomYear, randomMonth, randomDay));

    // Asignar el teléfono según el país
    final country = doc['therapistInfo']['location']['country'];
    String areaCode;
    switch (country) {
      case 'California':
        areaCode = '1';
        break;
      case 'Australia':
        areaCode = '61';
        break;
      case 'Alemania':
        areaCode = '49';
        break;
      case 'Mexico':
        areaCode = '52';
        break;
      case 'España':
        areaCode = '34';
        break;
      case 'USA':
        areaCode = '1';
        break;
      case 'Irlanda':
        areaCode = '353';
        break;
      case 'Irak':
        areaCode = '964';
        break;
      case 'Argentina':
        areaCode = '54';
        break;
      case 'Nueva Zelanda':
        areaCode = '64';
        break;
      case 'India':
        areaCode = '91';
        break;
      case 'Suiza':
        areaCode = '41';
        break;
      case 'Ucrania':
        areaCode = '380';
        break;
      case 'Turquia':
        areaCode = '90';
        break;
      default:
        areaCode = '000';
    }
    final randomPhoneNumber = '${Random().nextInt(9000000) + 1000000}';

    // Crear los nuevos campos con valores generados
    Map<String, dynamic> updatedData = {
      'lastOnline': randomLastOnline,
      'therapistInfo.title': '',
      'therapistInfo.birthday': randomBirthday,
      'therapistInfo.phone': {
        'areaCode': areaCode,
        'number': randomPhoneNumber,
      },
    };

    // Actualizar el documento
    await therapistsCollection.doc(doc.id).update(updatedData);
  }

  print('Todos los documentos han sido actualizados.');
}
