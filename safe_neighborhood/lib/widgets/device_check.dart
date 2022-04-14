import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DeviceCheck extends StatefulWidget {
  final String imei;
  final String userID;
  const DeviceCheck({Key? key, required this.imei, required this.userID})
      : super(key: key);

  @override
  State<DeviceCheck> createState() => _DeviceCheckState();
}

class _DeviceCheckState extends State<DeviceCheck> {
  late Map<String, dynamic> allowedDevices = {};
  late final _imei = widget.imei;
  // ignore: unused_field
  late final _userID = widget.userID;
  FirebaseFirestore db = FirebaseFirestore.instance;

  checkDevice() {
    allowedDevices =
        db.collection('devices').doc('allowed').get() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    if (_imei == allowedDevices['IMEI'][_imei] &&
        allowedDevices['IMEI'][_imei]['status'] == true) {
      return Container(
        color: Colors.amber,
      );
    } else {
      return Container(
        color: Colors.blue,
      );
    }
  }
}
