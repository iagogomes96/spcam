import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../services/auth_service.dart';

class UserData extends ChangeNotifier {
  late AuthService auth;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  UserData({required auth});

  createUser(String fullname, String email, String phone) {
    db
        .collection('/user/${auth.usuario!.uid}')
        .doc('dados')
        .set({'nome completo': fullname, 'email': email, 'telefone': phone});
  }
}
