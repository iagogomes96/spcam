import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_neighborhood/data/get_permissions.dart';
import 'package:safe_neighborhood/pages/sign_in_up.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';

class AllowPermissions extends StatefulWidget {
  const AllowPermissions({Key? key}) : super(key: key);

  @override
  State<AllowPermissions> createState() => _AllowPermissionsState();
}

class _AllowPermissionsState extends State<AllowPermissions> {
  bool permissions = false;
  Future<void> checkPermissions() async {
    var phoneStatus = await Permission.phone.status;
    if (phoneStatus.isGranted) {
      setState(() {
        permissions = true;
      });
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SignPage(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    if (permissions) {
      return const SignPage();
    } else {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body:
            PageView(physics: const NeverScrollableScrollPhysics(), children: [
          phonePermissions(),
        ]),
      );
    }
  }

  Widget phonePermissions() {
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
                    PermissionRequest().check_phone_permissions().then(
                          (value) => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignPage(),
                            ),
                          ),
                        );
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
