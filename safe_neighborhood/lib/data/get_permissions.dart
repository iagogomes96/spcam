import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequest {
  // ignore: non_constant_identifier_names
  Future<void> check_phone_permissions() async {
    var phoneStatus = await Permission.phone.status;

    if (kDebugMode) {
      print(phoneStatus);
    }

    if (!phoneStatus.isGranted) {
      await Permission.phone.request();
    }
    if (await Permission.phone.isGranted) {
      return;
    } else {
      if (kDebugMode) {
        print("Acesso a localização do telefone foi recusado");
      }
    }
  }

  // ignore: non_constant_identifier_names
  Future<void> check_location_permissions() async {
    var locationStatus = await Permission.locationWhenInUse.status;
    if (kDebugMode) {
      print(locationStatus);
    }
    if (!locationStatus.isGranted) {
      await Permission.locationWhenInUse.request();
    }

    if (await Permission.locationWhenInUse.isGranted) {
      return;
    } else {
      if (kDebugMode) {
        print("Acesso a localização do telefone foi recusado");
      }
    }
  }
}
