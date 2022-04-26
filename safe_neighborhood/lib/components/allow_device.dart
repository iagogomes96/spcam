import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_information/device_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_neighborhood/components/firebase_repository.dart';
import 'package:safe_neighborhood/pages/home_page.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';

class AllowDevice extends StatefulWidget {
  const AllowDevice({Key? key}) : super(key: key);

  @override
  State<AllowDevice> createState() => _AllowDeviceState();
}

class _AllowDeviceState extends State<AllowDevice> {
  late String _imeiNo;
  User? userID;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late Map<String, dynamic> allowedIMEI = {};

  @override
  void initState() {
    super.initState();
    getIMEI();
  }

  Future<void> getIMEI() async {
    late String imeiNo;
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

  Future<void> associateIMEI() async {
    try {
      await context.read<FirestoreRepository>().allowDevice(_imeiNo);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Associar dipositivo',
                style: TextStyle(
                    color: AppColors.textTitle,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: Text(
                  'Parabéns, seu cadastro foi um sucesso! Para continuar é necessário associar este dispositivo à sua conta',
                  style: TextStyle(color: AppColors.primaryText, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              ElevatedButton(
                  onPressed: //associateIMEI
                      () => associateIMEI().then(
                            (value) => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            ),
                          ),
                  child: Text('Associar dispositivo'.toUpperCase()))
            ],
          ),
        ),
      ),
    );
  }
}
