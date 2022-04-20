import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:safe_neighborhood/services/auth_service.dart';

class FirestoreRepository extends ChangeNotifier {
  late Map<String, dynamic> user = {};
  late FirebaseFirestore db = FirebaseFirestore.instance;
  late AuthService auth;

  FirestoreRepository({required this.auth}) {
    _readData();
  }

  _readData() async {
    db.collection('users').doc(auth.usuario!.uid).snapshots().listen((event) {
      user = event.data()!;
      notifyListeners();
    });
  }

  getUserData() async {
    _readData();
  }
}
