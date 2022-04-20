import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircularProgressIndicator(
            backgroundColor:
                Theme.of(context).primaryTextTheme.headline6?.color,
          ),
          const SizedBox(height: 25),
          Text(
            'Carregando dados...',
            style: TextStyle(
              color: Theme.of(context).primaryTextTheme.headline6?.color,
            ),
          ),
        ]),
      ),
    );
  }
}
