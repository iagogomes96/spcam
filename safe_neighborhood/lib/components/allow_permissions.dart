import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_neighborhood/data/get_permissions.dart';
import 'package:safe_neighborhood/pages/sign_in_up.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';
import 'package:device_information/device_information.dart';

class AllowPermissions extends StatefulWidget {
  const AllowPermissions({Key? key}) : super(key: key);

  @override
  State<AllowPermissions> createState() => _AllowPermissionsState();
}

class _AllowPermissionsState extends State<AllowPermissions> {
  String _imeiNo = "";

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
  void initState() {
    super.initState();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    var phoneStatus = await Permission.phone.status;
    if (phoneStatus.isGranted) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SignPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: PageView(physics: const NeverScrollableScrollPhysics(), children: [
        PhonePermissions(),
      ]),
    );
  }

  Widget PhonePermissions() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                'Acesso aos dados do aparelho',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textTitle,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 50,
              ),
              Image(
                image: AssetImage('assets/images/device_info.png'),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'A utilização do App só é possível através da autenticação do dispositivo. Permita o acesso para poder utiliza-lo.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSubTitle, fontSize: 16),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    PermissionRequest().check_phone_permissions();
                    getIMEI();
                    checkPermissions();
                  });
                },
                child: const Text('Permitir'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
