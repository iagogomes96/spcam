import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safe_neighborhood/components/firebase_repository.dart';
import 'package:safe_neighborhood/services/auth_service.dart';
import 'package:safe_neighborhood/theme/app_theme.dart';
import 'package:safe_neighborhood/widgets/auth_check.dart';

const request = "https://api.jsonbin.io/b/626ff23d38be296761fb3211/1";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => AuthService())),
        ChangeNotifierProvider(
            create: (context) =>
                FirestoreRepository(auth: context.read<AuthService>())),
      ],
      child: const MyApp(),
    ),
  );
}

enum MenuItem {
  editProfile,
  settings,
  logout,
}

Future<Map> getData() async {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SP Cam APP',
      theme: AppTheme(context).defaultTheme,
      home: const AuthCheck(),
    );
  }
}
