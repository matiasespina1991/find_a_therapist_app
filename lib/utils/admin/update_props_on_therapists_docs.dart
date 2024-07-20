import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import '../../services/firestore_service.dart';

Future<void> updatePropsOnTherapistsDocs() async {
  // Obtener referencia a la colección de terapeutas
  CollectionReference therapistsCollection =
      FirestoreService.instance.collection('therapists');

  // Obtener todos los documentos en la colección
  QuerySnapshot querySnapshot = await therapistsCollection.get();

  /// Comment this line to allow this function to run
  return;

  try {
    // Iterar sobre cada documento
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      // if (doc.id != 'AhCRJehRbnT2gPdH3KJb') {
      //   continue;
      // }
      // print('Updateando ${doc.id}');

      final now = DateTime.now();
      final threeMonthsAgo = now.subtract(Duration(days: 90));
      final difference =
          now.millisecondsSinceEpoch - threeMonthsAgo.millisecondsSinceEpoch;

      // Asegurarse de que el valor de difference esté dentro del rango permitido
      final randomMilliseconds =
          difference > 0 ? Random().nextInt(min(difference, 4294967295)) : 0;

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
        case 'AU':
          areaCode = '61';
          break;
        case 'DE':
          areaCode = '49';
          break;
        case 'MX':
          areaCode = '52';
          break;
        case 'ES':
          areaCode = '34';
          break;
        case 'US':
          areaCode = '1';
          break;
        case 'IE':
          areaCode = '353';
          break;
        case 'IQ':
          areaCode = '964';
          break;
        case 'AR':
          areaCode = '54';
          break;
        case 'NZ':
          areaCode = '64';
          break;
        case 'IN':
          areaCode = '91';
          break;
        case 'CH':
          areaCode = '41';
          break;
        case 'UA':
          areaCode = '380';
          break;
        case 'TR':
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

      // print(updatedData);

      // Actualizar el documento
      await therapistsCollection.doc(doc.id).update(updatedData);
    }

    print('Todos los documentos han sido actualizados.');
  } catch (e) {
    print('Error: $e');
  }
}
