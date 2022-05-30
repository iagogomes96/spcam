import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_neighborhood/components/allow_device.dart';
import 'package:safe_neighborhood/components/firebase_repository.dart';
import 'package:safe_neighborhood/services/auth_service.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';
import 'package:safe_neighborhood/widgets/auth_check.dart';
import '../widgets/loading_page.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  bool _showPassword = false;
  late List<String> whitelist = [];
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

  Stream<QuerySnapshot> _getAuth() {
    return context.read<FirestoreRepository>().readWhitelist();
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

  Future<void> login() async {
    try {
      await context.read<AuthService>().login(email.text, password.text).then(
            (value) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AuthCheck(),
              ),
            ),
          );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> register() async {
    user = {
      'nome completo': fullname,
      'telefone': phone,
      'e-mail': email,
    };
    try {
      await context
          .read<AuthService>()
          .register(email.text, password.text, fullname.text, phone.text)
          .then(
            (value) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AllowDevice(),
              ),
            ),
          );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
        ),
        child: Form(
          key: formKey,
          child: authCodesbuilder(),
        ),
      ),
    );
  }

  Widget authCodesbuilder() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: StreamBuilder<QuerySnapshot>(
        stream: _getAuth(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const LoadingPage();
            case ConnectionState.active:
            case ConnectionState.done:
              return Stack(
                children: [
                  listViewbuilder(context, snapshot),
                  Center(child: isLogin ? loginBuilder() : registerBuilder()),
                ],
              );
          }
        },
      ),
    );
  }

  Widget loginBuilder() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900),
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
                style: const TextStyle(
                    color: AppColors.textTitle,
                    fontSize: 18,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    textBaseline: TextBaseline.alphabetic),
                decoration: const InputDecoration(
                  hintText: 'E-mail',
                  hintStyle: TextStyle(fontSize: 14),
                  labelText: 'E-mail',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Informe o e-mail corretamente!';
                  } else if (!whitelist.contains(value)) {
                    return 'E-mail não autorizado';
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
                  hintStyle: const TextStyle(fontSize: 14),
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
              onPressed: () {
                if (email.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        'Insira o e-mail para recuperação',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                } else if (whitelist.contains(email.text)) {
                  context.read<AuthService>().recoveryPass(email.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('E-mail de recuperação enviado.'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.redAccent,
                      content: Text(
                        'Insira um e-mail válido',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }
              },
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
      ),
    );
  }

  Widget registerBuilder() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900),
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
                  hintStyle: TextStyle(fontSize: 14),
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
                hintStyle: TextStyle(fontSize: 14),
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
                hintStyle: TextStyle(fontSize: 14),
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
                } else if (!whitelist.contains(value)) {
                  return 'E-mail não autorizado';
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
                hintStyle: const TextStyle(fontSize: 14),
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
              },
            ),
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
      ),
    );
  }

  Widget listViewbuilder(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView.builder(
        itemCount: snapshot.data!.docs.length,
        itemBuilder: ((context, index) {
          final DocumentSnapshot doc = snapshot.data!.docs[index];
          if (doc['value']) {
            if (whitelist.isEmpty) {
              whitelist.add(doc['e-mail']);
            }
            if (whitelist.isNotEmpty && !whitelist.contains(doc['e-mail'])) {
              whitelist.add(doc['e-mail']);
            }
          } else {
            whitelist.remove(doc['e-mail']);
          }
          if (kDebugMode) {
            print('white list: $whitelist');
          }
          return Container();
        }));
  }
}
