import 'package:flutter/material.dart';
import 'package:safe_neighborhood/pages/cameraScreen.dart';

import '../theme/app_colors.dart';

class PlayCameras extends StatefulWidget {
  final String url1;
  final String name;
  final String url2;
  final String address;

  const PlayCameras(
      {Key? key,
      required this.url1,
      required this.name,
      required this.url2,
      required this.address})
      : super(key: key);

  @override
  State<PlayCameras> createState() => _PlayCamerasState();
}

class _PlayCamerasState extends State<PlayCameras>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late int camid;
  late String url;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      title: Text(widget.name),
      centerTitle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      titleTextStyle: const TextStyle(
          color: AppColors.textTitle,
          fontSize: 20,
          fontWeight: FontWeight.bold),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Colors.black,
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          onPressed: () {
            switch (_tabController.index) {
              case 0:
                print('camera 1 selecionada');
                break;
              case 1:
                print('camera 2 selecionada');
                break;
              default:
                break;
            }
          },
          icon: const Icon(
            Icons.warning_amber_rounded,
            size: 28,
            color: Colors.amber,
          ),
          color: Colors.black,
        ),
      ],
      bottom: TabBar(controller: _tabController, tabs: const [
        Tab(
          text: 'Câmera 1',
          icon: Icon(
            Icons.videocam_rounded,
            color: Colors.red,
          ),
        ),
        Tab(
          text: 'Câmera 2',
          icon: Icon(
            Icons.videocam_rounded,
            color: Colors.blue,
          ),
        ),
      ]),
    );
    var size = MediaQuery.of(context).size;
    var screenHeight = (size.height - appBar.preferredSize.height) -
        MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: appBar,
      body: TabBarView(
        controller: _tabController,
        children: [
          //show camera 1
          ScreenCamera(url: widget.url1, name: widget.name), //show camera 2
          ScreenCamera(url: widget.url2, name: widget.name),
        ],
      ),
    );
  }
}
