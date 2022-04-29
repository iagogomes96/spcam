import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_neighborhood/components/firebase_repository.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';
import 'package:safe_neighborhood/widgets/loading_error_page.dart';
import 'package:safe_neighborhood/widgets/loading_page.dart';

class AuthCode extends StatefulWidget {
  const AuthCode({Key? key}) : super(key: key);

  @override
  State<AuthCode> createState() => _AuthCodeState();
}

class _AuthCodeState extends State<AuthCode> {
  final textController = TextEditingController();
  List<String> alertList = [];
  Stream<QuerySnapshot> _getAuth() {
    return context.read<FirestoreRepository>().getAlerts('Câmera 5');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(18),
        child: StreamBuilder<QuerySnapshot>(
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
        ),
      ),
    );
  }

  Widget listViewbuilder(
      BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    if (snapshot.data!.docs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 128,
                width: 128,
                child: Image.asset('assets/images/clear_list.png')),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Sem alertas ativos!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
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
                size: 40,
              ),
              title: Text(
                doc['type'].toString(),
                style: const TextStyle(
                    color: AppColors.background,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                doc['description'].toString(),
                style: const TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 16,
                ),
              ),
              trailing: GestureDetector(
                onTap: () => print('tap'),
                child: const Icon(
                  Icons.density_medium_rounded,
                  color: AppColors.background,
                  size: 18,
                ),
              ),
            ),
          );
        } else {
          alertList.remove(doc['type']);
          print(alertList);
        }
        return Container();
      }),
    );
  }
}
