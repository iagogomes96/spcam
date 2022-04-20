import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_information/device_information.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safe_neighborhood/pages/home_page.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';

class AllowDevice extends StatefulWidget {
  const AllowDevice({Key? key}) : super(key: key);

  @override
  State<AllowDevice> createState() => _AllowDeviceState();
}

class _AllowDeviceState extends State<AllowDevice> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _imeiNo;
  late String _userID;
  User? userID;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late Map<String, dynamic> allowedIMEI = {};

  @override
  void initState() {
    super.initState();
    getIMEI();
  }

  _getUser() {
    userID = _auth.currentUser;
    _userID = userID!.uid;

    if (kDebugMode) {
      print(_userID);
    }
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
      if (kDebugMode) {
        print(_imeiNo);
      }
    });
  }

  Future<void> associateIMEI() async {
    final String imei = _imeiNo;
    _getUser();
    try {
      await db.collection('devices').doc('allowed').set({
        'IMEI': imei,
        'userID': _userID,
        'status': true,
      });
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()));
    } catch (e) {
      null;
    }
    if (kDebugMode) {
      print('IMEI: $imei, usuario: $_userID');
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
                      () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const HomePage())),
                  child: Text('Associar dispositivo'.toUpperCase()))
            ],
          ),
        ),
      ),
    );
  }
}
