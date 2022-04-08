import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safe_neighborhood/pages/map.page.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';

class Login_page extends StatefulWidget {
  const Login_page({Key? key}) : super(key: key);

  @override
  State<Login_page> createState() => _Login_pageState();
}

// ignore: camel_case_types
class _Login_pageState extends State<Login_page> {
  bool _showPassword = false;
  late var _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  String _imeiNo = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 100,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Seja bem-vindo!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 2,
            ),
            const Text(
              'Por favor, faça login para continuar',
              style: TextStyle(
                  color: AppColors.textSubTitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              textAlign: TextAlign.start,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'E-mail',
                labelText: 'E-mail',
              ),
              style: const TextStyle(
                  color: AppColors.textTitle,
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  textBaseline: TextBaseline.alphabetic),
            ),
            TextFormField(
              textAlign: TextAlign.start,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                hintText: 'Senha',
                labelText: 'Senha',
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showPassword = !_showPassword;
                      });
                    },
                    child: Icon(
                      _showPassword == false
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.textTitle,
                      size: 18,
                    )),
              ),
              style: const TextStyle(
                  color: AppColors.textTitle,
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  textBaseline: TextBaseline.alphabetic),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Esqueci minha senha!',
                textAlign: TextAlign.start,
                style: TextStyle(color: AppColors.secondaryText),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('ENTRAR'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Registre-se',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textTitle, fontSize: 20),
                  ),
                ),
              ],
            )
          ],
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
