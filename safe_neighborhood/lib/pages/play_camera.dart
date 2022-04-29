import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:safe_neighborhood/pages/alert_page.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';

class CameraPage extends StatefulWidget {
  final String url;
  final String name;
  final String status;

  const CameraPage(
      {Key? key, required this.url, required this.name, required this.status})
      : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late final VlcPlayerController _videoPlayerController;
  late String url = widget.url;
  late String name = widget.name;
  late String status = widget.status;
  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      widget.url,
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(
        rtp: VlcRtpOptions(['--rtsp-tcp']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(name),
        titleTextStyle: const TextStyle(
            color: AppColors.textTitle,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AlertScreen(
                  device: name,
                ))),
        backgroundColor: AppColors.primary.withOpacity(0.2),
        child: const Icon(
          Icons.warning_amber_rounded,
          color: AppColors.primaryText,
          size: 40,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VlcPlayer(
              controller: _videoPlayerController,
              aspectRatio: 4 / 3,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              status,
              style:
                  const TextStyle(color: AppColors.secondaryText, fontSize: 16),
            ),
          ],
        ),
      ),
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
