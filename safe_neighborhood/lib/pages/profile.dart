import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_neighborhood/components/firebase_repository.dart';
import 'package:safe_neighborhood/main.dart';
import 'package:safe_neighborhood/services/auth_service.dart';
import 'package:safe_neighborhood/widgets/loading_error_page.dart';

import '../theme/app_colors.dart';
import '../widgets/loading_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  late bool isEdit = false;
  late bool isEnabled = false;
  late Map<dynamic, dynamic> _user;
  final String profileAsset = 'assets/images/profile.png';
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _phonecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<Map> getUserData() async {
    await context
        .read<FirestoreRepository>()
        .getUser()
        .then((value) => _user = value);
    return _user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _logout().then(
          (value) => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const MyApp())),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        child: const Icon(
          Icons.logout_rounded,
          size: 32,
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        title: const Text(
          'Perfil',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          PopupMenuButton(
              onSelected: (value) {
                switch (value) {
                  case MenuItem.logout:
                    _logout().then(
                      (value) => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MyApp())),
                    );
                    break;
                  case MenuItem.editProfile:
                    _editProfile();
                    break;
                }
              },
              itemBuilder: (_) => [
                    PopupMenuItem<MenuItem>(
                      value: MenuItem.editProfile,
                      child: Row(
                        children: const [
                          Icon(Icons.mode_edit_rounded),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Editar Perfil'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: MenuItem.logout,
                      child: Row(
                        children: const [
                          Icon(Icons.logout_rounded),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Desconectar-se'),
                        ],
                      ),
                    ),
                  ]),
        ],
      ),
      body: FutureBuilder<Map>(
          future: getUserData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const LoadingPage();
              default:
                if (snapshot.hasError) {
                  return const ErrorPage();
                } else {
                  return Container(
                    alignment: Alignment.topCenter,
                    margin: const EdgeInsets.all(50),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            decoration: const ShapeDecoration(
                                shape: CircleBorder(), color: Colors.white),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
                              child: Image.asset(profileAsset),
                            ),
                          ),
                          Form(
                            key: formKey,
                            child: editUserInfo(),
                          ),
                        ],
                      ),
                    ),
                  );
                }
            }
          }),
    );
  }

  Widget editUserInfo() {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            child: TextFormField(
              style: const TextStyle(color: AppColors.textTitle),
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'nome completo',
                labelStyle: const TextStyle(
                    color: AppColors.textTitle, fontWeight: FontWeight.bold),
                hintText: _user['nome completo'],
                hintStyle: const TextStyle(color: AppColors.textSubTitle),
              ),
              controller: _namecontroller,
              enabled: isEdit,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo obrigatório!';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            child: TextFormField(
              style: const TextStyle(color: AppColors.textTitle),
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'e-mail',
                labelStyle: const TextStyle(
                    color: AppColors.textTitle, fontWeight: FontWeight.bold),
                hintText: _user['e-mail'],
                hintStyle: const TextStyle(color: AppColors.textSubTitle),
              ),
              controller: _emailcontroller,
              enabled: isEdit,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo obrigatório!';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            child: TextFormField(
              style: const TextStyle(color: AppColors.textTitle),
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'telefone',
                labelStyle: const TextStyle(
                    color: AppColors.textTitle, fontWeight: FontWeight.bold),
                hintText: _user['telefone'],
                hintStyle: const TextStyle(color: AppColors.textSubTitle),
              ),
              controller: _phonecontroller,
              enabled: isEdit,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Campo obrigatório!';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          isEdit ? editProfile() : Container(),
        ],
      ),
    );
  }

  Widget editProfile() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _editUser({
                  'nome completo': _namecontroller.text,
                  'telefone': _phonecontroller.text,
                  'e-mail': _emailcontroller.text,
                });
                setState(() {
                  isEdit = false;
                });
              }
            },
            child: Text('Editar'.toUpperCase()),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              isEdit = false;
            });
          },
          child: Text('Cancelar'.toUpperCase()),
        ),
      ],
    );
  }

  _editUser(Map<String, dynamic> userData) async {
    try {
      await context.read<FirestoreRepository>().editUserData(userData);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _logout() async {
    try {
      await context.read<FirestoreRepository>().logoutRequest();
      await context.read<AuthService>().logout();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _editProfile() {
    setState(() {
      isEdit = !isEdit;
      _namecontroller.text = _user['nome completo'];
      _emailcontroller.text = _user['e-mail'];
      _phonecontroller.text = _user['telefone'];
    });
    if (kDebugMode) {
      print('nome: $_namecontroller');
      print('e-mail: $_emailcontroller');
      print('telefone: $_phonecontroller');
    }
  }
}
