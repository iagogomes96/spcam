import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Cameras'),
            centerTitle: true,
            bottom: const TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.map_outlined),
                ),
                Tab(
                  icon: Icon(Icons.list_outlined),
                ),
              ],
            ),
          ),
          body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Container(
                  color: Colors.red,
                ),
                Container(
                  color: Colors.green,
                ),
              ]),
        ));
  }
}
