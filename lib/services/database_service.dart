import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  CollectionReference get allWeights =>
      FirebaseFirestore.instance.collection('weights');

  addWeight(double weight) {
    return allWeights
        .add({'weight': weight, 'createdTime': FieldValue.serverTimestamp()});
  }
}
