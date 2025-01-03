import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:safe_neighborhood/services/auth_service.dart';

class FirestoreRepository extends ChangeNotifier {
  late Map<String, dynamic> user = {};
  late Map<String, dynamic> camInfo = {};
  late FirebaseFirestore db = FirebaseFirestore.instance;
  late Map<String, dynamic> allowedDevice = {};
  late AuthService auth;
  late Map<String, dynamic> alertBody = {};

  FirestoreRepository({required this.auth}) {
    _readData();
  }

  _readData() async {
    if (auth.usuario != null && user.isEmpty) {
      final snapshot =
          await db.collection('users').doc(auth.usuario!.uid).get();
      user = {
        'nome completo': snapshot.get('nome completo'),
        'telefone': snapshot.get('telefone'),
        'e-mail': snapshot.get('e-mail'),
      };
      notifyListeners();
    }
  }

  Future<Map> getUser() async {
    await _readData();
    return user;
  }

  editUserData(Map<String, dynamic> userEdit) async {
    if (auth.usuario != null) {
      user = userEdit;
      if (kDebugMode) {
        print('Dados atualizados: $user');
      }
      await db
          .collection('users')
          .doc(auth.usuario!.uid)
          .update(user)
          // ignore: avoid_print
          .then((value) => print('Success: novos dados: $user'))
          // ignore: avoid_print
          .catchError((onError) => print('Error: $onError'));
    }
  }

  createAlert(String description, String type, String device, bool anonymous,
      String camID) async {
    if (anonymous) {
      alertBody = {
        'user': 'Usuário anônimo',
        'description': description,
        'type': type,
        'device': device,
        'camid': camID,
        'value': true
      };
    } else {
      alertBody = {
        'user': user['nome completo'],
        'description': description,
        'type': type,
        'device': device,
        'camid': camID,
        'value': true
      };
    }
    await db
        .collection('cameras')
        .doc(device)
        .collection('alerts')
        .doc()
        .set(alertBody);
  }

  Stream<QuerySnapshot> getAlerts(String device) {
    return db
        .collection('cameras')
        .doc(device)
        .collection('alerts')
        .snapshots();
  }

  Stream<QuerySnapshot> getCameras() {
    return db
        .collection('cameras')
        .snapshots(); //return how much documents does "cameras" have
  }

  Stream<QuerySnapshot> getCameraInfo(String device) {
    return db
        .collection('cameras')
        .doc(device)
        .collection('info')
        .snapshots(); //return informations about camera like url, address, ...
  }

  logoutRequest() {
    user = {};
    allowedDevice = {};
  }
}
