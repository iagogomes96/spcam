import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:provider/provider.dart';
import 'package:safe_neighborhood/pages/alert_page.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';
import 'package:safe_neighborhood/widgets/loading_error_page.dart';
import 'package:safe_neighborhood/widgets/loading_page.dart';

import '../components/firebase_repository.dart';

class CameraPage extends StatefulWidget {
  final String url;
  final String name;
  final String status;
  final String address;

  const CameraPage(
      {Key? key,
      required this.url,
      required this.name,
      required this.status,
      required this.address})
      : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late final VlcPlayerController _videoPlayerController;
  late String url = widget.url;
  late String name = widget.name;
  late String status = widget.status;
  late String address = widget.address;
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
      hwAcc: HwAcc.auto,
      autoPlay: true,
      options: VlcPlayerOptions(
        rtp: VlcRtpOptions(['--rtsp-tcp']),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text(name),
      centerTitle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      titleTextStyle: const TextStyle(
          color: AppColors.textTitle,
          fontSize: 20,
          fontWeight: FontWeight.bold),
    );
    var size = MediaQuery.of(context).size;
    var screenHeight = (size.height - appBar.preferredSize.height) -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AlertScreen(
                  device: name,
                ))),
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.warning_amber_rounded,
          color: AppColors.primaryText,
          size: 40,
        ),
      ),
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
                    Text(
                      address,
                      style: const TextStyle(
                          color: AppColors.secondaryText, fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    VlcPlayer(
                        controller: _videoPlayerController,
                        aspectRatio: 1.47,
                        placeholder: const Center(
                            child: CircularProgressIndicator(
                          value: 10,
                          color: Colors.white,
                        ))),
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: size.width / 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: AppColors.textTitle,
                              width: 2,
                              style: BorderStyle.solid),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Alertas'.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textTitle),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                                onTap: () =>
                                    setState(() => showAlert = !showAlert),
                                child: const Icon(Icons.arrow_drop_down)),
                          ],
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
            child: showAlert ? alertTile() : Container(),
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

  // ignore: unused_element
  Widget videoController() {
    bool _isPlaying = true;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: const Icon(
            Icons.fast_rewind,
            size: 28,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {
            if (_isPlaying) {
              setState(() {
                _isPlaying = false;
              });
              _videoPlayerController.pause();
            } else {
              setState(() {
                _isPlaying = true;
              });
              _videoPlayerController.play();
            }
          },
          child: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            size: 28,
            color: Colors.white,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Icon(
            Icons.fast_forward,
            size: 28,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
