import 'package:flutter/material.dart';
import 'package:safe_neighborhood/pages/map.page.dart';

// ignore: camel_case_types
class Login_page extends StatefulWidget {
  const Login_page({Key? key}) : super(key: key);

  @override
  State<Login_page> createState() => _Login_pageState();
}

// ignore: camel_case_types
class _Login_pageState extends State<Login_page> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(8, 100, 8, double.maxFinite),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Image(
                    image: AssetImage('assets/images/reallogo.png'),
                    width: 150,
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 50, 0, 0),
                    child: TextField(
                      controller: _loginController,
                      decoration: InputDecoration(
                        icon: Container(
                          padding: const EdgeInsets.only(right: 24),
                          child: const Icon(
                            Icons.person_outlined,
                            size: 30,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        icon: Container(
                          padding: const EdgeInsets.only(right: 24),
                          child: const Icon(
                            Icons.key_outlined,
                            size: 30,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(24, 40, 160, 20),
                      primary: Colors.blueAccent,
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapPage(),
                        ),
                      );
                    },
                    child: const Text('LOGIN'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(90, 0, 100, 30),
                      primary: Colors.white.withOpacity(0.2),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {},
                    child: const Text('Esqueci minha senha'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
