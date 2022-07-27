// ignore_for_file: file_names

import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safe_neighborhood/test/playCameras.dart';
import 'package:safe_neighborhood/widgets/loading_error_page.dart';
import 'package:safe_neighborhood/widgets/loading_page.dart';

import '../pages/profile.dart';
import '../theme/app_colors.dart';

class GetCameras extends StatefulWidget {
  const GetCameras({Key? key}) : super(key: key);

  @override
  State<GetCameras> createState() => _GetCamerasState();
}

class _GetCamerasState extends State<GetCameras> {
  final pageController = PageController(
    initialPage: 0,
  );

  Set<Marker> marcador = {};
  late Map<String, dynamic> camList;
  late List<Map<String, dynamic>> markers = [];
  late GoogleMapController mapController;
  late String _mapStyle;
  late String mapPlatform;
  late BitmapDescriptor onlineIcon;
  late BitmapDescriptor offlineIcon;
  late BitmapDescriptor warningIcon;
  late BitmapDescriptor iconstatus;
  bool _isMap = true;

  String url = "https://api.npoint.io/a083fc7a7e4bcda817d9";

  Future<Map<String, dynamic>> _getCameras() async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      camList = json.decode(response.body);
      return camList;
    } catch (e) {
      SnackBar(content: Text('Error: $e'));
      return camList = {};
    }
  }

  void _addData() {
    for (int i = 1; i <= camList['cameras'].length; i++) {
      markers.add({
        "address": camList['cameras'][i.toString()]['info']['address'],
        "camid": camList['cameras'][i.toString()]['info']['camid'],
        "position": camList['cameras'][i.toString()]['info']['position'],
        "source": camList['cameras'][i.toString()]['info']['source'],
        "status": camList['cameras'][i.toString()]['info']['status'],
        "title": camList['cameras'][i.toString()]['info']['title'],
        'url': camList['cameras'][i.toString()]['info']['url']
      });
      if (camList['cameras'][i.toString()]['info']['status']) {
        final Marker marker = Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(
              markers[i - 1]['position'][0], markers[i - 1]['position'][1]),
          infoWindow: InfoWindow(
            title: markers[i - 1]['title'],
            snippet: markers[i - 1]['status'] ? 'online' : 'offline',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => PlayCameras(
                      url1: markers[i - 1]['url'][0],
                      name: markers[i - 1]['title'],
                      url2: markers[i - 1]['url'][1],
                      address: markers[i - 1]['address'][0])),
                ),
              );
            },
          ),
          icon: onlineIcon,
        );
        marcador.add(marker);
      } else {
        final Marker marker = Marker(
          markerId: MarkerId(i.toString()),
          position: LatLng(
              markers[i - 1]['position'][0], markers[i - 1]['position'][1]),
          infoWindow: InfoWindow(
            title: markers[i - 1]['title'],
            snippet: markers[i - 1]['status'] ? 'online' : 'offline',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Câmera offline')));
            },
          ),
          icon: offlineIcon,
        );
        marcador.add(marker);
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  @override
  void initState() {
    super.initState();
    mapPlatform = 'assets/mapstyle.txt';

    rootBundle.loadString(mapPlatform).then((string) {
      _mapStyle = string;
    });
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(32, 32)),
            'assets/images/offline_camera.png')
        .then((onValue) {
      offlineIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(32, 32)),
            'assets/images/online_camera.png')
        .then((onValue) {
      onlineIcon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: _getCameras(),
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const LoadingPage();
                  default:
                    if (snapshot.hasError || camList.isEmpty) {
                      return const ErrorPage();
                    } else {
                      _addData();

                      return _isMap ? mapCameras() : listCameras();
                    }
                }
              }),
            ),
            topMenu(),
          ],
        ),
      ),
    );
  }

  Widget mapCameras() {
    final latitude = markers[0]['position'][0];
    final longitude = markers[0]['position'][1];
    final positionCamera = LatLng(latitude, longitude);
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: positionCamera, zoom: 16),
      markers: marcador,
      myLocationEnabled: true,
    );
  }

  Widget listCameras() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
      child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: marcador.length,
          itemBuilder: (context, index) {
            late String icon;
            final int i = (index + 1);
            if (camList['cameras'][i.toString()]['info']['status']) {
              icon = 'assets/images/online_camera.png';
            } else {
              icon = 'assets/images/offline_camera.png';
            }
            return InkWell(
              onTap: () {
                if (camList['cameras'][i.toString()]['info']['status']) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => PlayCameras(
                          url1: markers[i - 1]['url'][0],
                          name: markers[i - 1]['title'],
                          url2: markers[i - 1]['url'][1],
                          address: markers[i - 1]['address'][0])),
                    ),
                  );
                }
              },
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Image.asset(
                      icon,
                      fit: BoxFit.cover,
                      height: 48,
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            markers[i - 1]['title'],
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: AppColors.textTitle,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            markers[i - 1]['address'][0],
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: AppColors.textSubTitle,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget topMenu() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: CircleBorder(),
            ),
            child: IconButton(
              color: AppColors.primary,
              onPressed: () {
                setState(() {
                  _isMap = !_isMap;
                });
              },
              icon: !_isMap
                  ? const Icon(Icons.map_rounded)
                  : const Icon(Icons.list_rounded),
              iconSize: 32,
            ),
          ),
          Container(
            decoration: const ShapeDecoration(
                shape: CircleBorder(), color: Colors.white),
            child: IconButton(
              icon: const Icon(Icons.person_sharp),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              iconSize: 32,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
