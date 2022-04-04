import 'package:flutter/material.dart';
import 'package:safe_neighborhood/components/auth_form.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 1],
            colors: [
              Color.fromARGB(255, 26, 30, 40),
              Color.fromARGB(255, 46, 59, 65),
            ],
          ),
        ),
        child: const Center(
          child: SingleChildScrollView(
            child: AuthForm(),
          ),
        ),
      ),
    );
  }
}
