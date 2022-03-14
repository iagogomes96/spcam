import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_neighborhood/main.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:safe_neighborhood/pages/play_camera.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late PageController pageController = PageController();
  late GoogleMapController mapController;
  Set<Marker> markers = <Marker>{};
  double lat = -23.6377555;
  double long = -46.6820983;
  double zoom = 16.0;

  late String _mapStyle;
  late BitmapDescriptor onlineIcon;
  late BitmapDescriptor offlineIcon;
  late BitmapDescriptor warningIcon;
  late BitmapDescriptor iconstatus;

  @override
  void initState() {
    super.initState();

    getData().then((map) {
      if (kDebugMode) {
        //print(map);
      }
    });
    rootBundle.loadString('assets/mapstyle.txt').then((string) {
      _mapStyle = string;
    });
    markers.removeAll(markers);
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64, 64)),
            'assets/images/offline_camera.png')
        .then((onValue) {
      offlineIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64, 64)),
            'assets/images/online_camera.png')
        .then((onValue) {
      onlineIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64, 64)),
            'assets/images/warning_camera.png')
        .then((onValue) {
      warningIcon = onValue;
    });
  }

  void _setMarkers(
      String name, LatLng loc, String status, String url, String id) async {
    switch (status) {
      case 'offline':
        final Marker marker = Marker(
          markerId: MarkerId(id),
          position: loc,
          infoWindow: InfoWindow(
            title: name,
            snippet: status,
            onTap: () {},
          ),
          icon: offlineIcon,
        );
        markers.add(marker);
        break;
      case 'warning':
        final Marker marker = Marker(
          markerId: MarkerId(id),
          position: loc,
          infoWindow: InfoWindow(
            title: name,
            snippet: 'Em Alerta! Central verificando',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraPage(
                    url: url,
                  ),
                ),
              );
            },
          ),
          icon: warningIcon,
        );
        markers.add(marker);
        break;
      default:
        final Marker marker = Marker(
          markerId: MarkerId(id),
          position: loc,
          infoWindow: InfoWindow(
            title: name,
            snippet: 'Em Alerta! Central verificando',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraPage(
                    url: url,
                  ),
                ),
              );
            },
          ),
          icon: onlineIcon,
        );
        markers.add(marker);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }

  void _listchanger(bool state) {
    if (state == false) {
      pageController.animateToPage(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    } else {
      pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _listchanger(false),
            icon: const Icon(
              Icons.map_outlined,
            ),
          ),
          IconButton(
            onPressed: () => _listchanger(true),
            icon: const Icon(Icons.list),
          ),
        ],
        title: const Text(
          'Google Map',
          textAlign: TextAlign.center,
        ),
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.error_outline,
                        size: 100,
                      ),
                      Text(
                        'Erro ao carregar mapa',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                final Map<String, dynamic> groups = snapshot.data!["cordeiro"];
                final List<String> name = [];
                final List<LatLng> cameraPos = [];
                final List<String> rtsp = [];
                List<String> camStatus = [
                  'online',
                  'offline',
                  'online',
                  'online',
                  'online',
                  'offline',
                  'warning',
                  'online',
                  'online',
                  'online',
                  'online',
                  'online'
                ];
                for (int i = 1; i <= (groups.length - 1); i++) {
                  name.add(groups[i.toString()]['title']);
                  cameraPos.add(
                    LatLng(groups[i.toString()]['latlng'][0],
                        groups[i.toString()]['latlng'][1]),
                  );
                  rtsp.add(groups[i.toString()]['url']);
                  _setMarkers(name[i - 1], cameraPos[i - 1], camStatus[i - 1],
                      rtsp[i - 1], i.toString());
                }
                return PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageController,
                  children: [
                    GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(lat, long),
                        zoom: 16,
                      ),
                      markers: markers,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.2, 1],
                          colors: [
                            Color.fromARGB(255, 26, 30, 40),
                            Color.fromARGB(255, 46, 59, 65),
                          ],
                        ),
                      ),
                      child: ListView.builder(
                          padding: const EdgeInsets.all(4),
                          itemCount: groups.length - 1,
                          itemBuilder: (context, index) {
                            late String icon;
                            if (camStatus[index] != 'online') {
                              if (camStatus[index] == 'offline') {
                                icon = 'assets/images/offline_camera.png';
                              } else if (camStatus[index] == 'warning') {
                                icon = 'assets/images/warning_camera.png';
                              }
                            } else {
                              icon = 'assets/images/online_camera.png';
                            }
                            return InkWell(
                              onTap: () {
                                if (camStatus[index] != 'offline') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CameraPage(
                                        url: rtsp[index],
                                      ),
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
                                      height: 100,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Camera ${name[index]}',
                                            style: const TextStyle(
                                              color: Colors.white10,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            'Status: ${camStatus[index]}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
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
                    ),
                  ],
                );
              }
          }
        },
      ),
    );
  }
}
