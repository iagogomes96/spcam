import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:safe_neighborhood/test/playCameras.dart';
import 'package:safe_neighborhood/widgets/loading_error_page.dart';
import 'package:safe_neighborhood/widgets/loading_page.dart';

class GetCameras extends StatefulWidget {
  const GetCameras({Key? key}) : super(key: key);

  @override
  State<GetCameras> createState() => _GetCamerasState();
}

class _GetCamerasState extends State<GetCameras> {
  Set<Marker> marcador = {};
  late Map<String, dynamic> camList;
  late List<Map<String, dynamic>> markers = [];
  late GoogleMapController mapController;

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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get Cameras')),
      body: FutureBuilder<Map<String, dynamic>>(
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
                if (kDebugMode) {
                  print('lista: $camList');
                }
                for (int i = 1; i <= camList['cameras'].length; i++) {
                  markers.add({
                    "address": camList['cameras'][i.toString()]['info']
                        ['address'],
                    "camid": camList['cameras'][i.toString()]['info']['camid'],
                    "position": camList['cameras'][i.toString()]['info']
                        ['position'],
                    "source": camList['cameras'][i.toString()]['info']
                        ['source'],
                    "status": camList['cameras'][i.toString()]['info']
                        ['status'],
                    "title": camList['cameras'][i.toString()]['info']['title'],
                    'url': camList['cameras'][i.toString()]['info']['url']
                  });
                  final Marker marker = Marker(
                    markerId: MarkerId(i.toString()),
                    position: LatLng(markers[i - 1]['position'][0],
                        markers[i - 1]['position'][1]),
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
                    flat: true,
                  );
                  print(
                      'marcadores: ${markers[i - 1]['url'][0]},${markers[i - 1]['url'][1]},${markers[i - 1]['title']},${markers[i - 1]['address'][0]}');
                  marcador.add(marker);
                }

                if (kDebugMode) {
                  print('marcador: $markers');
                }

                final latitude = markers[0]['position'][0];
                final longitude = markers[0]['position'][1];
                final positionCamera = LatLng(latitude, longitude);
                print('position: ${markers[0]['position'][0]}');
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition:
                      CameraPosition(target: positionCamera, zoom: 16),
                  markers: marcador,
                );
              }
          }
        }),
      ),
    );
  }
}
