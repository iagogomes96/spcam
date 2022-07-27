import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeolocatorController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String error = '';
  late GoogleMapController _mapsController;
  late String _mapStyle;

  get mapsController => _mapsController;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    rootBundle.loadString('assets/mapstyle.txt').then((string) {
      _mapStyle = string;
      _mapsController.setMapStyle(_mapStyle);
    });

    getPosition();
  }

  getPosition() async {
    try {
      Position position = await _currentlyPosition();
      lat = position.latitude;
      long = position.longitude;
      _mapsController.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
    } catch (e) {
      lat = -23.5449955;
      long = -46.6742114;
      _mapsController.animateCamera(
          CameraUpdate.newLatLng(LatLng(lat, long))); //Centro de SP
      error = e.toString();
    }
    notifyListeners();
  }

  Future<Position> _currentlyPosition() async {
    LocationPermission permission;
    bool activatedService = await Geolocator.isLocationServiceEnabled();

    if (!activatedService) {
      return Future.error('Por favor, habilite a localização no smartphone');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error('Você precisa autorizar o acesso à localização');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Você precisa autorizar o acesso à localização');
    }
    return await Geolocator.getCurrentPosition();
  }
}
