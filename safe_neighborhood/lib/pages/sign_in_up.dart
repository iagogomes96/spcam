import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_neighborhood/services/auth_service.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';
import 'package:safe_neighborhood/widgets/auth_check.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  bool _showPassword = false;
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  final fullname = TextEditingController();
  final phone = TextEditingController();
  late AuthService auth;
  Map<String, dynamic> user = {};

  bool isLogin = true;
  late String title;
  late String subtitle;

  late String actionButton;
  late String toggleButton;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (kDebugMode) {
        print('is login:$isLogin');
      }
      if (isLogin) {
        title = 'Seja Bem-vindo!';
        subtitle = 'Por favor, faça login para continuar';
        actionButton = 'ENTRAR';
        toggleButton = 'Registre-se';
      } else {
        title = 'Cadastre-se!';
        subtitle = 'Preencha o formlário de cadastro.';
        actionButton = 'CADASTRAR';
        toggleButton = 'Fazer Login';
      }
    });
  }

  login() async {
    if (kDebugMode) {
      print('Login');
    }
    try {
      await context.read<AuthService>().login(email.text, password.text);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const AuthCheck()));
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  register() async {
    user = {
      'nome completo': fullname,
      'telefone': phone,
      'e-mail': email,
    };
    if (kDebugMode) {
      print(user);
    }
    try {
      await context
          .read<AuthService>()
          .register(email.text, password.text, fullname.text, phone.text);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const AuthCheck()));
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 100,
          ),
          child: Form(
            key: formKey,
            child: isLogin ? _login() : _register(),
          ),
        ),
      ),
    );
  }

  Widget _login() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
          ),
          Text(
            subtitle,
            style: const TextStyle(
                color: AppColors.textSubTitle,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: email,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: 'E-mail',
                labelText: 'E-mail',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Informe o e-mail corretamente!';
                }
                return null;
              },
            ),
          ),
          TextFormField(
              controller: password,
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
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Informe sua senha!';
                } else if (value.length < 6) {
                  return 'Sua senha deve ter ao menos 6 caracteres';
                }
                return null;
              }),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Esqueci minha senha!',
              textAlign: TextAlign.start,
              style: TextStyle(color: AppColors.secondaryText),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (isLogin) {
                    login();
                  }
                }
              },
              child: Text(actionButton),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => setFormAction(!isLogin),
              child: Text(
                toggleButton,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: AppColors.textTitle, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _register() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900),
          ),
          Text(
            subtitle,
            style: const TextStyle(
                color: AppColors.textSubTitle,
                fontSize: 16,
                fontWeight: FontWeight.w700),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: fullname,
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                hintText: 'Nome completo',
                labelText: 'Nome completo',
              ),
              style: const TextStyle(
                  color: AppColors.textTitle,
                  fontSize: 18,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w500,
                  textBaseline: TextBaseline.alphabetic),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo obrigatório!';
                }
                return null;
              },
            ),
          ),
          TextFormField(
            controller: phone,
            textAlign: TextAlign.start,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Telefone',
              labelText: 'Telefone',
            ),
            style: const TextStyle(
                color: AppColors.textTitle,
                fontSize: 18,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w500,
                textBaseline: TextBaseline.alphabetic),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Campo obrigatório!';
              }
              return null;
            },
          ),
          TextFormField(
            controller: email,
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
            validator: (value) {
              if (value!.isEmpty) {
                return 'Informe o e-mail corretamente!';
              }
              return null;
            },
          ),
          TextFormField(
              controller: password,
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
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Informe sua senha!';
                } else if (value.length < 6) {
                  return 'Sua senha deve ter ao menos 6 caracteres';
                }
                return null;
              }),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (!isLogin) {
                    register();
                  }
                }
              },
              child: Text(actionButton),
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () => setFormAction(!isLogin),
              child: Text(
                toggleButton,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: AppColors.textTitle, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
