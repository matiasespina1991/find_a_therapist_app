import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import '../../models/term_index_model.dart';

Future<void> addTermsAsSubcategory(
    String parentTerm, List<String> subcategories) async {
  FirebaseFirestore firestore = FirestoreService.instance;
  CollectionReference termsCollection = firestore.collection('terms-index');

  // Obtener el documento del término principal
  DocumentSnapshot parentDoc = await termsCollection.doc(parentTerm).get();
  TermIndex parentTermIndex;

  if (parentDoc.exists) {
    parentTermIndex = TermIndex.fromJson(
        parentDoc.data() as Map<String, dynamic>, parentDoc.id);
  } else {
    // Crear un nuevo término principal si no existe
    parentTermIndex = TermIndex(
      id: parentTerm,
      term: parentTerm,
      associatedTerms: {
        'equivalents': [],
        'related': [],
        'subcategories': [],
      },
      positive: [],
      negative: [],
    );
  }

  // Obtener las subcategorías existentes y agregar nuevas
  Set<String> existingSubcategories =
      parentTermIndex.associatedTerms['subcategories']?.toSet() ?? {};

  // Agregar términos subcategoricos directamente
  existingSubcategories.addAll(subcategories);

  // Asignar las subcategorías actualizadas
  parentTermIndex.associatedTerms['subcategories'] =
      existingSubcategories.toList();

  // Guardar el término principal actualizado utilizando merge para no sobrescribir los datos existentes
  await termsCollection.doc(parentTerm).set({
    'associatedTerms': {
      'subcategories': FieldValue.arrayUnion(existingSubcategories.toList()),
    }
  }, SetOptions(merge: true));

  debugPrint('Parent term: $parentTerm');
  debugPrint('Subcategories added: ${subcategories.join(', ')}');
}
