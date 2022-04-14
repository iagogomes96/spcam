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
  // ignore: prefer_typing_uninitialized_variables
  late var uid;
  User? usuario;
  bool isLoading = true;
  Map<String, dynamic> userData = {};
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

  register(String email, String password, String fullname, String phone) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      uid = usuario?.uid ?? ''.toString();
      if (kDebugMode) {
        print('usuario: $uid');
      }
      userData = {
        'nome completo': fullname,
        'telefone': phone,
        'e-mail': email,
      };
      if (kDebugMode) {
        print(userData);
      }
      createUserData(userData, uid);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca.');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este e-mail já está cadastrado.');
      }
    }
  }

  login(String email, String password) async {
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

  logout() async {
    await _auth.signOut();
    _getUser();
  }

  Future<void> createUserData(Map<String, dynamic> userData, String uid) async {
    if (kDebugMode) {
      print('dados: $userData, usuario: $uid');
    }
    await _db.collection('users').doc(uid).set(userData);
  }
}
