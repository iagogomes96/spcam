import 'package:flutter/material.dart';
import 'package:nonce/nonce.dart';

class CodeGenerator extends StatefulWidget {
  const CodeGenerator({Key? key}) : super(key: key);

  @override
  State<CodeGenerator> createState() => _CodeGeneratorState();
}

class _CodeGeneratorState extends State<CodeGenerator> {
  late String code;
  List<String> codeList = [];
  late String text = 'Gerar código';

  @override
  void initState() {
    super.initState();
  }

  generateCode() {
    setState(() {
      codeList = [];
      code = Nonce.generate(6);
      text = code.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 32, color: Colors.white),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: generateCode,
              child: const Text('Gerar código'),
            ),
          ],
        ),
      ),
    );
  }
}
