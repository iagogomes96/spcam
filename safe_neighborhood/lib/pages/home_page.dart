import 'package:flutter/material.dart';
import 'package:safe_neighborhood/main.dart';
import 'package:safe_neighborhood/pages/profile.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:safe_neighborhood/pages/play_camera.dart';
import 'package:safe_neighborhood/widgets/loading_error_page.dart';
import 'package:safe_neighborhood/widgets/loading_page.dart';
import 'dart:io';

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
  late String mapPlatform;
  late BitmapDescriptor onlineIcon;
  late BitmapDescriptor offlineIcon;
  late BitmapDescriptor warningIcon;
  late BitmapDescriptor iconstatus;
  bool _isMap = true;
  late String filterText = '';
  late Map<dynamic, dynamic> mapData = {};

  Future<Map> _getData() async {
    if (mapData.isEmpty) {
      await getData().then((value) => setState(() => mapData = value));
      return mapData;
    }
    return mapData;
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      mapPlatform = 'assets/mapstyle.txt';
    } else if (Platform.isIOS) {
      mapPlatform = 'assets/mapstyle.txt';
    }
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

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64, 64)),
            'assets/images/warning_camera.png')
        .then((onValue) {
      warningIcon = onValue;
    });
  }

  void _setMarkers(String name, LatLng loc, String status, String url,
      String id, String address) async {
    if (status == 'offline') {
      final Marker marker = Marker(
        markerId: MarkerId(id),
        position: loc,
        infoWindow: InfoWindow(
          title: name,
          snippet: status,
          onTap: () {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Câmera offline')));
          },
        ),
        icon: offlineIcon,
      );
      markers.add(marker);
    } else {
      final Marker marker = Marker(
        markerId: MarkerId(id),
        position: loc,
        infoWindow: InfoWindow(
          title: name,
          snippet: status,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CameraPage(
                    url: url, name: name, status: status, address: address),
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
          FutureBuilder<Map>(
            future: _getData(),
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
                    final List<String> address = [];
                    for (int i = 1; i <= (groups.length - 1); i++) {
                      address.add(groups[i.toString()]['address']);
                      name.add(groups[i.toString()]['title']);
                      cameraPos.add(
                        LatLng(groups[i.toString()]['latlng'][0],
                            groups[i.toString()]['latlng'][1]),
                      );
                      camStatus.add(groups[i.toString()]['status']);
                      rtsp.add(groups[i.toString()]['url']);
                      _setMarkers(
                          name[i - 1],
                          cameraPos[i - 1],
                          camStatus[i - 1],
                          rtsp[i - 1],
                          i.toString(),
                          address[i - 1]);
                    }
                    return PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _isMap
                            ? GoogleMap(
                                mapType: MapType.normal,
                                onMapCreated: _onMapCreated,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(lat, long),
                                  zoom: 16,
                                ),
                                markers: markers,
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 100, 10, 10),
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(10),
                                    itemCount: groups.length - 1,
                                    itemBuilder: (context, index) {
                                      late String icon;
                                      if (camStatus[index] != 'online') {
                                        icon =
                                            'assets/images/offline_camera.png';
                                      } else {
                                        icon =
                                            'assets/images/online_camera.png';
                                      }
                                      return InkWell(
                                        onTap: () {
                                          if (camStatus[index] != 'offline') {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CameraPage(
                                                        url: rtsp[index],
                                                        name: name[index],
                                                        status:
                                                            camStatus[index],
                                                        address:
                                                            address[index]),
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
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      name[index],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: const TextStyle(
                                                        color:
                                                            AppColors.textTitle,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      address[index],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: const TextStyle(
                                                          color: AppColors
                                                              .textSubTitle,
                                                          fontSize: 14,
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
                              ),
                      ],
                    );
                  }
              }
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            child: Stack(
              children: [
                topMenu(),
                /*Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          filterText = text;
                        });
                      },
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          color: AppColors.primary, fontSize: 12),
                      decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          hintText: 'Pesquisar',
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
                ),*/
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
                pageController.previousPage(
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.easeIn);
              } else {
                pageController.nextPage(
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.easeIn);
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
