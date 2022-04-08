import 'package:flutter/material.dart';
import 'package:safe_neighborhood/components/allow_permissions.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                child: Image(
                  image: AssetImage('assets/images/get_started.png'),
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    height: 240,
                  ),
                  Text(
                    'Acesse as câmeras de vigilância do seu bairro. Envie e receba alertas em qualquer hora e em qualquer lugar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        'Deslize para iniciar',
                        textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                    repeatForever: true,
                    pause: const Duration(milliseconds: 1000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onHorizontalDragEnd: (details) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AllowPermissions()));
            },
          )
        ], //stack children
      ),
    );
  }
}
