import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String userId = 'user_lab3_2025';

  Future<void> toggleFavorite(String mealId) async {
    var docRef = _firestore.collection('users').doc(userId).collection('favorites').doc(mealId);
    var doc = await docRef.get();
    if (doc.exists) await docRef.delete();
    else await docRef.set({'mealId': mealId, 'addedAt': FieldValue.serverTimestamp()});
  }

  Stream<List<String>> getFavorites() {
    return _firestore.collection('users').doc(userId).collection('favorites')
        .snapshots().map((snap) => snap.docs.map((d) => d['mealId'] as String).toList());
  }
}
