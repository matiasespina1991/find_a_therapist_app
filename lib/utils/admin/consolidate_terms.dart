import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findatherapistapp/services/firestore_service.dart';
import 'package:flutter/cupertino.dart';
import '../../models/term_index_model.dart';

Future<void> consolidateTerms(
    String parentTerm, List<String> equivalents) async {
  FirebaseFirestore firestore = FirestoreService.instance;
  CollectionReference termsCollection = firestore.collection('terms-index');

  QuerySnapshot snapshot = await termsCollection
      .where(FieldPath.documentId, whereIn: equivalents)
      .get();
  List<QueryDocumentSnapshot> docs = snapshot.docs;

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

  // Usar conjuntos para manejar los therapistId sin duplicados
  Set<TherapistIndex> positiveTherapists = parentTermIndex.positive.toSet();
  Set<TherapistIndex> negativeTherapists = parentTermIndex.negative.toSet();

  for (var doc in docs) {
    TermIndex term =
        TermIndex.fromJson(doc.data() as Map<String, dynamic>, doc.id);

    // Agregar término a equivalents si no existe ya
    if (!parentTermIndex.associatedTerms['equivalents']!.contains(term.term)) {
      parentTermIndex.associatedTerms['equivalents']?.add(term.term);
    }

    positiveTherapists.addAll(term.positive);
    negativeTherapists.addAll(term.negative);

    await termsCollection.doc(term.id).delete();

    debugPrint('Consolidated term: ${term.term}');
  }

  parentTermIndex.associatedTerms['equivalents'] =
      parentTermIndex.associatedTerms['equivalents']?.toSet().toList() ?? [];
  parentTermIndex.positive = positiveTherapists.toList();
  parentTermIndex.negative = negativeTherapists.toList();

  await termsCollection.doc(parentTerm).set(parentTermIndex.toJson());
  debugPrint('Consolidated term: $parentTerm');
}
