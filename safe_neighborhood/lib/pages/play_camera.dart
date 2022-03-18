import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class CameraPage extends StatefulWidget {
  final String url;

  const CameraPage({Key? key, required this.url}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late final VlcPlayerController _videoPlayerController;

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
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VlcPlayer(
            controller: _videoPlayerController,
            aspectRatio: 4 / 3,
            placeholder: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _videoController() {
    bool _isPlaying = true;
    return Row(
      children: [
        TextButton(
          onPressed: () {},
          child: const Icon(
            Icons.fast_rewind,
            size: 28,
            color: Colors.black,
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
            color: Colors.black,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Icon(
            Icons.fast_forward,
            size: 28,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
