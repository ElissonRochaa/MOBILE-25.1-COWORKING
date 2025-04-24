import 'package:Wellspace/views/CadastroPage.dart';

import 'package:flutter/material.dart';
// ajuste o caminho conforme a organização do seu projeto

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CadastroPage(),
    );
  }
}
