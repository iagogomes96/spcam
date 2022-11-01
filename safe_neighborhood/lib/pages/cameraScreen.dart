// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:provider/provider.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';
import 'package:safe_neighborhood/widgets/loading_error_page.dart';
import 'package:safe_neighborhood/widgets/loading_page.dart';

import '../components/firebase_repository.dart';

class ScreenCamera extends StatefulWidget {
  final String url;
  final String name;
  final double screenheight;

  const ScreenCamera(
      {Key? key,
      required this.url,
      required this.name,
      required this.screenheight})
      : super(key: key);

  @override
  State<ScreenCamera> createState() => _ScreenCameraState();
}

class _ScreenCameraState extends State<ScreenCamera> {
  bool isPlaying = false;
  late final VlcPlayerController _videoPlayerController;
  late String url = widget.url;
  late String name = widget.name;
  bool showAlert = false;
  List<String> alertList = [];
  Stream<QuerySnapshot> _getAuth() {
    return context.read<FirestoreRepository>().getAlerts(name);
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      url,
      hwAcc: HwAcc.full,
      autoInitialize: true,
      autoPlay: true,
      options: VlcPlayerOptions(
        rtp: VlcRtpOptions(['--rtsp-tcp']),
      ),
    );
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Erro ao reproduzir conteúdo. Contate a central')),
        );
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var screenHeight = widget
        .screenheight; //(size.height) - MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: size.width,
            height: screenHeight / 2,
            child: Column(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.black,
                      child: VlcPlayer(
                        controller: _videoPlayerController,
                        aspectRatio: 1.47,
                        placeholder: const Center(
                          child: CircularProgressIndicator(
                            value: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            width: size.width,
            height: screenHeight / 2,
            child: alertTile(),
          ),
        ],
      ),
    );
  }

  Widget alertTile() {
    return StreamBuilder<QuerySnapshot>(
      stream: _getAuth(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const LoadingPage();
          default:
            if (snapshot.hasError) {
              return const ErrorPage();
            } else {
              return listViewbuilder(context, snapshot);
            }
        }
      },
    );
  }

  Widget listViewbuilder(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.data!.docs.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 100,
              width: 100,
              child: Image.asset('assets/images/clear_list.png')),
          const Text(
            'Sem alertas ativos!',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: ((context, index) {
        final DocumentSnapshot doc = snapshot.data!.docs[index];
        if (doc['value']) {
          alertList.add(doc['type']);
          if (kDebugMode) {
            print('lista: $alertList');
          }
          return Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              enabled: false,
              leading: const Icon(
                Icons.warning_rounded,
                color: Colors.red,
                size: 38,
              ),
              title: Text(
                doc['type'].toString(),
                style: const TextStyle(
                    color: AppColors.background,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                doc['description'].toString(),
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 12,
                ),
              ),
              trailing: GestureDetector(
                // ignore: avoid_print
                onTap: () => print('tap ${doc['type']}'),
                child: const Icon(
                  Icons.density_medium_rounded,
                  color: AppColors.background,
                  size: 14,
                ),
              ),
            ),
          );
        } else {
          alertList.remove(doc['type']);
        }
        return Container();
      }),
    );
  }
}
