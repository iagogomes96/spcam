import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safe_neighborhood/theme/app_colors.dart';

class AlertScreen extends StatefulWidget {
  const AlertScreen({Key? key}) : super(key: key);

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  bool validation = true;
  final _user = 'Fulano';
  final description = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late String _alert;
  bool value = false;
  String? selectedItem = 'Tipo de alerta';
  List<String> items = [
    'Tipo de alerta',
    'Assalto',
    'Atividade suspeita',
    'Acidente',
    'Evento natural/ambiental',
    'Problemas de iluminação',
    'Outros',
  ];

  createAlert() {
    setState(() {
      if (selectedItem == 'Tipo de alerta') {
        if (kDebugMode) {
          print('Selecione o tipo de alerta');
        }
        return;
      } else {
        String user = value ? 'Anônimo' : _user;

        _alert = '''Alerta : $selectedItem \n
    \n
    Descrição: ${description.text}
    \n
    Remetente: $user
    ''';
        if (kDebugMode) {
          print(_alert);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 100,
        title: const Text(
          'Criar Alerta',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.background,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
              child: alertTile(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  const Text(
                    'Descrição',
                    style: TextStyle(
                        color: AppColors.textTitle,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Adicione uma descrição do seu alerta',
                    style: TextStyle(
                        color: AppColors.textSubTitle,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: formKey,
                    child: TextFormField(
                      maxLength: 255,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: description,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Não é possível enviar alertas sem descrição';
                        }
                        return null;
                      },
                      minLines: 10,
                      maxLines: 10,
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.justify,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: Colors.white,
                              width: 2,
                              style: BorderStyle.solid),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Enviar alerta anonimamente',
                        style: TextStyle(
                            color: AppColors.textTitle,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.start,
                      ),
                      buildSwitch(),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Afirmo que as informações contidas neste alerta são verídicas',
                    style: TextStyle(
                        color: AppColors.textSubTitle,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            createAlert();
                          });
                        } else if (selectedItem == 'Tipo de alerta') {
                          setState(() {
                            validation = false;
                          });
                        } else {
                          setState(() {
                            validation = true;
                          });
                        }
                      },
                      child: const Text('Enviar alerta'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.minPositive, 45),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwitch() => Transform.scale(
        scale: 1,
        child: Switch.adaptive(
          activeColor: Colors.blue,
          activeTrackColor: Colors.blueAccent.withOpacity(0.4),
          value: value,
          onChanged: (value) => setState(() => this.value = value),
        ),
      );

  Widget buildIOSSwitch() => Transform.scale(
        scale: 1.1,
        child: CupertinoSwitch(
          value: value,
          onChanged: (value) => setState(() => this.value = value),
        ),
      );

  Widget buildAndroidSwitch() => Transform.scale(
        scale: 2,
        child: Switch(
          value: value,
          onChanged: (value) => setState(() => this.value = value),
        ),
      );

  Widget alertTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: validation ? Colors.white : Colors.red, width: 2)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          borderRadius: BorderRadius.circular(20),
          dropdownColor: AppColors.background.withOpacity(0.8),
          hint: const Text('Selecione o tipo de alerta'),
          isExpanded: true,
          value: selectedItem,
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                          fontSize: 18, color: AppColors.textTitle),
                    ),
                  ))
              .toList(),
          onChanged: (item) => setState(() {
            selectedItem = item;
            if (selectedItem == 'Tipo de alerta') {
              validation = false;
            } else {
              validation = true;
            }
          }),
        ),
      ),
    );
  }
}
