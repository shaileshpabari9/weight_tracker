import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference get allWeights =>
      FirebaseFirestore.instance.collection('weights');

  addWeight(double weight) {
    return allWeights
        .add({'weight': weight, 'createdTime': FieldValue.serverTimestamp()});
  }

  deleteWeight(String docId) {
    return allWeights.doc(docId).delete();
  }

  editWeight(double weight, String docId) {
    return allWeights.doc(docId).update({
      'weight': weight,
    });
  }
}
