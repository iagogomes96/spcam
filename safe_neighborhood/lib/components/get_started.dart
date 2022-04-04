import 'package:flutter/material.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 1],
          colors: [
            Color.fromARGB(255, 26, 30, 40),
            Color.fromARGB(255, 46, 59, 65),
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            const Image(
              image: AssetImage('assets/images/reallogo.png'),
              width: 150,
              height: 150,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'SPCam',
              style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.headline6?.color,
                  fontSize: 25),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
                onPressed: () {},
                child: const Text(
                  'Iniciar',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
