import 'package:flutter/material.dart';
import 'package:safe_neighborhood/components/get_started.dart';
import 'package:safe_neighborhood/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:safe_neighborhood/test/getCameras.dart';
import 'package:safe_neighborhood/widgets/loading_page.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    if (auth.isLoading) {
      return const LoadingPage();
    } else if (auth.usuario == null) {
      return const GetStarted();
    } else {
      return const GetCameras();
    }
  }
}
