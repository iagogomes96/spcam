import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:safe_neighborhood/pages/home_page.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final asset = 'assets/videos/logo.mp4';
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset(asset)
      ..addListener(() => setState(() {}))
      ..setLooping(false)
      ..initialize().then((value) => controller.play());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        AnimatedSplashScreen(
          duration: 3000,
          splash: const SizedBox(),
          nextScreen: const HomePage(),
          pageTransitionType: PageTransitionType.bottomToTop,
        ),
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.fill,
            child: SizedBox(
              height: controller.value.size.height,
              width: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        ),
      ],
    ));
  }
}
