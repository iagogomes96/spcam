import 'package:device_information/device_information.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:safe_neighborhood/data/get_permissions.dart';
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
  String _imeiNo = "";

  @override
  void initState() {
    super.initState();
    PermissionRequest().check_phone_permissions();
    getIMEI();
  }

  Future<void> getIMEI() async {
    late String imeiNo = '';

    try {
      imeiNo = await DeviceInformation.deviceIMEINumber;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    if (!mounted) return;

    setState(() {
      _imeiNo = imeiNo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                  onPressed: checkDevicePermission,
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
    );
  }

  Future<void> LoginPerms() async {}
  checkDevicePermission() {
    var authIMEI = '307411919831056';
    if (kDebugMode) {
      print('IMEI: $_imeiNo');
    }
    if (_imeiNo == authIMEI) {
      if (kDebugMode) {
        print('Dispositivo autorizado!');
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MapPage(),
        ),
      );
    } else {
      if (kDebugMode) {
        print('Dispositivo não autorizado!');
      }
    }
  }
}
