import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  double lat = -23.6377555;
  double long = -46.6820983;
  double zoom = 16.0;

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
              //screateMarkers(context, snapshot);
              return GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: LatLng(lat, long), zoom: 15),
                onMapCreated: _onMapCreated,
              );
            }
        }
      },
    );
  }

  void createMarkers(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    int listLength = snapshot.data!.docs.length;
    int i = 0;
    if (snapshot.data!.docs.isEmpty) {
      if (kDebugMode) {
        print('Não há dados');
      }
    } else {
      if (kDebugMode) {
        print('Tamanho da lista: $listLength');
      }
    }
  }
}
