import 'package:Wellspace/views/AlugarPage.dart';
import 'package:Wellspace/views/EspacoPage.dart';
import 'package:flutter/material.dart';
import 'package:Wellspace/views/CadastroPage.dart';
import 'package:Wellspace/views/LoginPage.dart';
import 'package:Wellspace/views/HomePage.dart';
import 'package:Wellspace/views/CadastroSalaPage.dart';
import 'package:Wellspace/views/profile/ProfilePage.dart';

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
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginPage(),
        '/cadastro': (context) => CadastroPage(),
        '/home': (context) => HomePage(),
        '/alugar': (context) => Alugapage(),
        '/cadastroSala': (context) => CadastroSalaPage(),
        '/Perfil': (context) => ProfilePage(),
        '/espacos': (context) => EspacosPage()
      },
    );
  }
}
