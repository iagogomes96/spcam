import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_neighborhood/main.dart';
import 'package:safe_neighborhood/services/auth_service.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';

import '../components/firebase_repository.dart';

class DeviceDenied extends StatefulWidget {
  const DeviceDenied({Key? key}) : super(key: key);

  @override
  State<DeviceDenied> createState() => _DeviceDeniedState();
}

class _DeviceDeniedState extends State<DeviceDenied> {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Icon(
              Icons.app_blocking_rounded,
              size: 100,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Dispositivo não autorizado!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.textTitle,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Entre em contato com a central',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
