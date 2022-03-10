import 'package:flutter/material.dart';
import 'package:safe_neighborhood/pages/login.dart';
import 'package:safe_neighborhood/pages/map.page.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const request = "https://api.npoint.io/67dc7f362a61d92bb6a5";

void main() async{
  //print(await getData());
  runApp(const MyApp());
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
      home: const MapPage(),
      theme: ThemeData(
          primaryColor: Colors.white,
          inputDecorationTheme: const InputDecorationTheme(
          )),
    );
  }
}
