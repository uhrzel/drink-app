import 'package:flutter/foundation.dart';
import '../models/weekly_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StatisticsProvider extends ChangeNotifier {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  late String _uid;
  late CollectionReference _weeksRef;

  List<WeeklyData> _weeklyData = [];

  List<WeeklyData> get weeklyData => [..._weeklyData];

  void update(User? user) {
    if (user != null) {
      _uid = user.uid;
      _weeksRef =
          _firebaseFirestore.collection('users').doc(_uid).collection('weeks');
    } else {
      _uid = '';
      _weeksRef = FirebaseFirestore.instance.collection(
          'dummy'); // Replace 'dummy' with an existing collection name
      _weeklyData.clear();
    }
  }

  Future<void> init() async {
    try {
      _weeklyData.clear();
      QuerySnapshot snapshot =
          await _weeksRef.orderBy('id', descending: true).limit(4).get();
      List<QueryDocumentSnapshot> docsSnap = snapshot.docs;
      docsSnap.forEach((docSnap) {
        _weeklyData
            .add(WeeklyData.fromDoc(docSnap.data() as Map<String, dynamic>));
      });
    } catch (e) {
      print(e);
    }
  }
}
