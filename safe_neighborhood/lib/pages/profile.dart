import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_neighborhood/components/firebase_repository.dart';
import 'package:safe_neighborhood/main.dart';
import 'package:safe_neighborhood/services/auth_service.dart';
import 'package:safe_neighborhood/widgets/auth_check.dart';
import 'package:safe_neighborhood/widgets/loading_error_page.dart';

import '../theme/app_colors.dart';
import '../widgets/loading_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late bool _enabled = false;
  late Map<String, dynamic> _user;
  final String profileAsset = 'assets/images/profile.png';
  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _phonecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<Map> getUserData() async {
    try {
      context.read<FirestoreRepository>().getUserData();
      _user = context.read<FirestoreRepository>().user;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    setState(() {
      _user;
    });
    return _user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _editProfile(),
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
                    _logout();
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
                  return editUserInfo();
                }
            }
          }),
    );
  }

  Widget editUserInfo() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Container(
              height: 120,
              width: 120,
              decoration: const ShapeDecoration(
                  shape: CircleBorder(), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
                child: Image.asset(profileAsset),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            child: Column(children: [
              SizedBox(
                child: TextFormField(
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText:
                        _enabled ? 'Nome completo' : _user['nome completo'],
                    labelStyle: const TextStyle(color: AppColors.textTitle),
                    hintText: _user['nome completo'],
                    hintStyle: const TextStyle(color: AppColors.textSubTitle),
                  ),
                  controller: _namecontroller,
                  enabled: _enabled,
                ),
              ),
              SizedBox(
                child: TextFormField(
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: _enabled ? 'E-mail' : _user['e-mail'],
                    labelStyle: const TextStyle(color: AppColors.textTitle),
                    hintText: _user['e-mail'],
                    hintStyle: const TextStyle(color: AppColors.textSubTitle),
                  ),
                  controller: _emailcontroller,
                  enabled: _enabled,
                ),
              ),
              SizedBox(
                child: TextFormField(
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    labelText: _enabled ? 'Telefone' : _user['telefone'],
                    labelStyle: const TextStyle(color: AppColors.textTitle),
                    hintText: _user['telefone'],
                    hintStyle: const TextStyle(color: AppColors.textSubTitle),
                  ),
                  controller: _phonecontroller,
                  enabled: _enabled,
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  _logout() async {
    try {
      await context.read<AuthService>().logout();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const AuthCheck()));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _editProfile() {
    setState(() {
      _enabled = !_enabled;
    });
  }
}
