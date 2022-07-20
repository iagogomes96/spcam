import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:safe_neighborhood/components/firebase_repository.dart';
import 'package:safe_neighborhood/widgets/loading_error_page.dart';
import 'package:safe_neighborhood/widgets/loading_page.dart';

class mapLoader extends StatefulWidget {
  const mapLoader({Key? key}) : super(key: key);

  @override
  State<mapLoader> createState() => _mapLoaderState();
}

class _mapLoaderState extends State<mapLoader> {
  final pageController = PageController(
    initialPage: 0,
  );
  late GoogleMapController mapController;
  Set<Marker> markers = <Marker>{};
  double lat = -23.6485085;
  double long = -46.7005737;
  GeoPoint loc = const GeoPoint(-23.6485085, -46.7005737);
  double zoom = 16.0;

  late int camLenght;
  late String _mapStyle;
  late String mapPlatform;
  late BitmapDescriptor onlineIcon;
  late BitmapDescriptor offlineIcon;
  late BitmapDescriptor warningIcon;
  late BitmapDescriptor iconstatus;
  bool _isMap = true;
  late String filterText = '';
  late Map<dynamic, dynamic> mapData = {};

  Stream<QuerySnapshot> _getCameras() {
    return context.read<FirestoreRepository>().getCameras();
  }

  Stream<QuerySnapshot> _getCameraInfo(String device) {
    return context.read<FirestoreRepository>().getCameraInfo(device);
  }

  Future<int> getCameraLenght() async {
    int cameras = await _getCameras().length;
    if (kDebugMode) {
      print('cameras online: $cameras');
    }
    return cameras;
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
    markers.removeAll(markers);
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
    return StreamBuilder<QuerySnapshot>(
      stream: _getCameras(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const LoadingPage();
          default:
            if (snapshot.hasError) {
              return const ErrorPage();
            } else {
              camLenght = snapshot.data!.docs.length;
              if (kDebugMode) {
                print('cameras: $camLenght');
              }
              getCameraLenght();
              return GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(loc.latitude, loc.longitude), zoom: 17),
                onMapCreated: _onMapCreated,
              );
            }
        }
      },
    );
  }
}
