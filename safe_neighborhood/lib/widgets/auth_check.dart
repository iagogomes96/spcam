import 'package:device_information/device_information.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safe_neighborhood/components/firebase_repository.dart';
import 'package:safe_neighborhood/components/get_started.dart';
import 'package:safe_neighborhood/pages/home_page.dart';
import 'package:safe_neighborhood/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:safe_neighborhood/widgets/device_denied.dart';
import 'package:safe_neighborhood/widgets/loading_error_page.dart';
import 'package:safe_neighborhood/widgets/loading_page.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  late Map<dynamic, dynamic> allowedDevice;
  late String device;

  Future<void> getDevice() async {
    late String _device = '';
    try {
      _device = await DeviceInformation.deviceIMEINumber;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    if (!mounted) return;
    setState(() {
      device = _device;
      if (kDebugMode) {
        print('device: $device');
      }
    });
  }

  Future<Map> readAllowedDevice() async {
    await context
        .read<FirestoreRepository>()
        .readDevice()
        .then((value) => allowedDevice = value);
    if (kDebugMode) {
      print('dispositivo: ${allowedDevice['device']}');
    }
    return allowedDevice;
  }

  @override
  void initState() {
    super.initState();
    getDevice();
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    if (auth.isLoading) {
      return const LoadingPage();
    } else if (auth.usuario == null) {
      return const GetStarted();
    } else {
      return FutureBuilder<Map>(
          future: readAllowedDevice(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const LoadingPage();
              default:
                if (snapshot.hasError) {
                  return const ErrorPage();
                } else if (allowedDevice['device'] == device &&
                    allowedDevice['status']) {
                  return const HomePage();
                } else {
                  return const DeviceDenied();
                }
            }
          });
    }
  }
}
