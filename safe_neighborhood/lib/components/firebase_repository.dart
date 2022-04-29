import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:safe_neighborhood/services/auth_service.dart';

class FirestoreRepository extends ChangeNotifier {
  late Map<String, dynamic> user = {};
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

  Stream<QuerySnapshot> readWhitelist() {
    return db.collection('whitelist').snapshots();
  }

  _readDevice() async {
    if (auth.usuario != null && allowedDevice.isEmpty) {
      final snapshot =
          await db.collection('users').doc(auth.usuario!.uid).get();
      allowedDevice = {
        'device': snapshot.get('device'),
        'status': snapshot.get('status'),
      };
      if (kDebugMode) {
        print('dispositivo: $allowedDevice');
      }
      notifyListeners();
    }
  }

  Future<Map> readDevice() async {
    await _readDevice();
    return allowedDevice;
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

  allowDevice(String device) async {
    if (auth.usuario != null) {
      await db
          .collection('users')
          .doc(auth.usuario!.uid)
          .update({
            'device': device,
            'status': true,
          })
          // ignore: avoid_print
          .then((value) => print('Dispositivo associado! Device: $device'))
          .catchError(
              // ignore: avoid_print
              (onError) => print('Error ao associar dispositivo: $onError'));
    }
  }

  createAlert(
      String description, String type, String device, bool anonymous) async {
    if (anonymous) {
      alertBody = {
        'user': 'Usuário anônimo',
        'description': description,
        'type': type,
        'device': device
      };
    } else {
      alertBody = {
        'user': user['nome completo'],
        'description': description,
        'type': type,
        'device': device
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

  logoutRequest() {
    user = {};
    allowedDevice = {};
  }
}
