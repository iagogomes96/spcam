import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthException implements Exception {
  String message;
  AuthException(this.message);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? usuario;
  bool isLoading = true;
  AuthService() {
    _authCheck();
  }

  _authCheck() {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    if (kDebugMode) {
      print(usuario);
    }
    notifyListeners();
  }

  Future register(
      String email, String password, String fullname, String phone) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (kDebugMode) {
          print(value);
        }
        createUserData(usuario!.uid, fullname, phone, email);
      });
      if (kDebugMode) {
        print('usuario: ${usuario!.uid}');
      }
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este e-mail já está cadastrado.');
      }
    }
  }

  Future login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException(
            'E-mail não encontrado. Verifique o e-mail ou cadastre-se.');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta. Verifique-a e tente novamente');
      }
    }
  }

  Future logout() async {
    await _auth.signOut();
    _getUser();
  }

  createUserData(String uid, String name, String phone, String email) async {
    await _db
        .collection('users')
        .doc(uid)
        .set({
          'nome completo': name,
          'telefone': phone,
          'e-mail': email,
          'device': '',
          'status': true,
        })
        // ignore: avoid_print
        .then((value) => print('Success'))
        // ignore: avoid_print
        .catchError((onError) => print('Error: $onError'));
  }
}
