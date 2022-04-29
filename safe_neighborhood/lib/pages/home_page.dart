import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safe_neighborhood/main.dart';
import 'package:safe_neighborhood/pages/profile.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:safe_neighborhood/pages/play_camera.dart';
import 'package:safe_neighborhood/widgets/loading_error_page.dart';
import 'package:safe_neighborhood/widgets/loading_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pageController = PageController(
    initialPage: 0,
  );
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
  bool _isMap = true;

  @override
  void initState() {
    super.initState();

    getData().then((map) {
      if (kDebugMode) {}
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
                    name: name,
                    status: status,
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
            snippet: 'Câmera operando normalmente',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraPage(
                    url: url,
                    name: name,
                    status: status,
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

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              FutureBuilder<Map>(
                future: getData(),
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const LoadingPage();
                    default:
                      if (snapshot.hasError) {
                        return const ErrorPage();
                      } else {
                        final Map<String, dynamic> groups =
                            snapshot.data!["cordeiro"];
                        final List<String> name = [];
                        final List<LatLng> cameraPos = [];
                        final List<String> rtsp = [];
                        final List<String> camStatus = [];
                        for (int i = 1; i <= (groups.length - 1); i++) {
                          name.add(groups[i.toString()]['title']);
                          cameraPos.add(
                            LatLng(groups[i.toString()]['latlng'][0],
                                groups[i.toString()]['latlng'][1]),
                          );
                          camStatus.add(groups[i.toString()]['status']);
                          rtsp.add(groups[i.toString()]['url']);
                          _setMarkers(name[i - 1], cameraPos[i - 1],
                              camStatus[i - 1], rtsp[i - 1], i.toString());
                        }
                        return GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(lat, long),
                            zoom: 16,
                          ),
                          markers: markers,
                        );
                      }
                  }
                }),
              ),
              FutureBuilder<Map>(
                future: getData(),
                builder: ((context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const LoadingPage();
                    default:
                      if (snapshot.hasError) {
                        return const ErrorPage();
                      } else {
                        final Map<String, dynamic> groups =
                            snapshot.data!["cordeiro"];
                        final List<String> name = [];
                        final List<LatLng> cameraPos = [];
                        final List<String> rtsp = [];
                        final List<String> camStatus = [];
                        for (int i = 1; i <= (groups.length - 1); i++) {
                          name.add(groups[i.toString()]['title']);
                          cameraPos.add(
                            LatLng(groups[i.toString()]['latlng'][0],
                                groups[i.toString()]['latlng'][1]),
                          );
                          camStatus.add(groups[i.toString()]['status']);
                          rtsp.add(groups[i.toString()]['url']);
                          _setMarkers(name[i - 1], cameraPos[i - 1],
                              camStatus[i - 1], rtsp[i - 1], i.toString());
                        }
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(10, 100, 10, 10),
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
                                            name: name[index],
                                            status: camStatus[index],
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
                                          height: 50,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                name[index],
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  color: AppColors.textTitle,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                'Status: ${camStatus[index]}',
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    color:
                                                        AppColors.textSubTitle,
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                  }
                }),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Stack(
              children: [
                topMenu(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: AppColors.primary, fontSize: 12),
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          hintText: 'Buscar: câmeras e endereços',
                          hintStyle: TextStyle(
                              color: AppColors.background.withOpacity(0.6),
                              fontSize: 12),
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 0),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.6)),
                              borderRadius: BorderRadius.circular(45))),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget topMenu() {
    return Row(
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
              if (_isMap) {
                if (kDebugMode) {
                  print('Tela de mapa');
                  pageController.previousPage(
                      duration: const Duration(milliseconds: 10),
                      curve: Curves.easeIn);
                }
              } else {
                if (kDebugMode) {
                  print('Tela de lista');
                  pageController.nextPage(
                      duration: const Duration(milliseconds: 10),
                      curve: Curves.easeIn);
                }
              }
            },
            icon: !_isMap
                ? const Icon(Icons.map_rounded)
                : const Icon(Icons.list_rounded),
            iconSize: 32,
          ),
        ),
        Container(
          decoration:
              const ShapeDecoration(shape: CircleBorder(), color: Colors.white),
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
    );
  }
}
